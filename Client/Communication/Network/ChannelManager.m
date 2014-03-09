classdef ChannelManager < handle
	%ConnectionManager Manages a connection for the client
	
	properties
		ReceiveCallback;
		Channel;
	end
	
	%% The designated public contructor
	methods (Static)
		function channelManager = instance()
			persistent uniqueInstance
			if isempty(uniqueInstance)
				channelManager = ChannelManager();
				uniqueInstance = channelManager;
			else
				channelManager = uniqueInstance;
			end
		end
	end
	
	methods
		function valid = connect(this, host, port, callback)
			this.disconnect(); % Cleanup just in case
			this.ReceiveCallback = callback;
			this.Channel = connect(host, port, @this.receiveMessage);
			valid = 1;
			if (isempty(this.Channel))
				valid = 0;
			end
		end
		
		function disconnect(this)
			try
				pause(0.1);
				this.Channel.close();
			catch
			end
			this.Channel = [];
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
		function channel = getChannel(this)
			channel = this.Channel;
		end
		
		%% Cleanup
		function delete(this)
			this.disconnect();
		end
	end
	
end