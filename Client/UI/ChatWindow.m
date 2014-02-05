function [] = ChatWindow( name, token )
%CHATWINDOW Create and display a chat window for the user.

%% Get a window
	Chat.window = NewWindow(['Chat : Logged in as ', name], 700, 500, @windowWillClose);

%% Get the GUI Manager
	GUI = GUIManager.instance();
%% Create the GUI
% 	Chat.TabPanel = GUI.newTabPanel(Chat.window, [0, 70, 700, 400], 0);
	Chat.ChatPane = ChatPane(Chat.window, [0, 70, 700, 400]);
	Chat.ChatPane.addTab('hello');
	Chat.ChatPane.addTab('Tagdgdfb');
	Chat.ChatPane.addTab('fdsf');
	
	InputPosition = [10, 10, 400, 20];
	Chat.InputTextField = GUI.newTextField(Chat.window, InputPosition, @textFieldEnter, 1);
	
	Chat.ChatPane.printText('hello', 'message');
	Chat.ChatPane.printText('hello', 'message');
	Chat.ChatPane.printText('hello', 'message');
	Chat.ChatPane.printText('hello', 'message');
	Chat.ChatPane.printText('fdsf', 'color changed because of new text while not in focus');
	
% 	Chat.TabPanel.alert('hello');

%% Text Field Callback
	function textFieldEnter(src, event)
		
	end

%% Window Callback
	function windowWillClose(~,~)
		GUI.removeItem(Chat.InputTextField);
		delete(Chat.ChatPane);
		delete(Chat.window);
	end
end