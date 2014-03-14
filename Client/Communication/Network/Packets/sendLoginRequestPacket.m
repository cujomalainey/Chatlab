function [success] = sendLoginRequestPacket(channel, username, password, key)
%sendLoginRequestPacket Request To Log Into The Server
password = MD5.hash(password);
packet = struct('Type', 'Login',...
	'Username', username,...
	'Password', password...
	);
success = sendMessage(channel, packet, key);
end