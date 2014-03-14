function [success] = sendLoginResponsePacket(channel, success)
%sendLoginResponsePacket Respond To The Client Telling If The Login Was Successful Or Not
packet = struct('Type', 'Login',...
	'Success', success...
	);
success = sendMessage(channel, packet, []);
end