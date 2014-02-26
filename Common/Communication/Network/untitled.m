% path = fileparts(mfilename('fullpath'));
% javaaddpath(fullfile(path, 'communication.jar'));
javaclasspath(javaclasspath, 'Communication.jar')


channel(1) = connect('localhost', int32(8888), @receiveCallback);

b = JString.encode('hello'); % Returns a byte[]
% s = JString.decode(b); % Returns 'hello'