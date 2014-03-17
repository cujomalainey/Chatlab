function [success] = sendChatKickedPacket(channel, id, key)
%sendChatKickedPacket Tell The Client That They Were Kicked From The Chat Room
packet = struct('Type', 'ChatKicked',...
	'ChatID', id...
	);
success = sendMessage(channel, packet, key);
end