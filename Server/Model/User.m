classdef User < handle
	%User The user object that the chat room will reference for sending messages
	
	properties (SetAccess = private)
		Name = ''; % This is unique
		Channel = []; % Network Channel for communication
	end
	
	methods
		%% Constructor
		function u = User(name, channel)
			u.Name = name;
			u.Channel = channel;
		end
		
		%% Send message
		function sendMessage(this, message)
			%% TODO send the message
		end
	end
	
end