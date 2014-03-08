%key handler

classdef keyhandler

	properties (SetAccess = private) 
		chain
    end
	methods

		function obj = keyhandler()
            obj.chain = struct;
		end

        function key = getKey(obj, groupId)
			key = obj.chain.(num2str(groupId));
		end

        function deleteKey(obj, groupId)
            rmfield(obj.chain, num2str(groupId));
        end

        function msg = startkey(obj, userId)
            %gen private keys in place of permnanent key
            %replace when recieve other players key
            for j = 1:3
                for i = 1:3
                    r = randi(170);
                    mat(i, j) = r;
                    send(i, j) = mod(3^r, 17);
                end
            end
            id = strcat('u', num2str(userId));
            disp(id);
            disp(mat);
            obj.chain.(id) = mat;
            disp(obj.chain.(id));
            msg = send;
        end

        function addKey(obj, groupId)

        end
	end % methods
end % classdef