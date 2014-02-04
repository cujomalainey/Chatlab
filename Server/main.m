%main server file

%initialize db and network

%create manager objects

%start helper threads

%enter listening mode

classdef Server < handle
	% The following properties can be set only by class methods
	properties (SetAccess = private)
		db
		network
	end
	% Define an event called InsufficientFunds
	events
		InsufficientFunds
	end
	methods
		function obj = Server()
			obj.db = AccountNumber;
			obj.network = InitialBalance;
		end
		function deposit(BA,amt)
			BA.AccountBalance = BA.AccountBalance + amt;
			if BA.AccountBalance > 0
				BA.AccountStatus = 'open';
			end
		end
		function withdraw(BA,amt)
			if (strcmp(BA.AccountStatus,'closed')&& BA.AccountBalance < 0)
				disp(['Account ',num2str(BA.AccountNumber),' has been closed.'])
				return
			end
			newbal = BA.AccountBalance - amt;
			BA.AccountBalance = newbal;
			% If a withdrawal results in a negative balance,
			% trigger the InsufficientFunds event using notify
			if newbal < 0
				notify(BA,'InsufficientFunds')
			end
		end % withdraw
	end % methods
end % classdef