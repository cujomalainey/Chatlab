classdef Button < GUIItem
	%Button Creates a custom button
	
	properties (Hidden)
		JavaButton;
		ControlButton;
		PressCallback;
	end
	
	methods
		%% Constructor
		function B = Button(Parent, Position, Text, PressCallback)
			% Initialize the JButton withing MATLAB
			[B.JavaButton, B.ControlButton] = javacomponent('javax.swing.JButton', Position, Parent);
			
			B.PressCallback = PressCallback;
			
			set(B.JavaButton,...
					'Text', Text,...
					'Opaque', false,...
					'MouseClickedCallback', @B.click...
					);
			B.JavaButton.setFocusable(false);
		end
		
		function setText(this, text)
			this.JavaButton.setText(text);
		end
	end
	
	methods (Access = private)
		%% Callbacks
		function click(this, ~, ~)
			this.PressCallback(this);
		end
	end
	
	methods
		%% Enable/Disable
		function disable(this)
			this.JavaButton.setEnabled(false);
		end
		
		function enable(this)
			this.JavaButton.setEnabled(true);
		end
		
		%% Cleanup
		function delete(this)
			delete(this.JavaButton);
		end
	end
	
end