classdef InviteUser < handle
	%TempUser The user before the user logs in
	
	properties (SetAccess = private)
		User = [];
		ChatID = 0;
	end
	
	methods
		%% Constructor
		function IU = InviteUser(user, id)
			IU.User = user;
			IU.ChatID = id;
		end
		
		%% Getters
		function u = getUser(this)
			u = this.User;
		end
		
		function id = getID(this)
			id = this.ChatID;
		end
	end
	
end