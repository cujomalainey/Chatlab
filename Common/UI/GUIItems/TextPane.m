classdef TextPane < GUIItem
	%TEXTPANE Create a text pane (includes a scroll pane)
	
	properties (SetAccess = private)
		JavaTextPane;
		JavaScrollPane;
	end
	
	methods
		%% Contructor
		function TP = TextPane()
			% Create the text pane
			TP.JavaTextPane = javax.swing.JTextPane();
			TP.JavaTextPane.setEditable(false);
			TP.JavaTextPane.setMargin([]);
			% Create the scroll pane
			TP.JavaScrollPane = javax.swing.JScrollPane();
			TP.JavaScrollPane.setViewportView(TP.JavaTextPane);
		end
		
		function P = getPane(this)
			P = this.JavaScrollPane;
		end
		
		%% Print a message to the window
		function print(this, message)
			if isempty(char(this.JavaTextPane.getText()))
				this.JavaTextPane.setText(sprintf('%s', char(this.JavaTextPane.getText()), message));
			else
				this.JavaTextPane.setText(sprintf('%s\n%s', char(this.JavaTextPane.getText()), message));
			end
		end
		
		function clear(this)
			this.JavaTextPane.setText('');
		end
		
		%% Destructor
		function delete(this)
			this.JavaTextPane.setText('');
		end
	end
	
end