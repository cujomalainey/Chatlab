function disconnect(channel)
%disconnect Closes the channel
	try
		pause(1);
		channel.close();
	catch
		rethrow(lasterror);
	end
end