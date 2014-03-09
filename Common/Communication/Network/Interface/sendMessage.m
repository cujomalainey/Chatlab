function [success] = sendMessage(channel, structure, key)
%sendMessage Send a message though the socket
	string = JSON.create(structure);
	
	if (~isempty(key))
		string = Encryptor.encrypt(string, key);
	end
	
	bytes = JString.encode(string);
	buffer = java.nio.ByteBuffer.wrap(bytes);
	try
		channel.write(buffer);
		success = 1;
	catch
		success = 0;
	end
end