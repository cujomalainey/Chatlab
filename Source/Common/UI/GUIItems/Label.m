classdef Label < GUIItem
	%Label Create A Label Wrapper
	
	properties (Hidden)
		ControlLabel;
	end
	
	methods
		%% Constructor
		function L = Label(Parent, Position, Text, FontSize)
			L.ControlLabel = uicontrol('Parent', Parent,...
				'Style', 'Text',...
				'Units', 'Pixels',...
				'Position', Position,...
				'Background', get(Parent, 'Color'),...
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
		
		function setColor(this, Color)
			set(this.ControlLabel, 'ForegroundColor', Color);
		end
		
		%% Cleanup
		function delete(this)
			delete(this.ControlLabel);
		end
	end
	
end