classdef Label < GUIItem
	%Label Create a label to show text
	
	properties (Hidden)
		ControlLabel;
	end
	
% 	handles.text_LabelPassword = uicontrol('Parent',handles.figure1, ...
%     'Tag', 'text_LabelPassword', ...
%     'Style','Text', ...
%     'Units','Pixels',...
%     'Position',[PositionLeft 33+OffsetBottom BoxWidth 16], ...
%     'FontSize',10, ...
%     'String','Password:',...
%     'HorizontalAlignment', 'Left');
	
	methods
		%% Constructor
		function L = Label(Parent, Position, Text, FontSize)
			L.ControlLabel = uicontrol('Parent', Parent,...
										'Style', 'Text',...
										'Units', 'Pixels',...
										'Position', Position,...
										'Background', [0.8, 0.8, 0.8],...
										'FontSize', FontSize,...
										'String', Text...
										);
		end
		
		function setText(this, Text)
			set(this.ControlLabel, 'String', Text);
		end
		
		function setAlignment(this, Alignment) % left | {center} | right
			set(this.ControlLabel, 'HorizontalAlignment', Alignment);
		end
		
		%% Enable/Disable (TO avoid errors)
		function disable(this)
		end
		
		function enable(this)
		end
		
		%% Cleanup
		function delete(this)
			delete(this.ControlLabel);
		end
	end
	
end

