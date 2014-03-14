function [success] = sendDisconnectPacket(channel)
%sendDisconnectPacket Tell The Server That You Are Disconnecting
packet = struct('Type', 'Disconnect'...
	);
success = sendMessage(channel, packet, []);
end