function [] = LaunchServer()
%LaunchServer Start the server process
	ClearPath();
	AddPath('Server');
	AddPath('Common');
	main_server();
end