%UI Model

classdef encryptor

% UI MEMBER HERE


% UI CALLBACKS
%%%%%%%%%%%%%%%%



	properties (Hidden)
		%AccountStatus = 'open';
	end
	% The following properties can be set only by class methods
	properties (SetAccess = private)
		key = [1 2 3; 2 5 3; 2 3 1];
    end
	methods
		function obj = UI_Controller() %#ok<STOUT>
			%init key handler
		end
		function addKey(obj, key, chatId)
			%BA.AccountBalance = BA.AccountBalance + amt;
			%if BA.AccountBalance > 0
			%	BA.AccountStatus = 'open';
			%end
		end
        function encryption = encrypt(obj, message, groupId)
			ascii = double(message);
            %disp(groupId)
			elements = size(ascii);
            elements = elements(2);
            columns = ceil(elements/3);
            response = zeros(3, columns);
            for n = 1:columns
                for i = 1:3
                    if (n-1)*3 + i <= elements,
                        response(i,n) = ascii((n-1)*3 + i);
                    end
                end
            end
            encryption = obj.key*response;
		end % encrypt
        function message = decrypt(obj, encode, groupId)
            arr = inv(obj.key)*encode;
            columns = size(arr);
            columns = columns(2);
            for n = 1:columns
                for i = 1:3
                    if arr(i, n) ~= 0 
                        ascii((n-1)*3 + i) = arr(i, n);
                    end
                end
            end
            message = char(ascii);
        end %decrypt
	end % methods
end % classdef