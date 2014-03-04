function [success] = sendDisconnectPacket(channel)
%sendDisconnectPacket Create a packet to tell the server you are disconnecting
	packet = struct(	'Type', 'Disconnect'...
						);
	success = sendMessage(channel, packet, []);
end