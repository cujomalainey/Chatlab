function [success] = sendDisconnectPacket(channel, key)
%sendDisconnectPacket Create a packet to tell the server you are disconnecting
	packet = struct(	'Type', 'Disconnect'...
						);
	success = sendMessage(channel, packet, key);
end