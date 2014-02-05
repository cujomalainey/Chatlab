function [] = LaunchClient()
%LaunchClient Start the client process

	AddPath('Client');
	AddPath('Common');
% 	main();

AddPath('Client/UI');
AddPath('Common/UI');
AddPath('Common/UI/GUIItems');
ChatWindow();

end