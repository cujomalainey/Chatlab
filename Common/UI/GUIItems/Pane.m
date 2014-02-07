classdef Pane < GUIItem
	%PANE Create a Java pane
	
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
		
		function pane = getJavaPane(this)
			pane = this.JavaPane;
		end
		
		%% Destuctor
		function delete(~)
		end
	end
	
end