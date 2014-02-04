classdef uint512 < uintLarge
	%uint128 A 512-bit integer
	
	properties
	end
	
	methods
		function u512 = uint512(Value)
			for i = 1:1:16
				u512.BLOCK(i) = 0;
			end
			u512.BLOCK(16) = Value;
		end
	end
	
end