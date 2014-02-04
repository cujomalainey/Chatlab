classdef uint128 < uintLarge
	%uint128 A 128-bit integer
	
	properties
	end
	
	methods
		function u128 = uint128(Value)
			for i = 1:1:4
				u128.BLOCK(i) = 0;
			end
			u128.BLOCK(4) = Value;
		end
	end
	
end