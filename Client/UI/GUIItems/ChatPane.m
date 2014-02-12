classdef ChatPane < TabPanel
	%ChatPane Create a tab pane for chat
	
	properties (Hidden)
		Tabs;
	end
	
	methods
		%% Constructor
		function C = ChatPane(Parent, Position)
			% Initialize with MATLAB
			C = C@TabPanel(Parent, Position);
			set(C.JavaTabPane, 'StateChangedCallback', @C.tabChanged);
		end
		
		%% Print a message to the chat window. Each line should be separate indexes in the message array
		function printText(this, chatName, message)
			for i = 1:1:length(this.Tabs)
				if (length(this.Tabs{i}.Name) == length(chatName))
					if (this.Tabs{i}.Name == chatName)
						% Print message
						this.Panes{i}.print(message);
						if (this.getCurrentTabIndex() + 1 ~= i)
							this.Tabs{i}.alert();
						end
					end
				end
			end
		end
		
		%% Used to alert the user of a new message
% 		function alert(this, name)
% 			for i = 1:1:length(this.Tabs)
% 				if (length(this.Tabs{i}.Name) == length(name))
% 					if (this.Tabs{i}.Name == name)
% 						this.Tabs{i}.alert();
% 					end
% 				end
% 			end
% 		end

%% Tab related (tab objects)
		function addTab(this, tabName)
			index = this.JavaTabPane.getTabCount() + 1;
			
			this.Tabs{index} = Tab(tabName, @this.removeTab);
			this.Panes{index} = TextPane();
			
			this.JavaTabPane.addTab([], this.Panes{index}.getPane());
			this.JavaTabPane.setTabComponentAt(index - 1, this.Tabs{index}.getTab().getPane());
		end
		
		%% Callback
		function removeTab(this, tab)
			i = 1;
			while (i <= length(this.Tabs))
				if (this.Tabs{i} == tab)
					this.JavaTabPane.remove(i-1);
					this.Tabs(i) = [];
					delete(this.Panes{i});
					this.Panes(i) = [];
				else
					i = i + 1;
				end
			end
			delete(tab);
		end
		
		%% Callback
		function tabChanged(this, src, event)
			if (~(this.JavaTabPane.getSelectedIndex() == -1))
				this.Tabs{this.JavaTabPane.getSelectedIndex() + 1}.hideAlert();
			end
		end
		
		%% Cleanup
		function delete(this)
			for i = 1:1:length(this.Tabs)
				delete(this.Tabs{i})
			end
		end
	end
	
end