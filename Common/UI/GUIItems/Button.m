classdef Button < GUIItem
	%Button Creates a custom button
	
	properties (Hidden)
		JavaButton;
		ControlButton;
		PressCallback;
		EscapeCallback;
	end
	
	methods
		%% Constructor
		function B = Button(Parent, Position, Text, PressCallback)%, EscapeCallback)
			% Initialize the JButton withing MATLAB
			[B.JavaButton, B.ControlButton] = javacomponent('javax.swing.JButton', Position, Parent);
			
			B.PressCallback = PressCallback;
% 			B.EscapeCallback = EscapeCallback;
			
			set(B.JavaButton,...
					'Text', Text,...
					'Opaque', false,...
					'MouseClickedCallback', @B.click...
					...'KeyPressedCallback', @B.keyPress...
					);
			B.JavaButton.setFocusable(false);
		end
		
		function setText(this, text)
			this.JavaButton.setText(text);
		end
		
% 		function b = javaButton(this)
% 			b = this.JavaButton;
% 		end
		
% 		function b = matlabButton(this)
% 			b = this.ControlButton;
% 		end
	end
	
	methods (Access = private)
		%% Callbacks
		function click(this, ~, ~) % First argument is 'this'
% 			this.disable();
% 			this.enable();
			this.PressCallback(this);
		end
		
% 		function keyPress(this, src, event)
% 			switch event.getKeyCode
% 				case 10
% 					this.disable();
% 					this.enable();
% 					this.PressCallback(this);
% 				case 27
% 					this.EscapeCallback(this);
% 			end
% 		end
	end
	
	methods
		%% Enable/Disable
% 		function disable(this)
% 			this.JavaButton.setFocusable(false);
% 		end
		
% 		function enable(this)
% 			this.JavaButton.setFocusable(true);
% 		end
		
		%% Cleanup
		function delete(this)
			delete(this.JavaButton);
		end
	end
	
end