classdef GUIManager < handle
	%GUIManager Manages Many Different GUIItem Subclasses
	
	properties (Hidden)
		Elements;
	end
	
	%% The Designated Public Contructor
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
		%% Create A label
		function label = newLabel(this, Parent, Position, Text, Managed)
			label = Label(Parent, Position, Text, 12);
			if (Managed)
				this.Elements{length(this.Elements) + 1} = label;
			end
		end
		
		%% Create A text field
		function textField = newTextField(this, Parent, Position, EnterCallback, Managed)
			textField = TextField(Parent, Position, 0, EnterCallback, @this.escape);
			if (Managed)
				this.Elements{length(this.Elements) + 1} = textField;
			end
		end
		
		%% Create A password field
		function passwordField = newPasswordField(this, Parent, Position, EnterCallback, Managed)
			passwordField = TextField(Parent, Position, 1, EnterCallback, @this.escape);
			if (Managed)
				this.Elements{length(this.Elements) + 1} = passwordField;
			end
		end
		
		%% Create A button
		function button = newButton(this, Parent, Position, Text, PressCallback, Managed)
			button = Button(Parent, Position, Text, PressCallback);%, @this.escape);
			if (Managed)
				this.Elements{length(this.Elements) + 1} = button;
			end
		end
		
		%% Create A Pane
		function pane = newPane(this, Managed)
			pane = Pane();
			if (Managed)
				this.Elements{length(this.Elements) + 1} = pane;
			end
		end
		
		%% Create A Panel
		function panel = newPanel(this, Parent, Position, Title, Managed)
			panel = Panel(Parent, Position, Title, 12);
			if (Managed)
				this.Elements{length(this.Elements) + 1} = panel;
			end
		end
		
		%% Create A TextPane
		function textPane = newTextPane(this, Managed)
			textPane = TextPane();
			if (Managed)
				this.Elements{length(this.Elements) + 1} = textPane;
			end
		end
		
		%% Create A TabPanel
		function tabPanel = newTabPanel(this, Parent, Position, Managed)
			tabPanel = TabPanel(Parent, Position);
			if (Managed)
				this.Elements{length(this.Elements) + 1} = tabPanel;
			end
		end
		
		%% Create A ListBox
		function listbox = newListBox(this, Parent, Position, Callback,  Managed)
			listbox = ListBox(Parent, Position, Callback);
			if (Managed)
				this.Elements{length(this.Elements) + 1} = listbox;
			end
		end
		
		%% Remove Objects
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
		
		function disableAll(this)
			for i = 1:1:length(this.Elements)
				this.Elements{i}.disable();
			end
		end
		
		function enableAll(this)
			for i = 1:1:length(this.Elements)
				this.Elements{i}.enable();
			end
		end
		
	end
	
	methods (Access = private)
		%% Callback
		function escape(this, ~)
			% Disable all controls
			this.disableAll();
			% Enable all controls
			this.enableAll();
		end
	end
	
end