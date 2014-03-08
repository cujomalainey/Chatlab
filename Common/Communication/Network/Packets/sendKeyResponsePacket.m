function [success] = sendKeyResponsePacket(channel, response, key)
%sendChatPacket Send a message packet to the server
	packet = struct(	'Type', 'KeyResponse',...
						'Response', response...
						);
	success = sendMessage(channel, packet, key);
end