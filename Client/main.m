%main client file
function [] = main()
	
	%% Add folders to the path
	AddPath('Client/UI');
	AddPath('Common/UI');
	AddPath('Common/UI/GUIItems');
	
	%% Create and show the LoginWindow
	LoginWindow();
	
	
	
end