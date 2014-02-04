classdef uint256 < uintLarge
	%uint128 A 256-bit integer
	
	properties
	end
	
	methods
		function u256 = uint256(Value)
			for i = 1:1:8
				u256.BLOCK(i) = 0;
			end
			u256.BLOCK(8) = Value;
		end
	end
	
end