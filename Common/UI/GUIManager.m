classdef GUIManager < handle
	%GUIManager A class that manages the GUI
	%   Detailed explanation goes here
	
	properties (Hidden)
		
	end
	
	properties
		Elements;
	end
	
	%% The static singleton methods
	methods (Static)
		guiManager;
	end
	
	%% The contructor (private use only!)
	methods (Access=private)
		% Use instance() instead
		function manager = GUIManager()
			manager.Elements = cell(0);
		end
	end
	
	%% The designated public contructor
	methods(Static)
		function guiManager = instance()
			persistent uniqueInstance
			if isempty(uniqueInstance)
				guiManager = GUIManager();
				uniqueInstance = guiManager;
			else
				guiManager = uniqueInstance;
			end
		end
	end
	
	methods
		%% Create a text field
		function textField = newTextField(this, Parent, Position, EnterCallback)
			textField = TextField(Parent, Position, 0, EnterCallback, @this.escape);
			this.Elements{length(this.Elements) + 1} = textField;
		end
		
		%% Create a password field
		function passwordField = newPasswordField(this, Parent, Position, EnterCallback)
			passwordField = TextField(Parent, Position, 1, EnterCallback, @this.escape);
			this.Elements{length(this.Elements) + 1} = passwordField;
		end
		
		%% Create a button
		function button = newButton(this, Parent, Position, Text, PressCallback)
			button = Button(Parent, Position, Text, PressCallback, @this.escape);
			this.Elements{length(this.Elements) + 1} = button;
		end
		
		%% Create a label
		function label = newLabel(this, Parent, Position, Text)
			label = Label(Parent, Position, Text, 12);
			this.Elements{length(this.Elements) + 1} = label;
		end
		
		%% Remove objects
		function removeItem(this, item)
			i = 1;
			while (i <= length(this.Elements))
				if (this.Elements{i} == item)
					this.Elements(i) = [];
				else
					i = i + 1;
				end
			end
			delete(item);
		end
		
	end
	
	methods (Access = private)
		%% Callback
		function escape(this, src)
			% Disable all controls
			for i = 1:1:length(this.Elements)
				this.Elements{i}.disable();
			end
			
			% Enable all controls
			for i = 1:1:length(this.Elements)
				this.Elements{i}.enable();
			end
		end
	end
	
end

