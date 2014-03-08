function [success] = sendKeyPacket(channel, key, encryptKey)
%sendChatPacket Send a message packet to the server
	packet = struct(	'Type', 'Key',...
						'Key', key...
						);
	success = sendMessage(channel, packet, encryptKey);
end