function [success] = sendChatInviteResponsePacket(channel, chatID, response, key)
%sendChatInviteResponsePacket Give the response to the server
	packet = struct('Type', 'ChatInviteResponse',...
					'ID', chatID,...
					'Response', response...
					);
	success = sendMessage(channel, packet, key);
end