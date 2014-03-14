%Main Client File
function [] = main_client()
%% Add folders to the path
AddPath('Client/UI');
AddPath('Client/Communication');
AddPath('Client/Communication/Hash');
AddPath('Client/Communication/Network');
AddPath('Common/Communication/Network/Client');
AddPath('Client/Communication/Network/Packets');
AddPath('Common/Communication');
AddPath('Common/Communication/Encryption');
AddPath('Common/Communication/Network');
AddPath('Common/Communication/Network/Interface');
AddPath('Common/Communication/Network/Packets');
AddPath('Common/UI');
AddPath('Common/UI/GUIItems');
%% Install Java Bits
Install();
%% Create and show the LoginWindow
LoginWindow();
end