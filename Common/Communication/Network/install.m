function install()
%install Installs the Java bits
	%% Get the file to add
	path = fileparts(mfilename('fullpath'));
	javaaddpath(fullfile(path, 'ClassPathHacker.jar'));
	filename = fullfile(path, 'Communication.jar');
	ca.Skrundz.ClassPathHacker.ClassPathHacker.addFile(filename);
end