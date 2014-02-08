function [] = ChatWindow( name, token )
%CHATWINDOW Create and display a chat window for the user.

%% Get a window
	Chat.window = NewWindow(['Chat : Logged in as ', name], 670, 461, @windowWillClose);
	set(Chat.window, 'Color', [0.93, 0.93, 0.93]);
	
%% Get the GUI Manager
	GUI = GUIManager.instance();
%% Create the GUI
	InputPosition = [10, 10, 590, 20];
	Chat.InputTextField = GUI.newTextField(Chat.window, InputPosition, @textFieldEnter, 1);
	
	ButtonPosition = [610, 10, 50, 20];
	Chat.Button = GUI.newButton(Chat.window, ButtonPosition, 'Send', @textFieldEnter, 1);
	
	Chat.ChatPane = ChatPane(Chat.window, [0, 40, 470, 400]);
	Chat.ChatPane.addTab('hello');
	Chat.ChatPane.addTab('Tagdgdfb');
	Chat.ChatPane.addTab('fdsf');
	
	TreeBackgroundPosition = [470, 40, 200, 400];
	Chat.TreeBackground = GUI.newTabPanel(Chat.window, TreeBackgroundPosition, 1);
	Chat.TreeBackground.addTab('Online Users', []);
	
	a{1}='fdsfs';
	a{2}='fdsfdfsdfsfsdf';
	a{3}='f';
	a{4}='fdsfs';
	a{5}='fdsfdfsdfsfsdf';
	a{6}='f';
	a{7}='fdsfs';
	a{8}='fdsfdfsdfsfsdf';
	a{9}='f';
	a{10}='fdsfs';
	a{11}='fdsfs';
	a{12}='fdsfs';
	a{13}='fdsfs';
	a{14}='fdsfs';
	a{15}='fdsfs';
	
	Chat.List = GUI.newListBox(Chat.window, [480, 53, 180, 354], @clickList, 1);
	Chat.List.setData(a);
	
	Chat.ChatPane.printText('hello', 'message');
	Chat.ChatPane.printText('hello', 'message');
	Chat.ChatPane.printText('hello', 'message');
	Chat.ChatPane.printText('hello', 'message');
	Chat.ChatPane.printText('fdsf', 'color changed because of new text while not in focus');
	
	%% Initialize some state values
	Chat.SelectedPerson = '';
	Chat.Menu = uicontextmenu;
	
%% Text Field Callback
	function textFieldEnter(src, event)
		disp('enter');
	end
	
	function clickList(src, event)
		% Select an item 
		if (event.getButton() == 3)
			Chat.List.selectIndexAtPosition(event.getPoint());
		end
		
% 		index = Chat.List.getSelectedIndex();
		Chat.SelectedPerson = Chat.List.getSelectedValue();
		
		if (Chat.Menu)
			delete(Chat.Menu);
		end
		
		Chat.Menu = uicontextmenu(); %this menu is static
		uimenu(Chat.Menu, 'Label', Chat.SelectedPerson, 'Enable', 'off');
		uimenu(Chat.Menu, 'Label', 'Start Chat', 'Separator', 'on', 'Callback', @startChat);
		% Create more item maybe in the future??
		uimenu(Chat.Menu, 'Label', 'Invite To Current Chat', 'Separator', 'on', 'Callback', @inviteToChat);
		
		windowPos = get(Chat.window, 'Position');
		screenSize = get(0, 'ScreenSize');
		set(Chat.Menu, 'Position', [event.getXOnScreen() - windowPos(1), screenSize(4) - windowPos(2) + 2  - event.getYOnScreen()]);
		set(Chat.Menu, 'Visible', 'on');
		
		Chat.List.deselect();
	end
	
	%% ContextMenu Callback
	function startChat(~,~)
		disp(Chat.SelectedPerson);
		disp('start chat');
	end
	
	function inviteToChat(~,~)
		disp(Chat.SelectedPerson);
		disp('invite to chat');
	end
	
%% Window Callback
	function windowWillClose(~,~)
		GUI.removeItem(Chat.InputTextField);
		GUI.removeItem(Chat.Button);
		GUI.removeItem(Chat.List);
		delete(Chat.ChatPane);
		delete(Chat.window);
	end
end