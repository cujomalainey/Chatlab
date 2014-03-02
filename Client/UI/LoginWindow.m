function [] = LoginWindow()
%LoginWindow() Create and display the window to authenticate into a server

%% Get a window
	Login.window = NewWindow('Login', 200, 140, @windowWillClose);
	set(Login.window, 'WindowStyle', 'modal'); % Make sure it has priority

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
	ButtonPosition = [40 7 120 25];
	Login.Button = GUI.newButton(Login.window, ButtonPosition, 'Login', @login, 1);

	% Create the PostInit Timer
	Login.initTimer = timer('TimerFcn', @postInit,...
		'Name', 'Init Timer',...
		'StartDelay', 0.01...
		);
	start(Login.initTimer);
	
	Login.channel = [];
	Login.Host = 'localhost';
	Login.Port = 10101;
	
%% Timer Callback for PostInit
	function postInit(~,~)
		stop(Login.initTimer);
		Login.ServerField.setFocus();
		delete(Login.initTimer);
	end

%% Window Callback
	function windowWillClose(~,~)
		try
			disconnect(Login.channel);
		catch
		end
		ca.Skrundz.Communications.SocketManager.closeAll();
		
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
		if (src == Login.ServerField)
			getHost();
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
	
	function getHost()
		str = strsplit(Login.ServerField.getText(), ':');
		%% Get the port
		if (length(str) == 2)
			if (str2double(char(str(2))) > 0 && str2double(char(str(2))) < 50000)
				Login.Port = str2double(char(str(2)));
			else
				Login.UserField.setFocus();
				Login.ServerField.setFocus();
				return;
			end
		end
		%% Get the host name
		ip = regexp(str(1), '^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$', 'once');
		url = regexp(str(1), '^[a-zA-Z0-9\-\.]+\.(ca|com|org|net|info|edu|CA|COM|ORG|NET|INFO|EDU)$', 'once');
		local = regexp(str(1), '^(localhost)$', 'once');
		if (ip{1} == 1)
			Login.Host = char(str(1));
			Login.UserField.setFocus();
		elseif (url{1} == 1)
			Login.Host = char(str(1));
			Login.UserField.setFocus();
		elseif (local{1} == 1)
			Login.Host = char(str(1));
			Login.UserField.setFocus();
		else
			Login.UserField.setFocus();
			Login.ServerField.setFocus();
			return;
		end
	end
	
	function performLogin()
		Login.Button.setText('Connecting');
		GUI.disableAll();
		getHost();
		Login.channel = connect(Login.Host, Login.Port, @receiveMessage);
		% Make sure the connection is successful
		if (isempty(Login.channel))
			errordlg(sprintf('Could not connect to %s:%d', Login.Host, Login.Port), 'Error', 'modal');
			Login.Button.setText('Login');
			GUI.enableAll();
		else
			Login.Button.setText('Authenticating');
			%username Login.UserField.getText()
			%password Login.PassField.getText()
% 			if (~sendMessage(Login.channel, loginRequest(Login.UserField.getText(), Login.PassField.getText()))
% 				disp('Disconnected from server');
% 			end
		end
	end
	
	function receiveMessage(~, event)
		%% TODO: Decode Message
		
% 		disp(JSON.parse(char(event.message)));
		packet = JSON.parse(char(event.message));
		disp(packet);
		if (strcmp(packet.Type, 'Shake'))
			disp('Hand Shake 1 DONE!');
		else
			errordlg(sprintf('Communication got mixed up somehow.\nPlease login again later.'), 'Error', 'modal');
		end
	end
	
%% Login Callbacks
	% Move to chat window
	function loginSuccess()
		AddPath('Client/UI');
		AddPath('Client/UI/GUIItems');
		
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