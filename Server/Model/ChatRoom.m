classdef ChatRoom < handle
	%ChatRoom The ChatRoom Object that the server will hold a reference to for
	%messaging
	
	properties (SetAccess = private)
		Users = {};
		Permissions = {}; % Owner, Moderator, Client, Mute -> string
		Name = '';
		ID = 0;
		DisconnectCB = [];
	end
	
	methods
		%% Constructor
		function room = ChatRoom(name, id, dccb)
			room.Name = name;
			room.ID = id;
			room.DisconnectCB = dccb;
		end
		
		%% User Management
		function addUser(this, user, permission)
			this.sendMessage('Server', sprintf('%s has joined the chat', user.getName()));
			this.Users{length(this.Users) + 1} = user;
			this.Permissions{length(this.Users)} = permission;
		end
		
		function removeUser(this, user, reason, callback)
			i = 0;
			shouldRekey = 0;
			while (i < length(this.Users))
				i = i + 1;
				if (this.Users{i} == user)
					this.Users(i) = [];
					this.Permissions(i) = [];
					if (~isempty(reason))
						sendChatKickedPacket(user.getChannel(), this.getID(), user.getKey());
						if (strcmp(reason, 'Kick'))
							this.sendMessage('Server', sprintf('%s has been kicked from the chat.', user.getName()));
						end
					else
					this.sendMessage('Server', sprintf('%s has left the chat', user.getName()));
					end
					shouldRekey = 1;
				end
			end
			% Delete the room if there are no more users in it
			if (isempty(this.Users))
				callback(this);
			else
				if (shouldRekey)
					this.rekey(); % Rekey so the chat stays secure from the old users
				end
			end
		end
		
		%% Misc
		function setName(this, name)
			this.Name = name;
			i = 0;
			while (i < length(this.Users))
				i = i + 1;
				user = this.Users{i};
				channel = user.getChannel();
				if (~sendChatRenamedPacket(channel, name, this.ID, user.getKey()))
					this.DisconnectCB(channel);
				end
			end
			%% Propagate change - Send some message packet for room rename
		end
		
		function rekey(this)
			owner = this.getOwner();
			if (~sendChatRekeyPacket(owner.getChannel(), this.getID(), 1, owner.getKey()))
				this.DisconnectCB(owner.getChannel());
				this.selectNewOwner(); % Select a new owner and rekey
				this.rekey();
				return;
			end
			pause(0.1);
			i = 0;
			while (i < length(this.Users))
				i = i + 1;
				user = this.Users{i};
				if (user == this.getOwner())
					continue;
				end
				channel = user.getChannel();
				if (~sendChatRekeyPacket(channel, this.getID(), 0, user.getKey()))
					this.DisconnectCB(channel);
				end
			end
		end
		
		function selectNewOwner(this)
			for i = 1:1:length(this.Permissions)
				if (strcmp(this.Permissions{i}, 'Moderator'))
					this.Permissions{i} = 'Owner';
					if (~sendChatPacket(this.Users{i}.getChannel(), 'Server', this.ID, 'You are now the owner of this chat room', this.Users{i}.getKey()))
						this.DisconnectCB(this.Users{i}.getChannel());
					end
					return;
				end
			end
			% Set the oldest person in the chat to be the new owner
			this.Permissions{1} = 'Owner';
			if (~sendChatPacket(this.Users{1}.getChannel(), 'Server', this.ID, 'You are now the owner of this chat room', this.Users{1}.getKey()))
				this.DisconnectCB(this.Users{1}.getChannel());
			end
		end
		
		function n = getName(this)
			n = this.Name;
		end
		
		function id = getID(this)
			id = this.ID;
		end
		
		function owner = getOwner(this)
			owner = [];
			for i = 1:1:length(this.Permissions)
				if (strcmp(this.Permissions{i}, 'Owner'))
					owner = this.Users{i};
					return;
				end
			end
			if (isempty(owner))
				this.selectNewOwner();
			end
			owner = this.getOwner();
		end
		
		function bool = containsUser(this, user)
			bool = 0;
			for i = 1:1:length(this.Users)
				if (this.Users{i} == user)
					bool = 1;
					return;
				end
			end
		end
		
		function bool = canUserInvite(this, user)
			bool = 0;
			for i = 1:1:length(this.Users)
				if (this.Users{i} == user)
					if (strcmp(this.Permissions{i}, 'Owner') || strcmp(this.Permissions{i}, 'Moderator'))
						bool = 1;
					end
					return;
				end
			end
		end
		
		function bool = canUserChat(this, user)
			bool = 0;
			for i = 1:1:length(this.Users)
				if (this.Users{i} == user)
					if (strcmp(this.Permissions{i}, 'Owner') || strcmp(this.Permissions{i}, 'Moderator') || strcmp(this.Permissions{i}, 'Client'))
						bool = 1;
					end
					return;
				end
			end
		end
		
		function muteUser(this, user)
			for i = 1:1:length(this.Permissions)
				if (this.Users{i} == user)
					this.Permissions{i} = 'Mute';
					if (~sendChatPacket(this.Users{i}.getChannel(), 'Server', this.ID, 'You have been muted', this.Users{i}.getKey()))
						this.DisconnectCB(this.Users{i}.getChannel());
					end
					return;
				end
			end
		end
		
		function unmuteUser(this, user)
			for i = 1:1:length(this.Permissions)
				if (this.Users{i} == user)
					this.Permissions{i} = 'Client';
					if (~sendChatPacket(this.Users{i}.getChannel(), 'Server', this.ID, 'You have been unmuted', this.Users{i}.getKey()))
						this.DisconnectCB(this.Users{i}.getChannel());
					end
					return;
				end
			end
		end
		
		function promote(this, user)
			for i = 1:1:length(this.Permissions)
				if (this.Users{i} == user)
					this.Permissions{i} = 'Moderator';
					if (~sendChatPacket(this.Users{i}.getChannel(), 'Server', this.ID, 'You have been promoted to Moderator', this.Users{i}.getKey()))
						this.DisconnectCB(this.Users{i}.getChannel());
					end
					return;
				end
			end
		end
		
		function users = getUsers(this)
			users = this.Users;
		end
		
		function permissions = getPermissions(this)
			permissions = this.Permissions;
		end
		
		%% Send message
		function sendMessage(this, sender, message)
			i = 0;
			while (i < length(this.Users))
				i = i + 1;
				user = this.Users{i};
				channel = user.getChannel();
				if (~sendChatPacket(channel, sender, this.ID, message, user.getKey()))
					this.DisconnectCB(channel);
				end
			end
		end
	end
	
end