classdef TreePane < GUIItem
	%TREEPANE Create a JTree for displaying trees
	
	properties (Hidden)
		JavaScrollPane;
		ControlScrollPane;
		JavaTree;
		DefaultNode;
		Model;
	end
	
	methods
		%% Constructor
		function T = TreePane(Parent, Position)
			T.JavaTree = javax.swing.JTree();
% 			[T.JavaTree, T.ControlTree] = javacomponent(T.JavaTree, Position, Parent);
			T.JavaTree.setRootVisible(false);
			T.DefaultNode = javax.swing.tree.DefaultMutableTreeNode('Sould not be seen');
			T.Model = javax.swing.tree.DefaultTreeModel(T.DefaultNode);
			T.JavaTree.setModel(T.Model);
			% Hide the icons
			T.JavaTree.getCellRenderer().setLeafIcon([]);
			T.JavaTree.getCellRenderer().setClosedIcon([]);
			T.JavaTree.getCellRenderer().setOpenIcon([]);
			% Create the scroll pane
			T.JavaScrollPane = javax.swing.JScrollPane();
			[T.JavaScrollPane, T.ControlScrollPane] = javacomponent(T.JavaScrollPane, Position, Parent);
			% Add the Tree to the scroll pane
			T.JavaScrollPane.setViewportView(T.JavaTree);
		end
		
		%% Destructor
		function delete(this)
			delete(this.ControlScrollPane);
		end
	end
	
end

