classdef ListBox < GUIItem
	%LISTBOX Create a JList
	
	properties (Hidden)
		JavaList;
		JavaScrollPane;
		ControlScrollPane;
	end
	
	methods
		%% Constructor
		function LB = ListBox(Parent, Position, Callback)
			% Set some new Look and Feel Defaults
			javax.swing.UIManager.put('List.focusCellHighlightBorder', javax.swing.BorderFactory.createEmptyBorder(0, 1, 0, 0));
			% Create the JList
			LB.JavaList = javax.swing.JList();
			LB.JavaList.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
			LB.JavaList.setSelectedIndex(-1);
			set(LB.JavaList, 'MouseReleasedCallback', Callback);
			% Create the scroll pane
			LB.JavaScrollPane = javax.swing.JScrollPane();
			[LB.JavaScrollPane, LB.ControlScrollPane] = javacomponent(LB.JavaScrollPane, Position, Parent);
			LB.JavaScrollPane.setViewportView(LB.JavaList);
		end
		
		function setData(this, data)
			if (~isempty(data))
				this.JavaList.setListData(data);
			else
% 				model = this.JavaList.getModel();
% 				model.removeAllElements();
				this.JavaList.setModel(javax.swing.DefaultListModel());
% 				this.JavaList.setListData(javaArray('java.lang.Object', 1));
			end
		end
		
		function deselect(this)
			this.JavaList.clearSelection();
		end
		
		function i = getSelectedIndex(this)
			i = this.JavaList.getSelectedIndex();
		end
		
		function v = getSelectedValue(this)
			v = this.JavaList.getSelectedValue();
		end
		
		function selectIndexAtPosition(this, point)
			this.JavaList.setSelectedIndex(this.JavaList.locationToIndex(point));
		end
		
		%% Destructor
		function delete(this)
			delete(this.ControlScrollPane);
		end
	end
	
end

