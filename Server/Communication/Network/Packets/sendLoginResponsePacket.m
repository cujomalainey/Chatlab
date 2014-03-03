function [success] = sendLoginResponsePacket(channel, success)
%sendLoginResponsePacket Create a response for clients trying to login
	packet = struct(	'Type', 'Login',...
						'Success', success...
						);
	success = sendMessage(channel, packet);
end