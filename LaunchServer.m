function [] = LaunchServer()
%LaunchServer Start the server process
	
	AddPath('Server');
	AddPath('Common');
	main_server();
	
end