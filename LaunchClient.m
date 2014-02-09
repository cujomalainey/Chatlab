function [] = LaunchClient()
%LaunchClient Start the client process

%%
% Hide the deprecation warning for now. Will contact mathworks to
% find a solution soon.
warning('off', 'MATLAB:hg:PossibleDeprecatedJavaSetHGProperty')

	AddPath('Client');
	AddPath('Common');
	main_client();
end