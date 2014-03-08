%main server file
function [] = main_client()
	%% Add folders to the path
	AddPath('Server/UI');
	AddPath('Server/Model');
	AddPath('Server/Communication');
	AddPath('Server/Communication/Network');
	AddPath('Server/Communication/Network/Packets');
	AddPath('Server/Model');
	AddPath('Common/Communication');
	AddPath('Common/Communication/Encryption');
	AddPath('Common/Communication/Network');
	AddPath('Common/Communication/Network/Interface');
	AddPath('Common/Communication/Network/Packets');
	AddPath('Common/UI');
	AddPath('Common/UI/GUIItems');
	%% Install Java Bits
	Install();
	%% Create and show the LoginWindow
	ServerWindow();
end