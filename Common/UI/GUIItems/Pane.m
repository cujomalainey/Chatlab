classdef Pane < GUIItem
	%Pane Create a JPane Wrapper
	
	properties (SetAccess = private)
		JavaPane;
	end
	
	methods
		%% Constructor
		function P = Pane()
			P.JavaPane = javax.swing.JPanel(java.awt.FlowLayout(java.awt.FlowLayout.LEFT, 0, 0));
			P.JavaPane.setOpaque(false);
		end
		
		function P = getPane(this)
			P = this.JavaPane;
		end
		
		function add(this, Component)
			this.JavaPane.add(Component);
		end
	end
	
end