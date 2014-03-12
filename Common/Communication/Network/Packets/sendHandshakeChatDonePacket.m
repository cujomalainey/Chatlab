function [success] = sendHandshakeChatDonePacket(channel, tempKey, user, chatID, chatKey, key)
%sendHandshakeChatPacket Create a handshake packet and send it to the channel
	packet = struct(	'Type', 'ChatShakeDone',...
						'User', user,...
						'ChatID', chatID,...
						'ChatKey', chatKey,...
						'Key', tempKey...
						);
	success = sendMessage(channel, packet, key);
end