classdef Tab < GUIItem
	%Tab The Tab That Displays In The ChatPane
	
	properties (SetAccess = private)
		Pane;
		Label;
		Button;
		Callback;
	end
	
	properties
		Name;
		ID;
	end
	
	methods
		%% Constructor
		function T = Tab(Text, ID, ClickCallback)
			T.Callback = ClickCallback;
			
			% Create the pane
			T.Pane = GUIManager.instance().newPane(0);
			T.Pane.getPane.setBorder(javax.swing.BorderFactory.createEmptyBorder(2, 0, 0, -3));
			
			T.Name = Text;
			T.ID = ID;
			% Create the label
			T.Label = javax.swing.JLabel([Text ' ']);
			T.Pane.add(T.Label);
			T.Label.setBorder(javax.swing.BorderFactory.createEmptyBorder(0, 0, 0, 0));
			
			% Create the button
			T.Button = javax.swing.JButton('x');
			
			T.Pane.add(T.Button);
			T.Button.setPreferredSize(java.awt.Dimension(17, 17));
			T.Button.setToolTipText('Close Chat');
			T.Button.setContentAreaFilled(false);
			T.Button.setFocusable(false);
			T.Button.setBorder(javax.swing.BorderFactory.createEtchedBorder());
			T.Button.setBorderPainted(false);
			T.Button.setForeground(java.awt.Color.red);
			
			set(T.Button,	'MouseEnteredCallback', @T.mouseOver,...
				'MouseExitedCallback', @T.mouseOut,...
				'MouseClickedCallback', @T.click...
				);
		end
		
		function tab = getTab(this)
			tab = this.Pane;
		end
		
		function alert(this)
			this.Label.setForeground(java.awt.Color.magenta);
		end
		
		function hideAlert(this)
			this.Label.setForeground(java.awt.Color.black);
		end
		
		%% Get/Set
		function setName(this, name)
			this.Name = name;
			this.Label.setText(name);
		end
		
		function name = getName(this)
			name = this.Name;
		end
		
		function id = getID(this)
			id = this.ID;
		end
		
		%% Callbacks
		function mouseOver(this, ~, ~)
			this.Button.setBorderPainted(true);
			this.Button.repaint();
		end
		
		function mouseOut(this, ~, ~)
			this.Button.setBorderPainted(false);
			this.Button.repaint();
		end
		
		function click(this, ~, ~)
			this.Callback(this);
		end
		
		function delete(this)
			delete(this.Pane)
		end
	end
	
end