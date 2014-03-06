function [success] = sendChatLeavePacket(channel, id, key)
%sendChatLeavePacket Tell the server that you are leaving the room
	packet = struct(	'Type', 'LeaveChat',...
						'ID', id...
						);
	success = sendMessage(channel, packet, key);
end