function [ string ] = encodeMatrix( matrix )
%encodeMatrix Takes a NxN matrix and converts it to a string. WARNING! Looking
%at the source may be painful.
%   Usage: encodeMatrix([1,2,3;1,2,3;1,2,3]) would return '[1,2,3;1,2,3;1,2,3]'
%   as a string
	string = mat2str(matrix);
end