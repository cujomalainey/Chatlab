function [] = ServerWindow()
%ServerWindow() Create and display the window

	%% Get a window
	ServerUI.window = NewWindow('Chat Server', 470, 240, @windowWillClose);
	
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
	IPLabelPosition = [50, 185, 100, 20];
	ServerUI.IPLabel = GUI.newLabel(ServerUI.window, IPLabelPosition, '255.255.255.255', 1);
	ServerUI.IPLabel.setAlignment('right');
	ServerActiveLabelPosition = [100, 160, 50, 20];
	ServerUI.ServerActiveLabel = GUI.newLabel(ServerUI.window, ServerActiveLabelPosition, 'Inactive', 1);
	ServerUI.ServerActiveLabel.setAlignment('right');
	RoomCountLabelPosition = [100, 130, 50, 20];
	ServerUI.RoomCountLabel = GUI.newLabel(ServerUI.window, RoomCountLabelPosition, '0', 1);
	ServerUI.RoomCountLabel.setAlignment('right');
	RegisteredUsersLabelPosition = [100, 80, 50, 20];
	ServerUI.RegisteredUsersLabel = GUI.newLabel(ServerUI.window, RegisteredUsersLabelPosition, '0', 1);
	ServerUI.RegisteredUsersLabel.setAlignment('right');
	OnlineUsersLabelPosition = [100, 55, 50, 20];
	ServerUI.OnlineUsersLabel = GUI.newLabel(ServerUI.window, OnlineUsersLabelPosition, '0', 1);
	ServerUI.OnlineUsersLabel.setAlignment('right');
	
	% Panels
	UserPanelPosition = [10, 50, 150, 75];
	ServerUI.UserPanel = GUI.newPanel(ServerUI.window, UserPanelPosition, 'Users', 1);
	
	% Buttons
	ToggleButtonPosition = [10, 10, 150, 30];
	ServerUI.ToggleButton = GUI.newButton(ServerUI.window, ToggleButtonPosition, 'Toggle Server', @toggle, 1);
	
	% Log Secion
	TabPanelPosition = [170, 0, 300, 220];
	ServerUI.TabPanel = GUI.newTabPanel(ServerUI.window, TabPanelPosition, 1);
	ServerUI.TextPane = GUI.newTextPane(1);
	ServerUI.TabPanel.addTab('Log', ServerUI.TextPane.getPane());
	
	%% Window Callback
	function windowWillClose(~,~)
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
		disp('toggled')
	end
	
end