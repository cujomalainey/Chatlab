function [success] = sendInviteUserFailedPacket(channel, username, key)
%sendInviteUserFailedPacket Create a response telling the client the user
%couldn't be invited
	packet = struct(	'Type', 'InviteFailed',...
						'Name', username...
						);
	success = sendMessage(channel, packet, key);
end