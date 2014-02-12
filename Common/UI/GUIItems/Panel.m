classdef Panel < GUIItem
	%Panel Create a UIPanel
	
	properties (Hidden)
		ControlPanel;
	end
	
	methods
		%% Constructor
		function P = Panel(Parent, Position, Title, FontSize)
			P.ControlPanel = uipanel(	'Parent', Parent,...
										'Units', 'Pixels',...
										'Background', get(Parent, 'Color'),...
										'Position', Position,...
										'Title', Title,...
										'FontSize', FontSize,...
										'BorderType', 'etchedout'... none | {etchedin} | etchedout | beveledin | beveledout | line
										);
		end
		
		%% Cleanup
		function delete(this)
			delete(this.ControlPanel);
		end
	end
	
end