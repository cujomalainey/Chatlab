function [] = LaunchServer()
%LaunchServer Start the server process
	AddPath('Server');
	AddPath('Common');
	ClearPath();
	main_server();
end