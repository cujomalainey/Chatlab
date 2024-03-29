classdef TabPanel < GUIItem
	%TabPanel Creates a JTabbedPane Wrapper
	
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
		function addTab(this, tabName, javaPanel)
			index = this.JavaTabPane.getTabCount() + 1;
			this.Panes{index} = javaPanel;
			this.JavaTabPane.addTab(tabName, javaPanel);
		end
		
		function removeTab(this, index)
			this.JavaTabPane.remove(index-1);
			delete(this.Panes{index});
			this.Panes(index) = [];
		end
	end
	
end