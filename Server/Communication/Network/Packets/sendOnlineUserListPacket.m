function [success] = sendOnlineUserListPacket(channel, list, key)
%sendOnlineUserListPacket Give The Clients A List Of Online Users
packet = struct('Type', 'UserList',...
	'List', {list}...
	);
success = sendMessage(channel, packet, key);
end