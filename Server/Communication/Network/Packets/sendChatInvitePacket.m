function [success] = sendChatInvitePacket(channel, chatID, username, key)
%sendChatInvitePacket Ask the client if they want to join a room by username
	packet = struct(	'Type', 'ChatInvite',...
						'ID', chatID,...
						'Name', username...
						);
	success = sendMessage(channel, packet, key);
end