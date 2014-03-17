function [] = LaunchClient()
%LaunchClient Start The Client

%%
% Hide the deprecation warning for now. Will contact mathworks to
% find a solution soon.
warning('off', 'MATLAB:hg:PossibleDeprecatedJavaSetHGProperty')
AddPath('Client');
AddPath('Common');
ClearPath();
main_client();
end