classdef encryptor

	properties (Access = private)
		keys = keyhandler()
    end
	methods

		function obj = encryptor()
			%init key handler
		end

		function addKey(obj, key, chatId)
			
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
            serial = mat2str(matrix);
        end

        function unserial = unserialize(obj, str)
            unserial = eval(str);
        end

	end % methods
end % classdef