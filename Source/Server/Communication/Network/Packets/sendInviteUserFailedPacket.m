function [success] = sendInviteUserFailedPacket(channel, username, key)
%sendInviteUserFailedPacket Tell The Client That The User Could Not Be Invited To The Chat
packet = struct('Type', 'InviteFailed',...
	'Name', username...
	);
success = sendMessage(channel, packet, key);
end