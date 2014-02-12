function [ window ] = NewWindow( Name, Width, Height, CloseCallback )
%New Window Create and return a new window object
	%% Create the login window - Centered on the screen
	set(0,'Units','pixels')
	Screen = get(0,'ScreenSize');
	POSITION = [(Screen(3) - Width) / 2, (Screen(4) - Height) / 2, Width, Height];
	window = figure(	'Name', Name,...
						'Color', [0.93, 0.93, 0.93],...
						'NumberTitle', 'off',...
						'Toolbar', 'none',...
						'MenuBar', 'none',...
						'Units', 'pixels',...
						'OuterPosition', POSITION,...
						'Renderer', 'OpenGL',...
						'BusyAction', 'cancel',...
						'Resize', 'off',...
						'CloseRequestFcn', CloseCallback...
						);
end