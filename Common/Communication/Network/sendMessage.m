function [lengthWritten] = sendMessage(channel, string)
%sendMessage Send a message though the socket
	
	bytes = JString.encode(string);
	buffer = java.nio.ByteBuffer.wrap(bytes);
	lengthWritten = channel.write(buffer);
	
end