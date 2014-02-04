classdef uint2048 < uintLarge
	%uint128 A 1024-bit integer
	
	properties
	end
	
	methods
		function u2048 = uint2048(Value)
			for i = 1:1:64
				u2048.BLOCK(i) = 0;
			end
			u2048.BLOCK(64) = Value;
		end
	end
	
end