classdef ChatRoom < handle
	%ChatRoom The ChatRoom Object that the server will hold a reference to for
	%messaging
	
	properties (SetAccess = private)
		Users = {};
		Permissions = {}; % Owner, Moderator, Client -> string
		Name = '';
		ID = 0;
	end
	
	methods
		%% Constructor
		function room = ChatRoom(name, id)
			room.Name = name;
			room.ID = id;
		end
		
		%% User Management
		function addUser(this, user, permission)
			this.sendMessage('Server', sprintf('%s has joined the chat', user.getName()));
			this.Users{length(this.Users) + 1} = user;
			this.Permissions{length(this.Users)} = permission;
		end
		
		function removeUser(this, user, reason, callback)
			i = 0;
			while (i < length(this.Users))
				i = i + 1;
				if (this.Users{i} == user)
					this.Users(i) = [];
					this.Permissions(i) = [];
					if (~isempty(reason))
						%% TODO SEND THE REASON
					end
					this.sendMessage('Server', sprintf('%s has left the chat', user.getName()));
				end
			end
			% Delete the room if there are no more users in it
			if (isempty(this.Users))
				callback(this);
			end
		end
		
		%% Misc
		function setName(this, name)
			this.Name = name;
			%% Propagate change - Send some message packet for room rename
		end
		
		function n = getName(this)
			n = this.Name;
		end
		
		function id = getID(this)
			id = this.ID;
		end
		
		%% Send message
		function sendMessage(this, sender, message)
			i = 0;
			while (i < length(this.Users))
				i = i + 1;
				user = this.Users{i};
				channel = user.getChannel();
				if (~sendChatPacket(channel, sender, this.ID, message, user.getKey()))
					this.Creator.disconnectClient(channel);
				end
			end
		end
	end
	
end