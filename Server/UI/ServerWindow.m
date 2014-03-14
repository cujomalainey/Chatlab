function [] = ServerWindow()
%ServerWindow Create And Display The Window For The Server

%% Get a window
ServerUI.window = NewWindow('Chat Server', 500, 218, @windowWillClose);

%% Get the GUI Manager
GUI = GUIManager.instance();

%% Create the GUI
% Labels (Names)
IPNameLabelPosition = [15, 185, 100, 20];
ServerUI.IPNameLabel = GUI.newLabel(ServerUI.window, IPNameLabelPosition, 'IP: ', 1);
ServerUI.IPNameLabel.setAlignment('left');
ServerActiveNameLabelPosition = [15, 160, 100, 20];
ServerUI.ServerActiveNameLabel = GUI.newLabel(ServerUI.window, ServerActiveNameLabelPosition, 'Status: ', 1);
ServerUI.ServerActiveNameLabel.setAlignment('left');
RoomCountNameLabelPosition = [15, 130, 100, 20];
ServerUI.RoomCountNameLabel = GUI.newLabel(ServerUI.window, RoomCountNameLabelPosition, 'Room Count: ', 1);
ServerUI.RoomCountNameLabel.setAlignment('left');
RegisteredUsersNameLabelPosition = [20, 80, 100, 20];
ServerUI.RegisteredUsersNameLabel = GUI.newLabel(ServerUI.window, RegisteredUsersNameLabelPosition, 'Registered: ', 1);
ServerUI.RegisteredUsersNameLabel.setAlignment('left');
OnlineUsersNameLabelPosition = [20, 55, 100, 20];
ServerUI.OnlineUsersNameLabel = GUI.newLabel(ServerUI.window, OnlineUsersNameLabelPosition, 'Online: ', 1);
ServerUI.OnlineUsersNameLabel.setAlignment('left');
% Label (Values)
IPLabelPosition = [30, 185, 135, 20];
ServerUI.IPLabel = GUI.newLabel(ServerUI.window, IPLabelPosition, char(java.net.InetAddress.getLocalHost().getHostAddress()), 1);
ServerUI.IPLabel.setAlignment('right');
ServerActiveLabelPosition = [100, 160, 60, 20];
ServerUI.ServerActiveLabel = GUI.newLabel(ServerUI.window, ServerActiveLabelPosition, 'Inactive', 1);
ServerUI.ServerActiveLabel.setAlignment('right');
ServerUI.ServerActiveLabel.setColor([1.0, 0, 0]);
RoomCountLabelPosition = [100, 130, 60, 20];
ServerUI.RoomCountLabel = GUI.newLabel(ServerUI.window, RoomCountLabelPosition, '0', 1);
ServerUI.RoomCountLabel.setAlignment('right');
RegisteredUsersLabelPosition = [100, 80, 60, 20];
ServerUI.RegisteredUsersLabel = GUI.newLabel(ServerUI.window, RegisteredUsersLabelPosition, '0', 1);
ServerUI.RegisteredUsersLabel.setAlignment('right');
OnlineUsersLabelPosition = [100, 55, 60, 20];
ServerUI.OnlineUsersLabel = GUI.newLabel(ServerUI.window, OnlineUsersLabelPosition, '0', 1);
ServerUI.OnlineUsersLabel.setAlignment('right');

% Panels
UserPanelPosition = [10, 50, 160, 75];
ServerUI.UserPanel = GUI.newPanel(ServerUI.window, UserPanelPosition, 'Users', 1);

% Buttons
ToggleButtonPosition = [10, 10, 150, 30];
ServerUI.ToggleButton = GUI.newButton(ServerUI.window, ToggleButtonPosition, 'Toggle Server', @toggle, 1);

% Log Secion
TabPanelPosition = [170, 0, 330, 220];
ServerUI.TabPanel = GUI.newTabPanel(ServerUI.window, TabPanelPosition, 1);
ServerUI.TextPane = GUI.newTextPane(1);
ServerUI.TabPanel.addTab('Log', ServerUI.TextPane.getPane());

%% Server Variables
Server.Servers.localhost = [];
Server.Servers.localIP = [];

Server.UserList = struct();

Server.InviteUsers = {};
Server.TempUsers = {};
Server.Users = {};
Server.ChatRooms = {};

Server.Port = 10101;

%% Window Callback
	function windowWillClose(~,~)
		try
			Disconnect(Server.Servers.localhost);
		catch
		end
		try
			Disconnect(Server.Servers.localIP);
		catch
		end
		while (~isempty(Server.Users))
			disconnectClient(Server.Users{1}.getChannel());
		end
		ca.Skrundz.Communications.SocketManager.closeAll();
		
		GUI.removeItem(ServerUI.IPNameLabel);
		GUI.removeItem(ServerUI.ServerActiveNameLabel);
		GUI.removeItem(ServerUI.RoomCountNameLabel);
		GUI.removeItem(ServerUI.RegisteredUsersNameLabel);
		GUI.removeItem(ServerUI.OnlineUsersNameLabel);
		
		GUI.removeItem(ServerUI.IPLabel);
		GUI.removeItem(ServerUI.ServerActiveLabel);
		GUI.removeItem(ServerUI.RoomCountLabel);
		GUI.removeItem(ServerUI.RegisteredUsersLabel);
		GUI.removeItem(ServerUI.OnlineUsersLabel);
		
		GUI.removeItem(ServerUI.UserPanel);
		
		GUI.removeItem(ServerUI.ToggleButton);
		
		GUI.removeItem(ServerUI.TabPanel);
		GUI.removeItem(ServerUI.TextPane);
		
		delete(ServerUI.window);
	end

%% Callbacks
	function toggle(~)
		if (isempty(Server.Servers.localhost) && isempty(Server.Servers.localIP))
			ServerUI.TextPane.clear();
			ServerUI.TextPane.print('Starting Server...');
			pause(0.1);
			try
				Server.Servers.localhost = BindServer(char(java.net.InetAddress.getLoopbackAddress().getHostAddress())	, Server.Port, @receive, @accept);
				Server.Servers.localIP   = BindServer(char(java.net.InetAddress.getLocalHost().getHostAddress())		, Server.Port, @receive, @accept);
				ServerUI.ServerActiveLabel.setText('Active');
				ServerUI.IPLabel.setText(sprintf('%s:%d', char(java.net.InetAddress.getLocalHost().getHostAddress()), Server.Port));
				ServerUI.ServerActiveLabel.setColor([0, 0.8, 0]);
			catch
				ServerUI.TextPane.print('Could not bind the port');
				ServerUI.TextPane.print('Server Not started');
				try
					Server.Servers.localhost.close();
					Server.Servers.localIP.close();
				catch
				end
				Server.Servers.localhost = [];
				Server.Servers.localIP = [];
				return;
			end
			ServerUI.TextPane.clear();
			ServerUI.TextPane.print('Server Started');
		else
			ServerUI.TextPane.print('Stopping Server...');
			try
				pause(0.1);
				Server.Servers.localhost.close();
				Server.Servers.localIP.close();
				Server.Servers.localhost = [];
				Server.Servers.localIP = [];
				ca.Skrundz.Communications.SocketManager.closeAll();
				ServerUI.ServerActiveLabel.setText('Inactive');
				ServerUI.IPLabel.setText(char(java.net.InetAddress.getLocalHost().getHostAddress()));
				ServerUI.ServerActiveLabel.setColor([1.0, 0, 0]);
				ServerUI.TextPane.print('Stopped');
			catch e
				ServerUI.TextPane.print('Could not stop server?!?!?!?!');
				ServerUI.TextPane.print(e.message);
			end
		end
	end

	function accept(~, channel)
		clientIP = char(channel.socket().getRemoteSocketAddress().toString());
		ServerUI.TextPane.print(sprintf('Client connected from: %s', clientIP(2:end)));
		%% Create a TempUser for this connection
		tempUser = TempUser(channel, KeyManager());
		Server.TempUsers{end + 1} = tempUser;
		firstKey = tempUser.start();
		%% Send the key to the client
		if (~sendHandshakePacket(channel, firstKey, 1))
			disconnectClient(channel);
		end
	end

	function receive(~, event)
		channel = event.channel;
		disp(char(event.message));
		message = decryptMessage(channel, char(event.message));
		disp(message);
		try
			packet = JSON.parse(message);
		catch
			return; % It was a fake message
		end
		switch packet.Type
			case 'Shake'
				handleHandshake(channel, packet);
			case 'ChatShake'
				handleChatShake(channel, packet);
			case 'ChatShakeDone'
				handleChatShakeDone(packet);
			case 'Login'
				handleLogin(channel, packet);
			case 'RequestUserList'
				handleSendUserListUpdate();
			case 'StartChat'
				handleStartChat(channel, packet)
			case 'ChatInvite'
				handleInviteToChat(channel, packet);
			case 'ChatInviteResponse'
				handleChatInviteResponse(channel, packet);
			case 'Disconnect'
				disconnectClient(channel);
			case 'LeaveChat'
				handleLeaveChat(channel, packet.ID);
			case 'Message'
				handleMessage(channel, packet);
		end
	end

	function message = decryptMessage(channel, string)
		%% Decrypt The String
		message = string;
		try
			if (isempty(str2num([message, ';']))) %#ok<ST2NM>
				error('Not A Matrix');
			end
			tempUser = getTempUserByChannel(channel);
			user = getUserByChannel(channel);
			if (~isempty(tempUser))
				message = Encryptor.decrypt(message, tempUser.getKey());
			elseif (~isempty(user))
				message = Encryptor.decrypt(message, user.getKey());
			end
		catch
		end
	end

	function user = getTempUserByChannel(channel)
		for i=1:1:length(Server.TempUsers)
			user = Server.TempUsers{i};
			if (user.getChannel() == channel)
				return;
			end
		end
		user = [];
	end

	function bool = wasUserInvitedToChat(user, id)
		bool = 0;
		i = 0;
		while i < length(Server.InviteUsers)
			i = i + 1;
			inviteUser = Server.InviteUsers{i};
			if (inviteUser.getUser() == user && inviteUser.getID() == id)
				Server.InviteUsers(i) = [];
				bool = 1;
			end
		end
	end

	function user = getUserByChannel(channel)
		for i=1:1:length(Server.Users)
			user = Server.Users{i};
			if (user.getChannel() == channel)
				return;
			end
		end
		user = [];
	end

	function user = getUserByName(name)
		for i=1:1:length(Server.Users)
			user = Server.Users{i};
			if (strcmp(user.getName(), name))
				return;
			end
		end
		user = [];
	end

	function room = getRoomByID(id)
		for i=1:1:length(Server.ChatRooms)
			room = Server.ChatRooms{i};
			if (room.getID == id)
				return;
			end
		end
		room = [];
	end

	function handleHandshake(channel, packet)
		if (packet.Step == 2)
			tempUser = getTempUserByChannel(channel);
			tempUser.finish(packet.Key);
			if (~sendHandshakePacket(channel, '', 3))
				disconnectClient(channel);
			end
		else
			% Something went wrong with the handshake on the client side
			disconnectClient(channel);
		end
	end

	function handleChatShake(channel, packet)
		room = getRoomByID(packet.ChatID);
		user = getUserByChannel(channel);
		owner = room.getOwner();
		id = packet.ChatID;
		tempKey = packet.Key;
		% Make sure the user is actually in the chat room
		if (~room.containsUser(user))
			disconnectClient(channel); % User isnt in a room and is hacking
		end
		if (~sendHandshakeChatResponsePacket(owner.getChannel(), tempKey, user.getName(), id, owner.getKey()))
			disconnectClient(owner.getChannel());
		end
	end

	function handleChatShakeDone(packet)
		user = getUserByName(packet.User);
		room = getRoomByID(packet.ChatID);
		chatKey = packet.ChatKey;
		tempKey = packet.Key;
		if (~sendHandshakeChatDonePacket(user.getChannel(), tempKey, '', room.getID(), chatKey, user.getKey()))
			disconnectClient(user.getChannel());
		end
	end

	function handleLogin(channel, packet)
		username = packet.Username;
		password = packet.Password;
		tempUser = getTempUserByChannel(channel);
		clientIP = char(channel.socket().getRemoteSocketAddress().toString());
		if (isempty(tempUser))
			ServerUI.TextPane.print(sprintf('(%s) hacked loggin attempt %s', clientIP(2:end), username));
			removeTempUser(tempUser);
			return;
		end
		if (~isempty(username))
			if (~isstrprop(username(1), 'alpha')) % Make sure the username doesn't start with a number
				ServerUI.TextPane.print(sprintf('(%s) invalid login attempt as: %s', clientIP(2:end), username));
				sendLoginResponsePacket(channel, 0)
				disconnectClient(channel);
				return;
			end
			if (isstrprop(username, 'graphic')) % Make sure the username doesn't contain whitespace/unassigned character
				% Skip This. if (isstrprop(..)) does weird stuff when the string
				% is longer that 1 character...
			else
				ServerUI.TextPane.print(sprintf('(%s) invalid login attempt as: %s', clientIP(2:end), username));
				sendLoginResponsePacket(channel, 0)
				disconnectClient(channel);
				return;
			end
			if (isfield(Server.UserList, username))
				if (strcmp(Server.UserList.(username), password))
					if (~isempty(getUserByName(username))) % Duplicate login
						ServerUI.TextPane.print(sprintf('(%s) duplicate a login attempt as %s', clientIP(2:end), username));
						sendLoginResponsePacket(channel, 0);
						disconnectClient(channel);
						return;
					end
					if (~sendLoginResponsePacket(channel, 1))
						disconnectClient(channel);
					else
						ServerUI.TextPane.print(sprintf('%s has logged in (%s)', username, clientIP(2:end)));
						addUser(username, tempUser, channel);
					end
				else % Invalid password
					ServerUI.TextPane.print(sprintf('(%s) failed a login attempt as %s', clientIP(2:end), username));
					sendLoginResponsePacket(channel, 0)
					disconnectClient(channel);
					return;
				end
			else % User doesnt exist so create
				Server.UserList.(username) = password;
				if (~sendLoginResponsePacket(channel, 1))
					disconnectClient(channel);
				else
					ServerUI.TextPane.print(sprintf('%s has logged in (%s)', username, clientIP(2:end)));
					addUser(username, tempUser, channel);
				end
			end
		end
	end

	function addUser(username, tempUser, channel)
		Server.Users{end+1} = User(username, channel, tempUser.getKey());
		removeTempUser(tempUser);
		ServerUI.OnlineUsersLabel.setText(num2str(length(Server.Users)));
	end

	function removeTempUser(tempUser)
		i = 0;
		while i < length(Server.TempUsers)
			i = i + 1;
			if (Server.TempUsers{i} == tempUser)
				Server.TempUsers(i) = [];
			end
		end
		delete(tempUser);
	end

	function handleSendUserListUpdate()
		userList = cell(1, length(Server.Users));
		for i=1:1:length(Server.Users)
			userList{i} = Server.Users{i}.getName();
		end
		i = 0;
		while i < length(Server.Users)
			i = i + 1;
			user = Server.Users{i};
			if (~sendOnlineUserListPacket(user.getChannel(), userList, user.getKey()))
				disconnectClient(user.getChannel());
				% Recursive if a user is disconnected so we dont send old data
				% to the early clients and new data to the new clients. This
				% will cause all clients to be updated until we reach a stable
				% state
				handleSendUserListUpdate();
				return;
			end
		end
	end

	function handleStartChat(channel, packet)
		requestingUser = getUserByChannel(channel);
		targetUser = getUserByName(packet.Username);
		if (isempty(requestingUser) || isempty(targetUser)) % One of the users doesn't exist
			if (~sendInviteUserFailedPacket(channel, packet.Username, requestingUser.getKey()))
				disconnectClient(channel);
			end
			handleSendUserListUpdate();
			return;
		end
		room = createRoom();
		ServerUI.TextPane.print(sprintf('%s has create a new room (%d)', requestingUser.getName(), room.getID()));
		if (~sendChatStartedPacket(channel, room.getName(), room.getID(), 0, requestingUser.getKey()))
			disconnectClient(channel);
		end
		Server.InviteUsers{end + 1} = InviteUser(targetUser, room.getID());
		if (~sendChatInvitePacket(targetUser.getChannel(), room.getID(), requestingUser.getName(), targetUser.getKey()))
			disconnectClient(targetUser.getChannel());
		end
		room.addUser(requestingUser, 'Owner');
	end

	function handleInviteToChat(channel, packet)
		requestingUser = getUserByChannel(channel);
		targetUser = getUserByName(packet.Name);
		id = packet.ID;
		if (isempty(requestingUser) || isempty(targetUser)) % One of the users doesn't exist
			if (~sendInviteUserFailedPacket(channel, packet.Name, requestingUser.getKey()))
				disconnectClient(channel);
			end
			handleSendUserListUpdate();
			return;
		end
		room = getRoomByID(id);
		if (isempty(room))
			% The user is hacking
			disconnectClient(channel);
		end
		% Make sure the user has permission to invite
		if (room.canUserInvite(requestingUser))
			Server.InviteUsers{end + 1} = InviteUser(targetUser, room.getID());
			if (~sendChatInvitePacket(targetUser.getChannel(), room.getID(), requestingUser.getName(), targetUser.getKey()))
				disconnectClient(targetUser.getChannel());
			end
		else
			if (~sendChatPacket(requestingUser.getChannel(), 'Server', room.getID(), 'You do not have permission to invite users to this chat room', requestingUser.getKey()))
				disconnectClient(requestingUser.getChannel());
			end
		end
	end

	function handleChatInviteResponse(channel, packet)
		user = getUserByChannel(channel);
		if (~wasUserInvitedToChat(user, packet.ID))
			% THE USER WAS NOT INVITED TO THE CHAT AND WILL BE REMOVED FROM THE SERVER BECASUE THEY ARE HACKING!!!
			disconnectClient(channel);
			return;
		end
		room = getRoomByID(packet.ID);
		if (packet.Response)
			if (~sendChatStartedPacket(channel, room.getName(), packet.ID, 1, user.getKey()))
				disconnectClient(channel);
				return;
			end
			room.addUser(user, 'Client');
			ServerUI.TextPane.print(sprintf('%s has joined a chat room (%d)', user.getName(), packet.ID));
		else
			room.sendMessage('Server', sprintf('%s has declined the invite to chat', user.getName()));
			ServerUI.TextPane.print(sprintf('%s has declined to join join a chat room (%d)', user.getName(), packet.ID));
		end
	end

	function handleLeaveChat(channel, id)
		room = getRoomByID(id);
		user = getUserByChannel(channel);
		room.removeUser(user, [], @removeRoom);
		ServerUI.TextPane.print(sprintf('%s has left a chat room (%d)', user.getName(), id));
	end

	function handleMessage(channel, packet)
		room = getRoomByID(packet.ChatID);
		user = getUserByChannel(channel);
		if (~strcmp(packet.Message(1), '/'))
			if (room.canUserChat(user))
				room.sendMessage(packet.Sender, packet.Message);
			else
				if (~sendChatPacket(user.getChannel(), 'Server', room.getID(), 'You do not have permission to chat in this room', user.getKey()))
					disconnectClient(user.getChannel());
				end
			end
		else % Handle the command
			command = strsplit(packet.Message, ' ');
			firstCommand = command(1);
			if (strcmpi(firstCommand, '/promote'))
				
				if (length(command) > 1)
					targetUser = getUserByName(command(2));
					if (~isempty(targetUser))
						if (user == room.getOwner())
							room.promote(targetUser);
						else
							if (~sendChatPacket(user.getChannel(), 'Server', room.getID(), 'You do not have permission to promote someone in this chat room', user.getKey()))
								disconnectClient(user.getChannel());
							end
						end
					end
				end
				if (~sendChatPacket(user.getChannel(), 'Server', room.getID(), 'Invalid command. Try /help', user.getKey()))
					disconnectClient(user.getChannel());
				end
			elseif (strcmpi(firstCommand, '/kick'))
				if (length(command) > 1)
					targetUser = getUserByName(command(2));
					if (~isempty(targetUser))
						if (room.canUserInvite(user))
							room.removeUser(targetUser, 'Kick', @removeRoom);
							return;
						else
							if (~sendChatPacket(user.getChannel(), 'Server', room.getID(), 'You do not have permission to kick someone from this chat room', user.getKey()))
								disconnectClient(user.getChannel());
							end
						end
					end
				end
				if (~sendChatPacket(user.getChannel(), 'Server', room.getID(), 'Invalid command. Try /help', user.getKey()))
					disconnectClient(user.getChannel());
				end
			elseif (strcmpi(firstCommand, '/rename'))
				if (length(command) > 1)
					newName = command(2);
					room.setName(newName);
				end
				if (~sendChatPacket(user.getChannel(), 'Server', room.getID(), 'Invalid command. Try /help', user.getKey()))
					disconnectClient(user.getChannel());
				end
			elseif (strcmpi(firstCommand, '/invite'))
				if (length(command) > 1)
					targetUser = getUserByName(command(2));
					if (~isempty(targetUser))
						% Make sure the user has permission to invite
						if (room.canUserInvite(user))
							Server.InviteUsers{end + 1} = InviteUser(targetUser, room.getID());
							if (~sendChatInvitePacket(targetUser.getChannel(), room.getID(), user.getName(), targetUser.getKey()))
								disconnectClient(targetUser.getChannel());
							end
						else
							if (~sendChatPacket(user.getChannel(), 'Server', room.getID(), 'You do not have permission to invite users to this chat room', user.getKey()))
								disconnectClient(user.getChannel());
							end
						end
						return;
					end
				end
				if (~sendChatPacket(user.getChannel(), 'Server', room.getID(), 'Invalid command. Try /help', user.getKey()))
					disconnectClient(user.getChannel());
				end
			elseif (strcmpi(firstCommand, '/mute'))
				if (length(command) > 1)
					targetUser = getUserByName(command(2));
					if (~isempty(targetUser))
						room.muteUser(targetUser);
						return;
					end
				end
				if (~sendChatPacket(user.getChannel(), 'Server', room.getID(), 'Invalid command. Try /help', user.getKey()))
					disconnectClient(user.getChannel());
				end
			elseif (strcmpi(firstCommand, '/unmute'))
				if (length(command) > 1)
					targetUser = getUserByName(command(2));
					if (~isempty(targetUser))
						room.unmuteUser(targetUser);
						return;
					end
				end
				if (~sendChatPacket(user.getChannel(), 'Server', room.getID(), 'Invalid command. Try /help', user.getKey()))
					disconnectClient(user.getChannel());
				end
			elseif (strcmpi(firstCommand, '/list'))
				userlist = room.getUsers();
				permList = room.getPermissions();
				string = sprintf('\nUser List');
				for i = 1:1:length(userlist)
					string = sprintf('%s\n%s	%s', string, userlist{i}.getName(), permList{i});
				end
				if (~sendChatPacket(user.getChannel(), 'Server', room.getID(), sprintf('%s\n', string), user.getKey()))
					disconnectClient(user.getChannel());
				end
			elseif (strcmpi(firstCommand, '/help'))
				if (~sendChatPacket(user.getChannel(), 'Server', room.getID(),...
						sprintf('\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n',...
						'Help - Chat',...
						'/help           - display this help',...
						'/list           - display a list of users in the chat room',...
						'/rename  <name> - rename the chat',...
						'/invite  <user> - invite a user to the current chat',...
						'/kick    <user> - kick the user from the chat room',...
						'/promote <user> - promote the user to moderator',...
						'/mute    <user> - mute the user',...
						'/unmute  <user> - unmute the user',...
						'/clear          - clears the chat window (client only)'...
						),...
						user.getKey()))
					disconnectClient(user.getChannel());
				end
			end
		end
	end

	function room = createRoom()
		id = UniqueID().ID;
		room = ChatRoom(sprintf('Room #%d', id), id, @disconnectClient);
		Server.ChatRooms{end+1} = room;
		ServerUI.RoomCountLabel.setText(num2str(length(Server.ChatRooms)));
	end

	function removeRoom(chatroom)
		i = 0;
		while (i < length(Server.ChatRooms))
			i = i + 1;
			if (Server.ChatRooms{i} == chatroom)
				Server.ChatRooms(i) = [];
			end
		end
		ServerUI.RoomCountLabel.setText(num2str(length(Server.ChatRooms)));
	end

	function disconnectClient(channel)
		user = getUserByChannel(channel);
		i = 0;
		while i < length(Server.ChatRooms)
			i = i + 1;
			room = Server.ChatRooms{i};
			room.removeUser(user, [], @removeRoom);
		end
		i = 0;
		while i < length(Server.Users)
			i = i + 1;
			if (Server.Users{i} == user)
				Server.Users(i) = [];
			end
		end
		delete(user);
		try
			clientIP = char(channel.socket().getRemoteSocketAddress().toString());
			ServerUI.TextPane.print(sprintf('Client has disconnected (%s)', clientIP(2:end)));
			channel.close();
		catch
		end
		ServerUI.OnlineUsersLabel.setText(num2str(length(Server.Users)));
		handleSendUserListUpdate();
	end

end