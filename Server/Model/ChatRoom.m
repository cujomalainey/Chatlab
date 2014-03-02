classdef ChatRoom < handle
	%ChatRoom The ChatRoom Object that the server will hold a reference to for
	%messaging
	
	properties (SetAccess = private)
		Users = [];
		Name = '';
		ID = '';
	end
	
	methods
		%% Constructor
		function room = ChatRoom(name, id)
			room.Name = name;
			room.ID = id;
		end
		
		%% User Management
		function addUser(this, user, permissionLevel)
			%% TODO
		end
		
		function removeUser(this, user, reason)
			%% TODO
		end
		
		%% Misc
		function setName(this, name)
			this.Name = name;
			%% Propagate change - Send some message packet for room rename
		end
		
		%% Send message
		function sendMessage(this, message)
			%% TODO Send message
		end
	end
	
end