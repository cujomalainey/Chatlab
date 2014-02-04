function [] = LaunchClient()
%LaunchClient Start the client process
	
	AddPath('Client');
	AddPath('Common');
	main();
	
end