%main client file
function [] = main_client()
	%% Add folders to the path
	AddPath('Client/UI');
	AddPath('Common/Communication');
	AddPath('Common/Communication/Network');
	AddPath('Common/UI');
	AddPath('Common/UI/GUIItems');
	%% Install Java Bits
	Install();
	%% Create and show the LoginWindow
	LoginWindow();
end