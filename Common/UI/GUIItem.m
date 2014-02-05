classdef GUIItem < handle
	%GUIItem Superclass of all GUI items that the GUIManager will deal with
	
	properties (SetAccess = private)
		% These have setters/getters
		Tag;			% The tag of this text field
	end
	
	methods
	end
	
	methods
		%% Tag
		function [t] = tag(this)
			t = this.Tag;
		end
		
		function setTag(this, tag)
			this.Tag = tag;
		end
		
		%% Enable/Disable
		function disable(~)
		end
		
		function enable(~)
		end
	end
	
end

