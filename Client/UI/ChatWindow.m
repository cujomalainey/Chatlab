function [] = ChatWindow(name, key)
%CHATWINDOW Create and display a chat window for the user.

%% Get a window
	Chat.Window = NewWindow(['Chat : Logged in as ', name], 670, 461, @windowWillClose);
	
%% Get the channel for communication
	Chat.ChannelManager = ChannelManager.instance(); % Should carry over from the old instance
	Chat.ChannelManager.setCallback(@receiveMessage);
%% Get the key for encryption
	Chat.Keys.Server = key;
	
	
	Chat.Key = keyhandler();
	
	
	
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
	%% TODO PUT THE KEY
	if (~sendUserListRequestPacket(Chat.ChannelManager.getChannel(), Chat.Keys.Server))
		serverDisconnected();
	end
	
	%% Initialize some state values
	Chat.SelectedPerson = '';
	Chat.Menu = uicontextmenu;
	
%% Text Field Callback
	function textFieldEnter(src, event)
		%% TODO PROPERLY IMPLEMENT
		
		
		
		
		
		
		
		%% TODO GET KEY
		if (~sendKeyPacket(Chat.ChannelManager.getChannel(), mat2str(Chat.Key.startkey(1)), []))
			
			
			
			
% 		if (~sendChatPacket(Chat.ChannelManager.getChannel(), Chat.User, 1, sprintf('%s: %s', Chat.User, char(Chat.InputTextField.getText())), Chat.Keys.Server))
			serverDisconnected();
		end
		Chat.InputTextField.setText('');
	end
	
	function clickList(src, event)
		% Select an item 
		if (event.getButton() == 3)
			Chat.List.selectIndexAtPosition(event.getPoint());
		end
		
% 		index = Chat.List.getSelectedIndex();
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
		% Create more item maybe in the future??
		uimenu(Chat.Menu, 'Label', 'Invite To Current Chat', 'Separator', 'on', 'Callback', @inviteToChat);
		
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
		disp(Chat.SelectedPerson);
		disp('invite to chat');
	end
	
	function leaveChat(id)
		if (~sendChatLeavePacket(Chat.ChannelManager.getChannel(), id, Chat.Keys.Server))
			serverDisconnected();
		end
	end
	
	%% Network callback
	function receiveMessage(event)
		%% TODO: Decode Message
		packet = JSON.parse(char(event.message));
		if (strcmp(packet.Type, 'UserList'))
			list = packet.List;
			i = 0;
			while i < length(list)
				i = i + 1;
				if (strcmp(list{i}, Chat.User))
					list(i) = [];
				end
			end
			if (~isempty(list))
				Chat.List.setData(list);
			end
		elseif (strcmp(packet.Type, 'StartedChat'))
			id = packet.ID;
			Chat.ChatPane.addTab(packet.Name, id);
			Chat.ChatPane.setSelectedTabByID(id);
		elseif (strcmp(packet.Type, 'ChatInvite'))
			accept = questdlg(sprintf('%s would like to chat with you.', packet.Name), 'Chat Invite', 'Deny', 'Accept', 'Deny');
			if (strcmp(accept, 'Deny'))
				response = 0;
			else
				response = 1;
			end
			if (~sendChatInviteResponsePacket(Chat.ChannelManager.getChannel(), packet.ID, response, Chat.Keys.Server))
				serverDisconnected();
			end
		elseif (strcmp(packet.Type, 'Message'))
			id = packet.ChatID;
			sender = packet.Sender;
			message = packet.Message;
			%% Verify the integrity of the message
			s = strsplit(message,':');
			if ((strcmp(sender, s(1))) || ((length(s) == 1) && strcmp(sender, 'Server')))
				% Success
				Chat.ChatPane.printTextByID(id, message);
			else
				% Invalid message
				%% TODO: HANDLE INVALID. OR MAYBE NOT?
			end
			
			
			
		elseif (strcmp(packet.Type, 'KeyResponse'))
			
			
			if (strcmp(packet.Response, '-1'))
				if (~sendKeyPacket(Chat.ChannelManager.getChannel(), mat2str(Chat.Key.startkey(1)), []))
					
					
					
					
					% 		if (~sendChatPacket(Chat.ChannelManager.getChannel(), Chat.User, 1, sprintf('%s: %s', Chat.User, char(Chat.InputTextField.getText())), Chat.Keys.Server))
					serverDisconnected();
				end
			else
				disp('success')
                Chat.Key.addkey(1, 1, eval(packet.Response))
			end
			
			
			
		end
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