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
		'StartDelay', 0.1...
		);
	start(Login.initTimer);
	
%% Other Login Parameters
	Login.Success = 0;
	
	Login.KeyManager = KeyManager();
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
			username = Login.UserField.getText();
			if (isstrprop(username(1), 'alpha'))
				Login.PassField.setFocus();
			else
				Login.PassField.setFocus();
				Login.UserField.setFocus();
			end
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
		% Make sure the connection is successful
		if (~Login.ChannelManager.connect(Login.Host, Login.Port, @receive))
			serverDisconnected();
		else
			Login.Button.setText('Authenticating');
		end
	end
	
	function receive(event)
		message = char(event.message);
		channel = event.channel;
		%% Decrypt The String
		try
			eval([message, ';']); % Sould fail here if its not encrypted
			message = Encryptor.decrypt(message, Login.Key);
		catch
		end
		packet = JSON.parse(message);
		switch packet.Type
			case 'Shake'
				if (packet.Step == 1)
					publicKey = Login.KeyManager.finishKey(packet.Key, 1);
					Login.Key = Login.KeyManager.getKey(1);
					%% Send the key to the server
					if (~sendHandshakePacket(channel, publicKey, 2))
						serverDisconnected();
					end
				elseif (packet.Step == 3)
					Login.Button.setText('Logging in...');
					if (~sendLoginRequestPacket(channel, Login.UserField.getText(), Login.PassField.getText(), Login.Key))
						serverDisconnected();
					end
				end
			case 'Login'
				if (packet.Success) % We made it
					loginSuccess();
				else % Password denied
					Login.ChannelManager.disconnect();
					errordlg('Invalid Password', 'Error', 'modal');
					Login.Button.setText('Login');
					GUI.enableAll();
					Login.PassField.setFocus();
				end
			otherwise
				errordlg(sprintf('Communication got mixed up somehow.\nPlease login again later.'), 'Error', 'modal');
		end
	end
	
	function serverDisconnected()
		Login.ChannelManager.disconnect();
		errordlg(sprintf('Could not connect to %s:%d', Login.Host, Login.Port), 'Error', 'modal');
		Login.Button.setText('Login');
		GUI.enableAll();
	end
	
%% Login Callbacks
	% Move to chat window
	function loginSuccess()
		Login.Success = 1;
		username = Login.UserField.getText();
		AddPath('Client/UI');
		AddPath('Client/UI/GUIItems');
		close(Login.Window);
		ChatWindow(username, Login.Key);
	end

end