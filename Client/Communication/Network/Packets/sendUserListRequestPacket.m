function [success] = sendUserListRequestPacket(channel, key)
%sendUserListRequestPacket Create a packet to request the user list
	packet = struct(	'Type', 'RequestUserList'...
						);
	success = sendMessage(channel, packet, key);
end