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
			scrollBar = this.JavaScrollPane.getVerticalScrollBar();
			shouldScroll = scrollBar.getValue() + scrollBar.getSize().getHeight() + 12 * 4 > scrollBar.getMaximum();
			
			strings = strsplit(message, sprintf('\n'));
			for i = 1:1:length(strings)
				if isempty(char(this.JavaTextPane.getText()))
					str = java.lang.String(sprintf('%s', char(strings(i))));
					this.JavaTextPane.setText(str);
				else
					str = java.lang.String(sprintf('%s\n%s', char(this.JavaTextPane.getText()), char(strings(i))));
					this.JavaTextPane.setText(str);
				end
				
				if (shouldScroll)
					pause(0.01);
					scrollBar.setValue(2147483647);
				end
			end
			
% 			%% TODO GET CURRENT TIME AND ADD TO THE MESSAGE
% 			if isempty(char(this.JavaTextPane.getText()))
% 				str = java.lang.String(sprintf('%s', message));
% 				this.JavaTextPane.setText(str);
% 			else
% 				str = java.lang.String(sprintf('%s\n%s', char(this.JavaTextPane.getText()), message));
% 				this.JavaTextPane.setText(str);
% 			end
% 			
% 			if (shouldScroll)
% 				pause(0.1);
% 				scrollBar.setValue(2147483647);
% 			end
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