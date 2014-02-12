%key handler

classdef keyhandler

	properties (Access = public) 
    %Access = private)
		chain = struct
    end
	methods

		function obj = keyhandler()

		end

        function key = getKey(obj, groupId)
			key = chain.(num2str(groupId));
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
                end
            end
            id = strcat('u', num2str(userId));
            obj.chain.(id) = mat
        end

        function addKey(obj, groupId)

        end
	end % methods
end % classdef