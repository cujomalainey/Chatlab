classdef User < handle
	%User A User Object To Keep Track Of All Of Them. Used By The ChatRoom And Server Objects
	
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
		
		function n = getName(this)
			n = this.Name;
		end
		
		function k = getKey(this)
			k = this.Key;
		end
	end
	
end