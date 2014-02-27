function [structure] = handshake(key, step)
%handshake Create a handshake packet
	structure = struct(	'Type', 'Login',...
						'Step', step,... Init, Response, Complete --> Response is client
						'Key', key...
						);
end