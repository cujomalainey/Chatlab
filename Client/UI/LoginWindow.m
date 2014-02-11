function [] = LoginWindow()
%LoginWindow() Create and display the window to authenticate into a server

%% Get a window
	Login.window = NewWindow('Login', 200, 140, @windowWillClose);
	set(Login.window,	'WindowStyle', 'modal',...
						'Color', [0.93, 0.93, 0.93]...
					); % Make sure it has priority

%% Get the GUI Manager
	GUI = GUIManager.instance();
%% Create the GUI
	% Labels
	ServerLabelPosition = [10, 82, 100, 20];
	Login.ServerLabel = GUI.newLabel(Login.window, ServerLabelPosition, 'Server IP:', 1);
	Login.ServerLabel.setAlignment('left');
	UserLabelPosition = [10, 60, 100, 20];
	Login.UserLabel = GUI.newLabel(Login.window, UserLabelPosition, 'Username:', 1);
	Login.UserLabel.setAlignment('left');
	PassLabelPosition = [10, 38, 100, 20];
	Login.PassLabel = GUI.newLabel(Login.window, PassLabelPosition, 'Password:', 1);
	Login.PassLabel.setAlignment('left');

	% Text Fields
	ServerPosition = [80, 84, 110, 20];
	Login.ServerField = GUI.newTextField(Login.window, ServerPosition, @enter, 1);
	UserPosition = [80, 62, 110, 20];
	Login.UserField = GUI.newTextField(Login.window, UserPosition, @enter, 1);

	% Password Field
	PassPosition = [80, 40, 110, 20];
	Login.PassField = GUI.newPasswordField(Login.window, PassPosition, @enter, 1);

	% Button
	ButtonPosition = [50 7 100 25];
	Login.Button = GUI.newButton(Login.window, ButtonPosition, 'Login', @login, 1);

	% Create the PostInit Timer
	Login.initTimer = timer('TimerFcn', @postInit,...
		'Name', 'Init Timer',...
		'StartDelay', 0.01...
		);
	start(Login.initTimer);

%% Timer Callback for PostInit
	function postInit(~,~)
		stop(Login.initTimer);
		Login.ServerField.setFocus();
		delete(Login.initTimer);
	end

%% Window Callback
	function windowWillClose(~,~)
		GUI.removeItem(Login.ServerLabel);
		GUI.removeItem(Login.PassLabel);
		GUI.removeItem(Login.UserLabel);
		
		GUI.removeItem(Login.ServerField);
		GUI.removeItem(Login.UserField);
		GUI.removeItem(Login.PassField);
		
		GUI.removeItem(Login.Button);
		
		delete(Login.window);
	end

%% Callback Functions
	function enter(src)
		if (src == Login.ServerField && ~isempty(Login.ServerField.getText()))
			Login.UserField.setFocus();
		elseif (src == Login.UserField && ~isempty(Login.UserField.getText()))
			Login.PassField.setFocus();
		elseif (src == Login.PassField)
			login(src)
		end
	end

	function login(~)
		if (isempty(Login.ServerField.getText()))
			Login.ServerField.setFocus();
		elseif (isempty(Login.UserField.getText()))
			Login.UserField.setFocus();
		elseif (isempty(Login.PassField.getText()))
			Login.PassField.setFocus();
		else
			Login.PassField.setFocus();
			performLogin();
		end
	end

	function performLogin()
		%% TODO: LOGIN
		disp('Loggin in...');
		loginSuccess();
	end

%% Login Callbacks
	% Move to chat window
	function loginSuccess()
		AddPath('Client/UI');
		AddPath('Client/UI/GUIItems');
		AddPath('Common/UI');
		AddPath('Common/UI/GUIItems');
		
		a = Login.UserField.getText();
		
		close(Login.window);
		
		ChatWindow(a);
	end

	function loginFailed(reason)
		title = 'Login failed';
		switch reason
			case 1
				message = 'Bad Username/Password.';
			case 2
				message = 'Could not connect to server.';
			otherwise
				message = 'Could not authenticate.';
		end
		errordlg(message, title, 'modal');
	end

end