%main server file
function [] = main_client()
	%% Add folders to the path
	AddPath('Server/UI');
	AddPath('Common/UI');
	AddPath('Common/UI/GUIItems');
	%% Create and show the LoginWindow
	ServerWindow();
end