classdef TextPane < GUIItem
	%TextPane Create A JTextPane (Includes A JScrollPane) Wrapper
	
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
			scrollBar = this.JavaScrollPane.getVerticalScrollBar();
			shouldScroll = scrollBar.getValue() + scrollBar.getSize().getHeight() + 12 * 4 > scrollBar.getMaximum();
			
			strings = strsplit(message, sprintf('\n'));
			for i = 1:1:length(strings)
				time = clock;
				stamp = sprintf('%02.0f:%02.0f:%02.0f', time(4), time(5), time(6));
				if isempty(char(this.JavaTextPane.getText()))
					str = java.lang.String(sprintf('%s - %s', stamp, char(strings(i))));
					this.JavaTextPane.setText(str);
				else
					str = java.lang.String(sprintf('%s\n%s - %s', char(this.JavaTextPane.getText()), stamp, char(strings(i))));
					this.JavaTextPane.setText(str);
				end
				
				if (shouldScroll)
					pause(0.01);
					scrollBar.setValue(2147483647);
				end
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