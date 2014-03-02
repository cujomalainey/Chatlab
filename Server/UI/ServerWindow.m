function [] = ServerWindow()
%ServerWindow() Create and display the window

	%% Get a window
	ServerUI.window = NewWindow('Chat Server', 500, 240, @windowWillClose);
	
	%% Get the GUI Manager
	GUI = GUIManager.instance();
	
	%% Create the GUI
	% Labels (Names)
	IPNameLabelPosition = [20, 185, 100, 20];
	ServerUI.IPNameLabel = GUI.newLabel(ServerUI.window, IPNameLabelPosition, 'IP: ', 1);
	ServerUI.IPNameLabel.setAlignment('left');
	ServerActiveNameLabelPosition = [20, 160, 100, 20];
	ServerUI.ServerActiveNameLabel = GUI.newLabel(ServerUI.window, ServerActiveNameLabelPosition, 'Status: ', 1);
	ServerUI.ServerActiveNameLabel.setAlignment('left');
	RoomCountNameLabelPosition = [20, 130, 100, 20];
	ServerUI.RoomCountNameLabel = GUI.newLabel(ServerUI.window, RoomCountNameLabelPosition, 'Room Count: ', 1);
	ServerUI.RoomCountNameLabel.setAlignment('left');
	RegisteredUsersNameLabelPosition = [20, 80, 100, 20];
	ServerUI.RegisteredUsersNameLabel = GUI.newLabel(ServerUI.window, RegisteredUsersNameLabelPosition, 'Registered: ', 1);
	ServerUI.RegisteredUsersNameLabel.setAlignment('left');
	OnlineUsersNameLabelPosition = [20, 55, 100, 20];
	ServerUI.OnlineUsersNameLabel = GUI.newLabel(ServerUI.window, OnlineUsersNameLabelPosition, 'Online: ', 1);
	ServerUI.OnlineUsersNameLabel.setAlignment('left');
	% Label (Values)
	IPLabelPosition = [40, 185, 120, 20];
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
	
	Server.users = [];
	
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
		for i = 1:1:length(Server.users)
			try
				disconnect(Server.users{i});
				Server.users(i) = [];
			catch
			end
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
% 				rethrow(e);
				ServerUI.TextPane.print(e.message);
			end
		end
	end
	
	function accept(~, channel)
		clientIP = char(channel.socket().getRemoteSocketAddress().toString());
		ServerUI.TextPane.print(sprintf('Client connected from: %s', clientIP(2:end)));
		% Initialize the handshake
		
		% FAKE DATA ---
		key = [1,2;3,4];
		% END FAKE ----
		
		if (~sendMessage(channel, handshake(key, 1)))
			disconnectClient(event.channel);
		end
	end
	
	function receive(~, event)
		disp('Receive:');
		disp(char(event.message));
		structure = JSON.parse(char(event.message));
		disp(structure);
		pause(0.1);
		pause(10);
		if (~sendMessage(event.channel, struct('title', 'hello')))
			disconnectClient(event.channel);
		end
	end
	
	function disconnectClient(channel)
		fprintf('Client has disconnected (%s)', char(channel.socket().getRemoteSocketAddress().toString()));
	end
	
end