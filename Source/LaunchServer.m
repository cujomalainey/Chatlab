function [] = LaunchServer()
%LaunchServer Start The Server
AddPath('Server');
AddPath('Common');
ClearPath();
main_server();
end