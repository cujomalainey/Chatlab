function [success] = sendChatInviteResponsePacket(channel, chatID, response, key)
%sendChatInviteResponsePacket Return A Response To The Server About Joining A Chat Room
packet = struct('Type', 'ChatInviteResponse',...
	'ID', chatID,...
	'Response', response...
	);
success = sendMessage(channel, packet, key);
end