classdef TabPanel < GUIItem
	%TabPanel Creates a Java TabPane to handle multiple tabs
	
	properties (Hidden)
		JavaTabPane;
		TabPane;
		Panes;
	end
	
	methods
		%% Constructor
		function T = TabPanel(Parent, Position)
			% Initialize with MATLAB
			[T.JavaTabPane, T.TabPane] = javacomponent('javax.swing.JTabbedPane', Position, Parent);
		end
	end
	
	methods
		%% Tab related (Numbers)
		function index = getCurrentTabIndex(this)
			index = this.JavaTabPane.getSelectedIndex();
		end
		
		%% Tab related (tab objects)
		function addTab(this, tabName, panel)
			index = this.JavaTabPane.getTabCount() + 1;
			this.Panes{index} = panel;
			this.JavaTabPane.addTab(tabName, panel);
		end
		
		function removeTab(this, index)
			this.JavaTabPane.remove(index-1);
			delete(this.Panes{index});
			this.Panes(index) = [];
		end
		
		%% Cleanup
		function delete(this)
			for i = 1:1:length(this.Panes)
				delete(this.Panes{i})
			end
		end
	end
	
end