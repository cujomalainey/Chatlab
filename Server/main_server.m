%main server file
function [] = main_client()
	%% Add folders to the path
	AddPath('Server/UI');
	AddPath('Common/Communication');
	AddPath('Common/Communication/Network');
	AddPath('Common/UI');
	AddPath('Common/UI/GUIItems');
	%% Install Java Bits
	Install();
	%% Create and show the LoginWindow
	ServerWindow();
end