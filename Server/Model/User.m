classdef User < handle
	%User The user object that the chat room will reference for sending messages
	
	properties (SetAccess = private)
		Name = ''; % This is unique
		Channel = []; % Network Channel for communication
		Key = [];
	end
	
	methods
		%% Constructor
		function u = User(name, channel, key)
			u.Name = name;
			u.Channel = channel;
			u.Key = key;
		end
		
		%% Getters
		function c = getChannel(this)
			c = this.Channel;
		end
	end
	
end