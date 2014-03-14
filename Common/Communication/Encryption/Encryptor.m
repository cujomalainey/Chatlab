classdef Encryptor < handle
	%Encryptor Encrypt And Decrypt Strings->Matrices Using A Key Matrix
	
	methods (Static)
		%% Encrypt
		function encrypted = encrypt(string, key)
			decrypted = double(string);
			elements = size(decrypted, 2);
			columns = ceil(elements / 3);
			encrypted = zeros(3, columns); % Preallocate
			for n = 1:columns
				for i = 1:3
					if (((n - 1) * 3 + i) <= elements)
						encrypted(i, n) = decrypted((n - 1) * 3 + i);
					end
				end
			end
			encrypted = mat2str(key * encrypted);
		end
		
		%% Decrypt
		function decrypted = decrypt(string, key)
			encrypted = key \ eval(string); % Save Use Of Eval
			columns = size(encrypted, 2);
			decrypted = zeros(1, (columns - 1) * 3 + 1);
			for n = 1:columns
				for i = 1:3
					if encrypted(i, n) ~= 0
						decrypted((n - 1) * 3 + i) = encrypted(i, n);
					end
				end
			end
			decrypted = char(uint32(decrypted));
		end
	end
	
end