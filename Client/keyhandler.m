%key handler

classdef keyhandler

	properties (Access = private)
		chain = struct
    end
	methods

		function obj = keyhandler()

		end

        function key = getKey(obj, message, groupId)
			
		end % encrypt

        function deleteKey(obj, groupId)
            rmfield(obj.chain, num2str(groupId))
        end

        function msg = startkey(obj, groupId, userId)
            
        end

        function next = stepkey(obj, str)

        end

        function addKey(obj, key, groupId)

        end
	end % methods
end % classdef