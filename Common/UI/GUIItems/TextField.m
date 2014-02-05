classdef TextField < GUIItem
	%TextField Creates a custom text field
	
	properties (Hidden)
		JavaTextField;	% The actual text field
		EditField;		% The matlab representation of the text field (useless for now...)
		EnterCallback;	% The callback for the enter key
		EscapeCallback;	% The callback for the escape key
	end
	
	properties (SetAccess = private)
		% Set on creation
		isPassword;		% Is this text field a password one?
	end
	
	methods
		%% Constructor
		function TF = TextField(Parent, Position, isPassword, EnterCallback, EscapeCallback)
			% Create a java password field
			TF.isPassword = isPassword;
			if (isPassword)
				TextFieldName = 'javax.swing.JPasswordField';
			else
				TextFieldName = 'javax.swing.JTextField';
			end
			% Create the matlab objects
			
			[TF.JavaTextField, TF.EditField] = javacomponent(TextFieldName, Position, Parent);
			TF.JavaTextField.setFocusable(true);
			% Set the callback
			TF.EnterCallback = EnterCallback;
			TF.EscapeCallback = EscapeCallback;
			
			% Set the keypress callback
			set(TF.JavaTextField,...
					'KeyPressedCallback', @TF.keyPress,...
					'CaretColor', java.awt.Color(1.0,0,0)...
					);
		end
	end
	
	methods (Access = private)
		%% The callback for the text field
		function keyPress(this, src, event) % First argument is 'this'
			switch event.getKeyCode
				case 10
					if (isa(this.EnterCallback, 'function_handle'))
						this.EnterCallback(this);
					end
				case 27
					if (isa(this.EscapeCallback, 'function_handle'))
						this.EscapeCallback(this);
					end
			end
		end
	end
	
	methods
		%% Enable/Disable
		function disable(this)
			this.JavaTextField.setFocusable(false);
		end
		
		function enable(this)
			this.JavaTextField.setFocusable(true);
		end
		
		%% Text
		function [text] = getText(this)
			if (this.isPassword)
				text = (this.JavaTextField.getPassword())';
			else
				text = char(this.JavaTextField.getText());
			end
		end
		
		%% Manipulate Java Element
		function setFocus(this)
			this.JavaTextField.requestFocus();
		end
		
		%% Cleanup
		function delete(this)
			delete(this.JavaTextField);
% 			delete(this.EditField);
% 			delete(this.EnterCallback);
% 			delete(this.EscapeCallback);
		end
	end
	
end