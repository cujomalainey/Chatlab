classdef JString < handle
%JString a class to convert Java strings to byte arrays and back
	methods (Static)
		%% Encode
		function bytes = encode(string)
			js = java.lang.String(string);
			bytes = js.getBytes();
		end
	end
end