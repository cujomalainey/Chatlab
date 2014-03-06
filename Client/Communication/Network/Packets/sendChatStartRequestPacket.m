function [success] = sendChatStartRequestPacket(channel, username, key)
%sendLoginRequestPacket Create a request to log into the server and send it
	packet = struct(	'Type', 'StartChat',...
						'Username', username...
						);
	success = sendMessage(channel, packet, key);
end