function [success] = sendChatLeavePacket(channel, id, key)
%sendChatLeavePacket Tell The Server That You Are Leaving The Chat Room
packet = struct('Type', 'LeaveChat',...
	'ID', id...
	);
success = sendMessage(channel, packet, key);
end