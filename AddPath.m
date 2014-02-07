function [] = AddPath( subDir )
%pathUtil Add a subDirectory to the current matlab search path
	
	basePath = pwd;
	path(fullfile(basePath, subDir), path);
	
end