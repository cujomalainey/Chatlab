classdef JString < handle
	%JString Convert A MATLAB String To A Byte Array
	methods (Static)
		%% Encode
		function bytes = encode(string)
			js = java.lang.String(string);
			bytes = js.getBytes();
		end
	end
end