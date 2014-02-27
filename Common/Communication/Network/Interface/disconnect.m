function disconnect(channel)
%disconnect Closes the channel
	try
		pause(0.1);
		channel.close();
	catch e
		rethrow(e);
	end
end