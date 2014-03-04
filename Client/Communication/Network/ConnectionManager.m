classdef ConnectionManager < handle
	%ConnectionManager Manages a connection for the client
	
	properties (Hidden)
		ReceiveCallback;
		Channel;
		Valid;
	end
	
	methods
		%% Constructor
		function CM = ConnectionManager(host, port, callback)
			CM.ReceiveCallback = callback;
			CM.Channel = connect(host, port, @CM.receiveMessage);
			if (isempty(CM.Channel))
				CM.Valid = 0;
			else
				CM.Valid = 1;
			end
		end
		
		function disconnect(this)
			try
				disconnect(this.Channel);
			catch
			end
		end
		
		%% Callback
		function receiveMessage(this, ~, event)
			this.ReceiveCallback(event);
		end
		
		%% Setters
		function setCallback(this, callback)
			this.ReceiveCallback = callback;
		end
		
		%% Getters
		function connected = isConnected(this)
			connected = this.Valid;
		end
		
		function channel = getChannel(this)
			channel = this.Channel;
		end
		
		%% Cleanup
		function delete(this)
			try
				this.Channel.close();
			catch
			end
		end
	end
	
end