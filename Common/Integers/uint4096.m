classdef uint4096 < uintLarge
	%uint128 A 1024-bit integer
	
	properties
	end
	
	methods
		function u4096 = uint4096(Value)
			for i = 1:1:128
				u4096.BLOCK(i) = 0;
			end
			u4096.BLOCK(128) = Value;
		end
	end
	
end