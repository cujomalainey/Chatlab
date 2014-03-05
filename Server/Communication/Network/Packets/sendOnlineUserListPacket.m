function [success] = sendOnlineUserListPacket(channel, list, key)
%sendOnlineUserListPacket Create a response for clients asking for a list of
%users
	packet = struct(	'Type', 'UserList',...
						'List', {list}...
						);
	success = sendMessage(channel, packet, key);
end