function [] = LaunchClient()
%LaunchClient Start the client process

	AddPath('Client');
	AddPath('Common');
% 	main_client();

AddPath('Client/UI');
AddPath('Client/UI/GUIItems');
AddPath('Common/UI');
AddPath('Common/UI/GUIItems');
ChatWindow('David');

end