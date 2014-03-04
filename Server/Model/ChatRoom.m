classdef ChatRoom < handle
	%ChatRoom The ChatRoom Object that the server will hold a reference to for
	%messaging
	
	properties (SetAccess = private)
		Creator = [];
		Users = [];
		Permissions = []
		Name = '';
		ID = '';
	end
	
	methods
		%% Constructor
		function room = ChatRoom(name, id, creator)
			room.Creator = creator;
			room.Name = name;
			room.ID = id;
		end
		
		%% User Management
		function addUser(this, user, permissionLevel)
			this.Users{length(this.Users) + 1} = user;
			this.Persmissions{length(this.Users) + 1} = permissionLevel;
		end
		
		function removeUser(this, user, reason)
			for i=1:1:length(this.Users)
				if (this.Users{i} == user)
					this.Users(i) = [];
					this.Permissions(i) = [];
					%% TODO SEND THE REASON
				end
			end
		end
		
		%% Misc
		function setName(this, name)
			this.Name = name;
			%% Propagate change - Send some message packet for room rename
		end
		
		%% Send message
		function sendMessage(this, message, sender)
			i = 1;
			while (i < length(this.Users))
				i = i + 1;
				user = this.Users{i};
				channel = user.getChannel();
				if (~sendChatPacket(channel, sender, this.ID, message))
					this.Creator.disconnectClient(channel);
				end
			end
			%% TODO Send message
		end
	end
	
end