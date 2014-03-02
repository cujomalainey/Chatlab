function [success] = sendMessage(channel, structure)
%sendMessage Send a message though the socket
	string = JSON.create(structure);
	
	%% TODO: ENCRYPT THE STRING
	%%
	
	bytes = JString.encode(string);
	buffer = java.nio.ByteBuffer.wrap(bytes);
	try
		channel.write(buffer);
		success = 1;
	catch
		success = 0;
	end
end