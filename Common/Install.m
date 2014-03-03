function Install()
%Install Installs the Java bits
	%% Get the file to add
	basePath = pwd;
	path = fullfile(basePath, 'Common/Communication/Network/Java');
% 	path = fileparts(mfilename('fullpath'));
	javaaddpath(fullfile(path, 'ClassPathHacker.jar'));
	filename = fullfile(path, 'Communication.jar');
	ca.Skrundz.ClassPathHacker.ClassPathHacker.addFile(filename);
end