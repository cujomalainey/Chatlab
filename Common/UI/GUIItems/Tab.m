classdef Tab < GUIItem
	%Tab The top tab bit for a tab pane
	
	properties (SetAccess = private)
		Pane;
		Label;
		Button;
		Callback;
	end
	
	methods
		%% Constructor
		function T = Tab(Text, ClickCallback)
			T.Callback = ClickCallback;
			
			% Create the pane
			T.Pane = GUIManager.instance().newPane(0);
			
			% Create the label
			T.Label = javax.swing.JLabel(Text);
			T.Pane.add(T.Label);
			T.Label.setBorder(javax.swing.BorderFactory.createEmptyBorder(1, 0, 0, 5));
			
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
			
			%%
			% Hide the deprecated warning for now. Will contact mathworks to
			% find a solution soon.
			warning('off', 'MATLAB:hg:PossibleDeprecatedJavaSetHGProperty')
			set(T.Button,	'MouseEnteredCallback', @T.mouseOver,...
							'MouseExitedCallback', @T.mouseOut,...
							'MouseClickedCallback', @T.click...
							);
			%%
		end
		
		function tab = getTab(this)
			tab = this.Pane;
		end
		
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