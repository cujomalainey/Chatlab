function [] = ServerWindow()
%ServerWindow() Create and display the window

	%% Get a window
	ServerUI.window = NewWindow('Chat Server', 500, 240, @windowWillClose);
	
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
	
	Server.Servers.localhost = [];
	Server.Servers.localIP = [];
	
	Server.Users = [];
	Server.ChatRooms = [];
	
	Server.Port = 10101;
	
	%% Window Callback
	function windowWillClose(~,~)
		try
			disconnect(Server.Servers.localhost);
		catch
		end
		try
			disconnect(Server.Servers.localIP);
		catch
		end
		%% Fix later. Use the USER model class
% 		while (~isempty(Server.Users))
% 			disconnectClient(Server.Users{1});
% 		end
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
			try
				Server.Servers.localhost = bindServer(char(java.net.InetAddress.getLoopbackAddress().getHostAddress())	, Server.Port, @receive, @accept);
				Server.Servers.localIP   = bindServer(char(java.net.InetAddress.getLocalHost().getHostAddress())		, Server.Port, @receive, @accept);
				ServerUI.ServerActiveLabel.setText('Active');
				ServerUI.IPLabel.setText(sprintf('%s:%d', char(java.net.InetAddress.getLocalHost().getHostAddress()), Server.Port));
				ServerUI.ServerActiveLabel.setColor([0, 0.8, 0]);
			catch e
				ServerUI.TextPane.print('Could not bind the port');
				ServerUI.TextPane.print('Server Not started');
				rethrow(e);
			end
			ServerUI.TextPane.clear();
			ServerUI.TextPane.print('Server Started');
		else
			ServerUI.TextPane.print('Stopping Server...');
			try
				disconnect(Server.Servers.localhost);
				disconnect(Server.Servers.localIP);
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
		try
			clientIP = char(channel.socket().getRemoteSocketAddress().toString());
			ServerUI.TextPane.print(sprintf('Client connected from: %s', clientIP(2:end)));
		catch
			return;
		end
		% Initialize the handshake
		
		% FAKE DATA ---
		tempKey = [1,2;3,4];
		% END FAKE ----
		
		if (~sendHandshakePacket(channel, tempKey, 1))
			disconnectClient(channel);
		end
	end
	
	function receive(~, event)
		%% DECRYPT THE EVENT.MESSAGE FIRST
		channel = event.channel;
		packet = JSON.parse(char(event.message));
		if (strcmp(packet.Type, 'Shake'))
			handleHandshake(channel, packet);
		elseif (strcmp(packet.Type, 'Login'))
			handleLogin(channel, packet);
		elseif (strcmp(packet.Type, 'Message'))
			handleMessage(packet);
		elseif (strcmp(packet.Type, 'RequestUserList'))
			handleSendUserListUpdate();
		elseif (strcmp(packet.Type, 'Disconnect'))
			disconnectClient(channel);
		elseif (strcmp(packet.Type, 'StartChat'))
			handleStartChat(channel, packet)
		elseif (strcmp(packet.Type, 'LeaveChat'))
			handleLeaveChat(channel, packet.ID);
		elseif (strcmp(packet.Type, 'ChatInviteResponse'))
			handleChatInviteResponse(channel, packet);
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
	
	function handleMessage(packet)
		%% TODO
		id = packet.ChatID;
		room = getRoomByID(id);
		room.sendMessage(packet.Sender, packet.Message);
	end
	
	function handleChatInviteResponse(channel, packet)
		%% TODO MAKE SURE THE USER ISNT TRICKING US AND THAT THEY ACTUALLAY WERE INVITED
		if (packet.Response)
			room = getRoomByID(packet.ID);
			%% TODO: FILL IN KEY
			if (~sendChatStartedPacket(channel, room.getName(), packet.ID, []))
				disconnectClient(channel);
				return;
			end
			user = getUserByChannel(channel);
			room.addUser(user, 'Client');
			ServerUI.TextPane.print(sprintf('%s has joine a chat room (%d)', user.getName(), packet.ID));
		else
			%% TODO TELL THE ASKER THAT the user declined
		end
	end
	
	function handleLeaveChat(channel, id)
		room = getRoomByID(id);
		user = getUserByChannel(channel);
		room.removeUser(user, [], @removeRoom);
		ServerUI.TextPane.print(sprintf('%s has left a chat room (%d)', user.getName(), id));
		%% TODO REMOVE THE USER FROM THE CHAT
	end
	
	function handleStartChat(channel, packet)
		requestingUser = getUserByChannel(channel);
		targetUser = getUserByName(packet.Username);
		if (isempty(requestingUser) || isempty(targetUser)) % One of the users doesn't exist
			%% TODO: FAILED TO INVITE USER TO CHAT RESPONSE TO THE CHANNEL
			return;
		end
		room = createRoom();
		ServerUI.TextPane.print(sprintf('%s has create a new room (%d)', requestingUser.getName(), room.getID()));
		%% TODO: FILL IN KEYSSSS
		if (~sendChatStartedPacket(channel, room.getName(), room.getID(), []))
			disconnectClient(channel);
		end
		if (~sendChatInvitePacket(targetUser.getChannel(), room.getID(), requestingUser.getName(), []))
			disconnectClient(targetUser.getChannel());
		end
		room.addUser(requestingUser, 'Owner');
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
			%% TODO GET KEY PER USER
			if (~sendOnlineUserListPacket(user.getChannel, userList, []))
				disconnectClient(channel);
				% Recursive if a user is disconnected so we dont send old data
				% to the early clients and new data to the new clients. This
				% will cause all clients to be updated until we reach a stable
				% state
				handleSendUserListUpdate();
				return;
			end
		end
	end
	
	function handleLogin(channel, packet)
		%% TODO FINISH THIS...
% 		if (packet.Username exists)
% 			if (packet.Password matches)
% 				if (~sendLoginResponsePacket(channel, 1))
% 					disconnectClient(channel);
% 				end
% 				add the client to the list
% 				update the UI
% 			else
% 				if (~sendLoginResponsePacket(channel, 0))
% 					disconnectClient(channel);
% 				end
% 				log the invalid password attempt
% 				disconnectClient(channel);
% 			end
% 		else
% 			create the username with the password
% 			add the client to the list
% 			update the UI
% 		end
		%% ACCCEPT ANY CONNECTIONS FOR NOW
		if (~sendLoginResponsePacket(channel, 1))
			disconnectClient(channel);
		else
			%% TODO GET THE KEY
			addUser(packet.Username, channel, []);
		end
	end
	
	function room = createRoom()
		id = UniqueID().ID;
		room = ChatRoom(sprintf('Room #%d', id), id);
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
	
	function addUser(username, channel, key)
		Server.Users{end+1} = User(username, channel, key);
		ServerUI.OnlineUsersLabel.setText(num2str(length(Server.Users)));
	end
	
	function handleHandshake(channel, packet)
		if (packet.Step == 2) % Reply to the client
				
				% FAKE DATA ---
				key = [9,10;11,12];
				% END FAKE ----
				
				if (~sendHandshakePacket(channel, key, 3))
					disconnectClient(event.channel);
				end
			else
				% Something went wrong with the handshake on the client side
				disconnectClient(event.channel);
			end
	end
	
	function disconnectClient(channel)
		i = 0;
		user = getUserByChannel(channel);
		while i < length(Server.Users)
			i = i + 1;
			for j=1:1:length(Server.ChatRooms)
				room = Server.ChatRooms{j};
				room.removeUser(user, [], @removeRoom);
			end
			if (Server.Users{i} == user)
				Server.Users(i) = [];
			end
			delete(user);
		end
		try
			clientIP = char(channel.socket().getRemoteSocketAddress().toString());
			ServerUI.TextPane.print(sprintf('Client has disconnected (%s)', clientIP(2:end)));
			channel.close();
		catch
			return;
		end
		ServerUI.OnlineUsersLabel.setText(num2str(length(Server.Users)));
	end
	
end