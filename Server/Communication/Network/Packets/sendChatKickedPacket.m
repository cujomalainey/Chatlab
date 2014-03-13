function [success] = sendChatKickedPacket(channel, id, key)
%sendChatKickedPacket Tell the client the chat was renamed
	packet = struct(	'Type', 'ChatKicked',...
						'ChatID', id...
						);
	success = sendMessage(channel, packet, key);
end