classdef TempUser < handle
	%TempUser A Temporary User Used To Keep Track Of Clients Before They Authenticate
	
	properties (SetAccess = private)
		Channel = []; % Network Channel for communication
		manager;
	end
	
	methods
		%% Constructor
		function TU = TempUser(channel, keymanager)
			TU.Channel = channel;
			TU.manager = keymanager;
		end
		
		%% Getters
		function c = getChannel(this)
			c = this.Channel;
		end
		
		function key = getKey(this)
			key = this.manager.getKey(1);
		end
		
		%% Functionality
		function key = start(this)
			key = this.manager.buildKey(1);
		end
		
		function finish(this, opposingKey)
			this.manager.addKey(opposingKey, 1);
		end
	end
	
end