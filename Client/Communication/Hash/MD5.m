classdef MD5 < handle
%JString a class to convert Java strings to byte arrays and back
	methods (Static)
		%% Encode
		function string = hash(string)
			js = java.lang.String(string);
			bytes = js.getBytes('UTF-8');
			md = java.security.MessageDigest.getInstance('MD5');
			hashBytes = md.digest(bytes);
			js = java.lang.String(hashBytes);
			string = char(js);
		end
	end
end