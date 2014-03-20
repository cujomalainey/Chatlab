classdef ChatPane < TabPanel
	%ChatPane A TabPane Container Used In The Client For The Chat
	
	properties (Hidden)
		Tabs;
		TabRemovedCallback;
	end
	
	methods
		%% Constructor
		function C = ChatPane(Parent, Position, TabRemoveCB)
			% Initialize with MATLAB
			C = C@TabPanel(Parent, Position);
			set(C.JavaTabPane, 'StateChangedCallback', @C.tabChanged);
			C.TabRemovedCallback = TabRemoveCB;
		end
		
		%% Print a message to the chat window. Each line should be separate indexes in the message array
		function printText(this, chatName, message)
			for i = 1:1:length(this.Tabs)
				if (strcmp(chatName, this.Tabs{i}.Name))
					this.Panes{i}.print(message);
					if (this.getCurrentTabIndex() + 1 ~= i)
						this.Tabs{i}.alert();
					end
				end
			end
		end
		
		function clearTextByID(this, id)
			for i = 1:1:length(this.Tabs)
				if (this.Tabs{i}.ID == id)
					this.Panes{i}.clear();
				end
			end
		end
		
		function printTextByID(this, id, message)
			for i = 1:1:length(this.Tabs)
				if (id == this.Tabs{i}.ID)
					this.Panes{i}.print(message);
					if (this.getCurrentTabIndex() + 1 ~= i)
						this.Tabs{i}.alert();
					end
				end
			end
		end
		
		%% Tab related (tab objects)
		function addTab(this, tabName, tabID)
			index = this.JavaTabPane.getTabCount() + 1;
			
			this.Tabs{index} = Tab(tabName, tabID, @this.removeTab);
			this.Panes{index} = TextPane();
			
			this.JavaTabPane.addTab([], this.Panes{index}.getPane());
			this.JavaTabPane.setTabComponentAt(index - 1, this.Tabs{index}.getTab().getPane());
		end
		
		function setSelectedTabByID(this, id)
			for i = 1:1:length(this.Tabs)
				if (id == this.Tabs{i}.getID())
					this.JavaTabPane.setSelectedIndex(i-1);
					return;
				end
			end
		end
		
		function closeTabByID(this, id)
			for i = 1:1:length(this.Tabs)
				if (id == this.Tabs{i}.getID())
					this.removeTab(this.Tabs{i});
					return;
				end
			end
		end
		
		function setTabNameByID(this, id, newName)
			for i = 1:1:length(this.Tabs)
				if (id == this.Tabs{i}.getID())
					this.Tabs{i}.setName(newName);
					return;
				end
			end
		end
		
		%% Callback
		function removeTab(this, tab)
			this.TabRemovedCallback(tab.getID());
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
		
		function id = getSelectedChatID(this)
			if (this.JavaTabPane.getSelectedIndex() > -1)
				id = this.Tabs{this.JavaTabPane.getSelectedIndex() + 1}.getID();
			else
				id = 0;
			end
		end
		
		%% Callback
		function tabChanged(this, ~, ~)
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