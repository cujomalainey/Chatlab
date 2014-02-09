%UI Model

classdef encryptor

	properties (SetAccess = private)
		key = [1 2 3; 2 5 3; 2 3 1];
    end
	methods

		function obj = UI_Controller()
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
            encryption = obj.serialize(obj.key*response);
		end % encrypt

        function message = decrypt(obj, encode, groupId)
            arr = inv(obj.key)*obj.unserialize(encode);
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

        function serial = serialize(obj, matrix)
            columns = size(matrix);
            columns = columns(2);
            str = '';
            for n = 1:columns
                for i = 1:3 
                    if ~(n == columns && i == 3)
                        str = strcat(str, int2str(matrix(i, n)), ',');
                    else
                        str = strcat(str, int2str(matrix(i, n)));
                    end
                end
            end
            serial = str;
        end

        function unserial = unserialize(obj, str)
            str = str2num(char(strsplit(str, ',')));
            rows = size(str);
            for n = 1:rows(1)
                i = mod(n, 3);
                if i == 0
                    columns = (n - i)/3;
                    i = 3;
                else
                    columns = (n - i)/3 + 1;
                end
                unserial(i,columns) = str(n, 1);
            end
        end

	end % methods
end % classdef