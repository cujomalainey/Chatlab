function [] = AddPath(subDir)
%AddPath Add A SubDirectory To The Current MATLAB Search Path
basePath = pwd;
path(fullfile(basePath, subDir), path);
end