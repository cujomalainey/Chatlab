function [] = Compile()
%Compile  Obfuscate the code to the Release directory
	
%%
% Hide the deprecation warning for now. Will contact mathworks to
% find a solution soon.
warning('off', 'MATLAB:MKDIR:DirectoryExists')
	genPCode(pwd);
	function genPCode(directory)
		targetPath = strrep(directory, 'Source', 'Release');
		%% Main Directory
		mFiles = dir([directory filesep '*.m']);
		if ~isempty(mFiles);
			names = {mFiles.name};
			i = 0;
			while i < length(names)
				i = i + 1;
				if (strcmp(names{i}, 'Compile.m'))
					names(i) = [];
				end
			end
			for i = 1:1:length(names)
				pcode([directory filesep names{i}], '-inplace');
			end
			moveFiles(directory, targetPath);
		end
		%% Sub Directories
		subDir = getDirectories(directory);
		for i = 1:1:length(subDir)
			subDirectory = [directory filesep subDir(i).name];
			genPCode(subDirectory);
		end
	end
	
	function moveFiles(fromLocation, toLocation)
		pFiles = dir([fromLocation filesep '*.p']);
		names = {pFiles.name};
		for i = 1:1:length(names)
			mkdir(toLocation);
			movefile([fromLocation filesep names{i}], toLocation);
		end
	end
	
	function directories = getDirectories(directory)
		directories = struct([]);
		count = 1;
		dirPath = dir(directory);
		for i = 1:1:length(dirPath)
			if (dirPath(i).isdir)
				if strcmp(dirPath(i).name,'.')
				elseif strcmp(dirPath(i).name,'..')
				elseif strcmp(dirPath(i).name,'.git')
				else
					directories(count).name = dirPath(i).name;
					count = count+1;
				end
			end
		end
	end

end