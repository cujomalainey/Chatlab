%key handler

classdef keyhandler < handle

	properties (SetAccess = private) 
		chain
    end
	methods

		function obj = keyhandler()
            obj.chain = struct();
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
                    r = randi(10);
                    mat(i, j) = r;
                    send(i, j) = mod(3^r, 17);
                end
            end
            id = strcat('u', num2str(userId));
            obj.chain.(id) = mat;
            msg = send;
        end
        
        function msg = returnkey(obj, groupId, userId, request, forced)
            %completes key request
            msg = obj.startkey(userId);
            if forced == true
                obj.addkey(userId, groupId, request);
                test = log10(abs(det(obj.chain.(strcat('k', num2str(groupId))))));
                if test < -9 || test > 9 || isnan(det(obj.chain.(strcat('k', num2str(groupId)))))
                    msg = -1;
                end
            end
        end
        
        function addkey(obj, userId, groupId, matrix)
            obj.chain.(strcat('k', num2str(groupId))) = matrix .^ obj.chain.(strcat('u', num2str(userId)));
        end
	end % methods
end % classdef