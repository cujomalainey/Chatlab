function [ matrix ] = decodeMatrix( string )
%decodeMatrix Takes a string and converts it to a NxN matrix. WARNING! Looking
%at the source may be painful.
%   Usage: decodeMatrix('[1,2,3;1,2,3;1,2,3]') would return [1,2,3;1,2,3;1,2,3]
%   as a matrix
	matrix = eval(string);
end