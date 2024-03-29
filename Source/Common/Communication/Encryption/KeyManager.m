classdef KeyManager < handle
    %KeyManager Generate And Manage Matrix-Based Keys For Use In Encryption Between The Client And Server
    
    properties (SetAccess = private)
        KeyChain; % Used for final keys
        BuildingChain; % Used for the private side of the keys
    end
    
    methods
        %% Constructor
        function manager = KeyManager()
            manager.KeyChain = struct();
            manager.BuildingChain = struct();
        end
        
        %% Getters
        function key = getKey(this, id)
            key = this.KeyChain.(['key', num2str(id)]);
        end
        
        function deleteKey(this, id)
            this.KeyChain = rmfield(this.KeyChain, ['key', num2str(id)]);
        end
        
        %% Key Building - Step 1
        function key = buildKey(this, id)
            % Builds the public key for sending to the other end
            privateKey = randi(13,3);
            publicKey = mod(3 .^ privateKey, 17);
            this.setBuildingKey(id, privateKey);
            key = mat2str(publicKey); % Convert it to a string
        end
        
        %% Step 2
        function key = finishKey(this, opposingKey, id)
            k = str2num(opposingKey); %#ok<ST2NM>
            if (isempty(k))
                key = '[]';
                this.deleteBuildingKey(id);
                return;
            end
            publicKey = this.buildKey(id);
            privateKey = mod(k .^ this.getBuildingKey(id), 17);
            if (abs(det(privateKey)) < (10^(-6)))
                key = this.finishKey(opposingKey, id);
                return;
            else
                this.setKey(id, privateKey); % Save the key
            end
            this.deleteBuildingKey(id);
            key = publicKey;
        end
        
        %% Step 3
        function addKey(this, opposingKey, id)
            k = str2num(opposingKey); %#ok<ST2NM>
            if (isempty(k))
                this.deleteBuildingKey(id);
                return;
            end
            key = mod(k .^ this.getBuildingKey(id), 17);
            this.setKey(id, key);
            this.deleteBuildingKey(id);
        end
    end
    
    %% SUPER SECRET! DO NOT USE!!!
    methods % I'M SUPER SERIAL ABOUT THIS...
        %% Final Keys
        function setKey(this, id, key)
            this.KeyChain.(['key', num2str(id)]) = key;
        end
    end
    
    methods (Access = private)
        %% Building Keys
        function key = getBuildingKey(this, id)
            key = this.BuildingChain.(['key', num2str(id)]);
        end
        
        function setBuildingKey(this, id, key)
            this.BuildingChain.(['key', num2str(id)]) = key;
        end
        
        function deleteBuildingKey(this, id)
            this.BuildingChain = rmfield(this.BuildingChain, ['key', num2str(id)]);
        end
    end
    
end