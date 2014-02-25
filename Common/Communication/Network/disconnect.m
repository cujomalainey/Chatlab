function disconnect(channel)
%disconnect Closes the channel
	try
		pause(1);
		sockChannel.close();
	catch
	end
end