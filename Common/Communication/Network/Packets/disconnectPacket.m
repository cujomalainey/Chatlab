function [structure] = disconnectPacket()
%disconnectPacket Create a packet to tell the server you are disconnecting
	structure = struct(	'Type', 'Disconnect'...
						);
end