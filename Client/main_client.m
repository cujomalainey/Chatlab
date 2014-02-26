%main client file
function [] = main_client()
	%% Add folders to the path
	AddPath('Client/UI');
	AddPath('Client/Communication');
	AddPath('Client/Communication/Encryption');
	AddPath('Client/Communication/Hash');
	AddPath('Common/Communication');
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