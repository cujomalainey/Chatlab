classdef TabPanel < GUIItem
	%TabPanel Creates a Java TabPane to handle multiple tabs
	
	properties (Hidden)
		JavaTabPane;
		TabPane;
		Tabs;
		Panes;
	end
	
	methods
		%% Constructor
		function T = TabPanel(Parent, Position)
			% Initialize with MATLAB
			[T.JavaTabPane, T.TabPane] = javacomponent('javax.swing.JTabbedPane', Position, Parent);
		end
	end
	
	methods (Access = private)
		%% Callbacks
% 		function closeTabPressed(this, src, event)
% 			
% 		end
	end
	
	methods
		%% Tab related (Numbers)
% 		function tab = getCurrentTab(this)
% 			
% 		end
% 		
% 		function setCurrentTab(this)
% 			
% 		end
		%% Tab related (tab objects)
		function addTab(this, tabName)
			index = this.JavaTabPane.getTabCount() + 1;
			
			this.Tabs{index} = Tab(tabName, @this.removeTab);
			this.Panes{index} = TextPane();
			
			this.JavaTabPane.addTab([], this.Panes{index}.getPane());
			this.JavaTabPane.setTabComponentAt(index - 1, this.Tabs{index}.getTab().getJavaPane());
		end
		
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
		
% 		function tab = getTabWindow(this)
% 			
% 		end
		
		%% Cleanup
		function delete(this)
			delete(this.JavaTabPane);
			
			for i = 1:1:length(this.Tabs)
				delete(this.Tabs{i})
			end
			
			for i = 1:1:length(this.Panes)
				delete(this.Panes{i})
			end
		end
	end
	
end