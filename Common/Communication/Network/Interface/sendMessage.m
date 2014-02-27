function [lengthWritten] = sendMessage(channel, structure)
%sendMessage Send a message though the socket
	string = JSON.create(structure);
	
	%% TODO: ENCRYPT THE STRING
	%%
	
	bytes = JString.encode(string);
	buffer = java.nio.ByteBuffer.wrap(bytes);
	lengthWritten = channel.write(buffer);
end