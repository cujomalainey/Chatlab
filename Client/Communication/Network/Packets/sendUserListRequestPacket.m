function [success] = sendUserListRequestPacket(channel, key)
%sendUserListRequestPacket Ask The Server To Send A List Of Online Users
packet = struct('Type', 'RequestUserList'...
	);
success = sendMessage(channel, packet, key);
end