function [] = ChatWindow()
%CHATWINDOW Create and display a chat window for the user.

%% Get a window
	Chat.window = NewWindow('Chat', 700, 500, @windowWillClose);

%% Get the GUI Manager
	GUI = GUIManager.instance();
%% Create the GUI
	Chat.TabPanel = GUI.newTabPanel(Chat.window, [0, 0, 700, 400], 0);
	Chat.TabPanel.addTab('Tagdgdfb ');
	Chat.TabPanel.addTab('Tagdgdfb ');
	Chat.TabPanel.addTab('Tagdgdfb ');

%% Window Callback
	function windowWillClose(~,~)
		delete(Chat.TabPanel);
		delete(Chat.window);
	end
end