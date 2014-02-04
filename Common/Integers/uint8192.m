classdef uint8192 < uintLarge
	%uint128 A 1024-bit integer
	
	properties
	end
	
	methods
		function u8192 = uint8192(Value)
			for i = 1:1:256
				u8192.BLOCK(i) = 0;
			end
			u8192.BLOCK(256) = Value;
		end
	end
	
end