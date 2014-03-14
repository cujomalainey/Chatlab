classdef UniqueID < handle
	%UniqueID Generate A Unique Integer For The Duration Of The Program
	
	properties (GetAccess = 'public', SetAccess = 'private')
		ID;
	end
	
	methods
		function uid = UniqueID()
			uid.ID = UniqueID.increment();
		end
	end
	
	methods (Static, Access = 'private')
		function result = increment()
			persistent stamp;
			if isempty(stamp)
				stamp = 0;
			end
			stamp = stamp + uint32(1);
			result = stamp;
		end
	end
	
end