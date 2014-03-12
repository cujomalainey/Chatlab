function [success] = sendHandshakeChatPacket(channel, tempKey, chatID, key)
%sendHandshakeChatPacket Create a handshake packet and send it to the channel
	packet = struct(	'Type', 'ChatShake',...
						'ChatID', chatID,...
						'Key', tempKey...
						);
	success = sendMessage(channel, packet, key);
end