function [structure] = handshake(key, step)
%handshake Create a handshake packet
	structure = struct(	'Type', 'Shake',...
						'Step', step,... Init, Response, Complete --> Response is client
						'Key', mat2str(key)...
						);
end