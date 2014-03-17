classdef MD5
	%MD5 Uses The MD5 Algorithm To Hash Of A String
	methods (Static)
		%% Hash
		function string = hash(string)
			js = java.lang.String(string);
			bytes = js.getBytes('UTF-8');
			md = java.security.MessageDigest.getInstance('MD5');
			hashBytes = md.digest(bytes);
			js = java.lang.String(hashBytes);
			string = strrep(char(js), '"', '''');
		end
	end
end