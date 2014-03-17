function Disconnect(channel)
%Disconnect Closes The Channel
try
	pause(0.1);
	channel.close();
catch
end
end