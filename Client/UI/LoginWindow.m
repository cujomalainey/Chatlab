function [] = LoginWindow()
%LoginWindow() Create and display the window to authenticate into a server

%% Get a window
	Login.Window = NewWindow('Login', 200, 140, @windowWillClose);
	set(Login.Window, 'WindowStyle', 'modal'); % Make sure it has priority

%% Get the GUI Manager
	GUI = GUIManager.instance();
%% Create the GUI
	% Labels
	ServerLabelPosition = [10, 82, 100, 20];
	Login.ServerLabel = GUI.newLabel(Login.Window, ServerLabelPosition, 'Server IP:', 1);
	Login.ServerLabel.setAlignment('left');
	UserLabelPosition = [10, 60, 100, 20];
	Login.UserLabel = GUI.newLabel(Login.Window, UserLabelPosition, 'Username:', 1);
	Login.UserLabel.setAlignment('left');
	PassLabelPosition = [10, 38, 100, 20];
	Login.PassLabel = GUI.newLabel(Login.Window, PassLabelPosition, 'Password:', 1);
	Login.PassLabel.setAlignment('left');

	% Text Fields
	ServerPosition = [80, 84, 110, 20];
	Login.ServerField = GUI.newTextField(Login.Window, ServerPosition, @enter, 1);
	UserPosition = [80, 62, 110, 20];
	Login.UserField = GUI.newTextField(Login.Window, UserPosition, @enter, 1);

	% Password Field
	PassPosition = [80, 40, 110, 20];
	Login.PassField = GUI.newPasswordField(Login.Window, PassPosition, @enter, 1);

	% Button
	ButtonPosition = [40 7 120 25];
	Login.Button = GUI.newButton(Login.Window, ButtonPosition, 'Login', @login, 1);

	% Create the PostInit Timer
	Login.initTimer = timer('TimerFcn', @postInit,...
		'Name', 'Init Timer',...
		'StartDelay', 0.01...
		);
	start(Login.initTimer);
	
	Login.Success = 0;
	
	Login.Key = [];
	Login.ChannelManager = ChannelManager.instance();
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
		if (~Login.Success)
			Login.ChannelManager.disconnect();
			ca.Skrundz.Communications.SocketManager.closeAll();
		end
		
		GUI.removeItem(Login.ServerLabel);
		GUI.removeItem(Login.PassLabel);
		GUI.removeItem(Login.UserLabel);
		
		GUI.removeItem(Login.ServerField);
		GUI.removeItem(Login.UserField);
		GUI.removeItem(Login.PassField);
		
		GUI.removeItem(Login.Button);
		
		delete(Login.Window);
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
% 		Login.ChannelManager = ConnectionManager(Login.Host, Login.Port, @receive);
		% Make sure the connection is successful
		if (~Login.ChannelManager.connect(Login.Host, Login.Port, @receive))
			serverDisconnected();
		else
			Login.Button.setText('Authenticating');
		end
	end
	
	function receive(event)
		%% TODO: Decode Message
		
		packet = JSON.parse(char(event.message));
		if (strcmp(packet.Type, 'Shake'))
			if (packet.Step == 1) % Reply to the server
				
				% FAKE DATA ---
				key = [5,6;7,8];
				% END FAKE ----
				
				if (~sendHandshakePacket(event.channel, key, 2))
					serverDisconnected();
				end
			elseif (packet.Step == 3) % Finalize handshake - Login to the server now
				%% TODO FINALIZE THIS TOO...
				Login.Button.setText('Logging in...');
				%% TODO GET REAL KEY
				key = [];
				if (~sendLoginRequestPacket(event.channel, Login.UserField.getText(), Login.PassField.getText(), key))
					serverDisconnected();
				end
			end
		elseif (strcmp(packet.Type, 'Login')) % We got a response from the login server
			if (packet.Success) % We made it
				loginSuccess(Login.UserField.getText(), Login.Key);
			else % Password denied
				delete(Login.ChannelManager);
				errordlg('Invalid Password', 'Error', 'modal');
				Login.Button.setText('Login');
				GUI.enableAll();
				Login.PassField.setFocus();
			end
		else
			%% Possibly encrypted?
			errordlg(sprintf('Communication got mixed up somehow.\nPlease login again later.'), 'Error', 'modal');
		end
	end
	
	function serverDisconnected()
		%% TODO REmove the user/chat
		delete(Login.ChannelManager);
		errordlg(sprintf('Could not connect to %s:%d', Login.Host, Login.Port), 'Error', 'modal');
		Login.Button.setText('Login');
		GUI.enableAll();
	end
	
%% Login Callbacks
	% Move to chat window
	function loginSuccess(username, key)
		Login.Success = 1;
		
		AddPath('Client/UI');
		AddPath('Client/UI/GUIItems');
		
		close(Login.Window);
		
		ChatWindow(username, key);
	end

end