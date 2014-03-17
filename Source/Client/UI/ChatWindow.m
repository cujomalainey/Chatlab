function [] = ChatWindow(name, key)
%ChatWindow Create And Display The Client-Side UI Along With All Of The Logic Behind The Client

%% Get a window
Chat.Window = NewWindow(['Chat : Logged in as ', name], 670, 439, @windowWillClose);

%% Get the channel for communication
Chat.ChannelManager = ChannelManager.instance(); % Should carry over from the old instance
Chat.ChannelManager.setCallback(@receiveMessage);
%% Get the key for encryption
Chat.Keys.Server = key;
Chat.Keys.Client = KeyManager();
Chat.User = name;

%% Get the GUI Manager
GUI = GUIManager.instance();
%% Create the GUI
InputPosition = [10, 10, 590, 20];
Chat.InputTextField = GUI.newTextField(Chat.Window, InputPosition, @textFieldEnter, 1);

ButtonPosition = [610, 10, 50, 20];
Chat.Button = GUI.newButton(Chat.Window, ButtonPosition, 'Send', @textFieldEnter, 1);

Chat.ChatPane = ChatPane(Chat.Window, [0, 40, 470, 400], @leaveChat);

TreeBackgroundPosition = [470, 40, 200, 400];
Chat.TreeBackground = GUI.newTabPanel(Chat.Window, TreeBackgroundPosition, 1);
Chat.TreeBackground.addTab('Online Users', []);

Chat.List = GUI.newListBox(Chat.Window, [480, 53, 180, 354], @clickList, 1);
if (~sendUserListRequestPacket(Chat.ChannelManager.getChannel(), Chat.Keys.Server))
	serverDisconnected();
end

% Create the PostInit Timer
Server.initTimer = timer('TimerFcn', @postInit,...
	'Name', 'Init Timer',...
	'StartDelay', 0.1...
	);
start(Server.initTimer);

%% Initialize some state values
Chat.SelectedPerson = '';
Chat.Menu = uicontextmenu;

	function postInit(~,~)
		stop(Server.initTimer);
		Chat.InputTextField.setFocus();
		delete(Server.initTimer);
	end

%% Text Field Callback
	function textFieldEnter(~, ~)
		if (Chat.ChatPane.getCurrentTabIndex >= 0)
			string = char(Chat.InputTextField.getText());
			if (isempty(string))
				return;
			end
			id = Chat.ChatPane.getSelectedChatID();
			if (strcmp(string(1), '/'))
				% Check for the /clear command
				if (strcmpi(string, '/clear'))
					Chat.ChatPane.clearTextByID(id);
					Chat.InputTextField.setText('');
					return;
				end
				% Do not encrypt -- This is a command
				message = string;
			else
				message = sprintf('%s: %s', Chat.User, string);
				message = Encryptor.encrypt(message, Chat.Keys.Client.getKey(id));
			end
			if (~sendChatPacket(Chat.ChannelManager.getChannel(), Chat.User, id, message, Chat.Keys.Server))
				serverDisconnected();
				return;
			end
		end
		Chat.InputTextField.setText('');
	end

	function clickList(~, event)
		% Select an item
		if (event.getButton() == 3)
			Chat.List.selectIndexAtPosition(event.getPoint());
		end
		
		Chat.SelectedPerson = Chat.List.getSelectedValue();
		if (isempty(Chat.SelectedPerson))
			return;
		end
		
		if (Chat.Menu)
			delete(Chat.Menu);
		end
		
		Chat.Menu = uicontextmenu(); %this menu is static
		uimenu(Chat.Menu, 'Label', Chat.SelectedPerson, 'Enable', 'off');
		uimenu(Chat.Menu, 'Label', 'Start Chat', 'Separator', 'on', 'Callback', @startChat);
		if (Chat.ChatPane.getCurrentTabIndex >= 0)
			uimenu(Chat.Menu, 'Label', 'Invite To Current Chat', 'Separator', 'on', 'Callback', @inviteToChat);
		end
		
		windowPos = get(Chat.Window, 'Position');
		screenSize = get(0, 'ScreenSize');
		set(Chat.Menu, 'Position', [event.getXOnScreen() - windowPos(1), screenSize(4) - windowPos(2) + 2  - event.getYOnScreen()]);
		set(Chat.Menu, 'Visible', 'on');
		
		Chat.List.deselect();
	end

%% ContextMenu Callback
	function startChat(~,~)
		if (~sendChatStartRequestPacket(Chat.ChannelManager.getChannel(), Chat.SelectedPerson, Chat.Keys.Server))
			serverDisconnected();
		end
	end

	function inviteToChat(~,~)
		if (Chat.ChatPane.getSelectedChatID() > 0)
			if (~sendChatInvitePacket(Chat.ChannelManager.getChannel(), Chat.ChatPane.getSelectedChatID(), Chat.SelectedPerson, Chat.Keys.Server))
				serverDisconnected();
			end
		end
	end

	function leaveChat(id)
		if (~sendChatLeavePacket(Chat.ChannelManager.getChannel(), id, Chat.Keys.Server))
			serverDisconnected();
		end
	end

%% Network callback
	function receiveMessage(event)
		message = char(event.message);
		%% Decrypt The String
		try
			if (isempty(str2num([message, ';']))) %#ok<ST2NM>
				error('Not A Matrix');
			end
			message = Encryptor.decrypt(message, Chat.Keys.Server);
		catch
		end
		try
			packet = JSON.parse(message);
		catch
			return; % It was a fake message
		end
		if (~isfield(packet, 'Type'))
			% Invalid packet so discard
			return;
		end
		switch packet.Type
			case 'UserList'
				handleUserList(packet);
			case 'StartedChat'
				handleStartedChat(packet);
			case 'ChatInvite'
				handleChatInvite(packet);
			case 'InviteFailed'
				errordlg(sprintf('Could not invite %s to chat.', packet.Name), 'Error', 'modal');
			case 'Message'
				handleMessage(packet);
			case 'ChatShakeResponse'
				handleChatShakeResponse(packet);
			case 'ChatShakeDone'
				handleChatShakeDone(packet);
			case 'Rekey'
				handleRekey(packet);
			case 'ChatRenamed'
				handleChatRenamed(packet);
			case 'ChatKicked'
				handleChatKicked(packet);
			case 'Disconnect'
				serverDisconnected();
		end
	end

	function handleUserList(packet)
		list = packet.List;
		i = 0;
		while i < length(list)
			i = i + 1;
			if (strcmp(list{i}, Chat.User))
				list(i) = [];
			end
		end
		Chat.List.setData(list);
	end

	function handleStartedChat(packet)
		id = packet.ID;
		if (packet.Joining)
			rekeyAsClient(id);
		else
			rekeyAsOwner(id);
		end
		Chat.ChatPane.addTab(packet.Name, id);
		Chat.ChatPane.setSelectedTabByID(id);
	end

	function handleChatShakeResponse(packet)
		username = packet.User;
		id = packet.ChatID;
		tempKey = Chat.Keys.Client.finishKey(packet.Key, username);
		clientKey = Chat.Keys.Client.getKey(username);
		chatKey = Chat.Keys.Client.getKey(id);
		if (~sendHandshakeChatDonePacket(Chat.ChannelManager.getChannel(), tempKey, username, id, Encryptor.encrypt(mat2str(chatKey), clientKey), Chat.Keys.Server))
			serverDisconnected();
		end
	end

	function handleChatInvite(packet)
		accept = questdlg(sprintf('%s would like to chat with you.', packet.Name), 'Chat Invite', 'Deny', 'Accept', 'Deny');
		if (~sendChatInviteResponsePacket(Chat.ChannelManager.getChannel(), packet.ID, int8(strcmp(accept, 'Accept')), Chat.Keys.Server))
			serverDisconnected();
		end
	end

	function handleChatShakeDone(packet)
		id = packet.ChatID;
		chatKey = packet.ChatKey;
		tempKey = packet.Key;
		Chat.Keys.Client.addKey(tempKey, id);
		chatKey = str2num(Encryptor.decrypt(chatKey, Chat.Keys.Client.getKey(id))); %#ok<ST2NM>
		Chat.Keys.Client.setKey(id, chatKey);
	end

	function handleMessage(packet)
		id = packet.ChatID;
		sender = packet.Sender;
		message = packet.Message;
		if (~strcmp(sender, 'Server'))
			message = Encryptor.decrypt(message, Chat.Keys.Client.getKey(id));
		end
		% Verify the integrity of the message
		s = strsplit(message,':');
		if ((strcmp(sender, s(1))) || ((length(s) == 1) && strcmp(sender, 'Server')))
			Chat.ChatPane.printTextByID(id, message);
		end
	end

	function handleRekey(packet)
		if (packet.Owner)
			rekeyAsOwner(packet.ID);
		else
			rekeyAsClient(packet.ID);
		end
	end

	function handleChatRenamed(packet)
		id = packet.ChatID;
		newName = packet.Name;
		Chat.ChatPane.setTabNameByID(id, newName);
	end

	function handleChatKicked(packet)
		id = packet.ChatID;
		Chat.ChatPane.closeTabByID(id);
	end

	function rekeyAsClient(id)
		tempKey = Chat.Keys.Client.buildKey(id);
		if (~sendHandshakeChatPacket(Chat.ChannelManager.getChannel(), tempKey, id, Chat.Keys.Server))
			serverDisconnected();
		end
	end

	function rekeyAsOwner(id)
		% Generate a key
		tempKey = Chat.Keys.Client.buildKey(id);
		Chat.Keys.Client.finishKey(tempKey, id);
	end

	function serverDisconnected()
		delete(Chat.ChannelManager);
		errordlg('Disconnected from server.', 'Error', 'modal');
		close(Chat.Window);
	end

%% Window Callback
	function windowWillClose(~,~)
		try
			sendDisconnectPacket(Chat.ChannelManager.getChannel());
			Chat.ChannelManager.disconnect();
			ca.Skrundz.Communications.SocketManager.closeAll();
			
			GUI.removeItem(Chat.InputTextField);
			GUI.removeItem(Chat.Button);
			GUI.removeItem(Chat.List);
			delete(Chat.ChatPane);
		catch
		end
		delete(Chat.Window);
	end
end