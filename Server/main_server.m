%main server file
function [] = main_client()
	%% Add folders to the path
	AddPath('Server/UI');
	AddPath('Common/Communication');
	AddPath('Common/UI');
	AddPath('Common/UI/GUIItems');
	%% Create and show the LoginWindow
	ServerWindow();
end