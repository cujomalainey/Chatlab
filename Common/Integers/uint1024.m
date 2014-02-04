classdef uint1024 < uintLarge
	%uint128 A 1024-bit integer
	
	properties
	end
	
	methods
		function u1024 = uint1024(Value)
			for i = 1:1:32
				u1024.BLOCK(i) = 0;
			end
			u1024.BLOCK(32) = Value;
		end
	end
	
end