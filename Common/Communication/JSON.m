classdef JSON < handle
	%JSON A JSON parser/creator that deals with strucs. Only has class methods.
	% struct = JSON.parse(jsonString) converts a JSON string to a MATLAB struct.
	% JSON Parsing is from http://www.mathworks.com/matlabcentral/fileexchange/42236-parse-json-text/content/JSON.m
	
	properties (Access = private)
		%% For parsing
		json = ''; % the string
		index = 0; % position in the string
	end
	
	%% Constructor
	methods (Access = private)
		function this = JSON(JSONstring)
			this.json = JSONstring;
			this.index = 1;
		end
	end
	
	methods (Static)
		%% Parse
		function s = parse(JSONstring)
			jsonObject = JSON(JSONstring);
            s = jsonObject.getValue;
		end
		%% Create
		function str = create(structure)
			jsonObject = JSON('');
			s = jsonObject.createJSON(structure);
			str = s(1:end - 1);
		end
	end
	
	%% Creating
	methods (Access = private)
		function string = createJSON(this, structure)
			if (~isstruct(structure))
				error('A non-structure was passed to the JSON creator')
			end
			this.addStruct('', structure);
			string = this.json;
		end
		
		function addStruct(this, name, structure)
			if (~isempty(name))
				this.json(end + 1) = '"';
				this.json = [this.json, name];
				this.json(end + 1) = '"';
				this.json(end + 1) = ':';
			end
			this.json(end + 1) = '{';
			
			names = fieldnames(structure);
			for i=1:1:length(names)
				c = class(structure.(names{i}));
				switch c
					case 'double'
						this.addNumber(names{i}, structure.(names{i}));
						continue;
					case 'char'
						this.addString(names{i}, structure.(names{i}));
						continue;
					case 'cell'
						this.addCellArray(names{i}, structure.(names{i}));
						continue;
					case 'struct'
						this.addStruct(names{i}, structure.(names{i}));
						continue;
					case 'logical'
						this.addLogical(names{i}, structure.(names{i}));
						continue;
				end
			end
			
			if (this.json(end) == ',')
				this.json(end) = '}';
			else
				this.json(end + 1) = '}';
			end
			this.json(end + 1) = ',';
		end
		
		function addNumber(this, name, number)
			if (isempty(number))
				this.addNull(name);
				return;
			end
			if (~isempty(name))
				this.json(end + 1) = '"';
				this.json = [this.json, name];
				this.json(end + 1) = '"';
				this.json(end + 1) = ':';
			end
			this.json = [this.json, num2str(number)];
			this.json(end + 1) = ',';
		end
		
		function addString(this, name, string)
			if (~isempty(name))
				this.json(end + 1) = '"';
				this.json = [this.json, name];
				this.json(end + 1) = '"';
				this.json(end + 1) = ':';
			end
			this.json(end + 1) = '"';
			this.json = [this.json, string];
			this.json(end + 1) = '"';
			this.json(end + 1) = ',';
		end
		
		function addLogical(this, name, logic)
			if (~isempty(name))
				this.json(end + 1) = '"';
				this.json = [this.json, name];
				this.json(end + 1) = '"';
				this.json(end + 1) = ':';
			end
			if (logic)
				this.json = [this.json, 'true'];
			else
				this.json = [this.json, 'false'];
			end
			this.json(end + 1) = ',';
		end
		
		function addNull(this,name)
			if (~isempty(name))
				this.json(end + 1) = '"';
				this.json = [this.json, name];
				this.json(end + 1) = '"';
				this.json(end + 1) = ':';
			end
			this.json = [this.json, 'null'];
			this.json(end + 1) = ',';
		end
		
		function addCellArray(this, name, cellarray)
			if (~isempty(name))
				this.json(end + 1) = '"';
				this.json = [this.json, name];
				this.json(end + 1) = '"';
				this.json(end + 1) = ':';
			end
			this.json(end + 1) = '[';
			
			for i=1:1:length(cellarray)
				c = class(cellarray{i});
				switch c
					case 'double'
						this.addNumber([], cellarray{i});
						continue;
					case 'char'
						this.addString([], cellarray{i});
						continue;
					case 'cell'
						this.addCellArray([], cellarray{i});
						continue;
					case 'struct'
						this.addStruct([], cellarray{i});
						continue;
					case 'logical'
						this.addLogical([], cellarray{i});
						continue;
				end
			end
			if (this.json(end) == ',')
				this.json(end) = ']';
			else
				this.json(end + 1) = ']';
			end
		end
	end
	
	%% Parsing
	methods (Access = private)
		function value = getValue(this)
			% get the next value in the string
			token = this.getNextToken;
			if token == '{'
				value = this.getObject;
			elseif token == '['
				value = this.getArray;
			else
				value = token;
			end
		end
		
		function token = getNextToken(this)
			% get whatever is next in the string
			% skip spaces
			ch = this.json(this.index);
			while isWhitespace(ch)
				this.index = this.index + 1;
				ch = this.json(this.index);
			end
			% is the character special
			if isSpecial(ch)
				token = ch;
				this.index = this.index + 1;
				return;
			end
			% it a keyword
			switch(ch)
				case 't'
					match(this,'true');
					token = true;
					return;
				case 'f'
					match(this,'false');
					token = false;
					return;
				case 'n'
					match(this,'null');
					token = [];
					return
			end
			%is it a string
			if(ch == '"')
				token = this.getString;
				return;
			end
			%it must be a number
			token = this.getNumber;
			%% Subfunctions
			function match(this,str)
				% find and consume exactly str at the current location of error
				n = length(str);
				range = this.index:(this.index + n - 1);
				found = this.json(range);
				if strcmp(str,found)
					this.index = this.index + n;
				else
					error('The JSON parser expected "%s" but found %s',str,found)
				end
			end
			
			function tf = isWhitespace(aChar)
				% space, carrage return, linefeed, horizontal tab
				tf = aChar == 32 || aChar == 10 || aChar == 13 || aChar == 9;
			end
			
			function tf = isSpecial(aChar)
				% the special characters in the JSON "language"
				tf = aChar == '{' || aChar == '}' || aChar == '['|| aChar == ']'|| aChar == ':' || aChar == ',';
			end
		end
		
		%% Returns a struct
		function obj = getObject(this)
			obj = struct();
			value = this.getValue;
			while ~strcmp(value,'}')
				fieldname = value;
				% Make sure the name is valid
				fieldname = strrep(fieldname,':','_');
				fieldname = strrep(fieldname,'-','_');
				% colon
				value = this.getValue;
				if value ~= ':'
					error('JSON parser requires colons between object names and values');
				end
				% get the actual value
				value = this.getValue;
				obj.(fieldname) = value;
				
				value = this.getValue;
				if value == ','
					value = this.getValue;
				elseif value == '}'
					continue;
				else
					error('JSON parser requires commas between object elements');
				end
			end
		end
		
		%% Returns a cell array
		function array = getArray(this)
			array = {};
			value = this.getValue;
			while ~strcmp(value,']')
				array{end+1} = value;
				value = this.getValue;
				if value == ','
					value = this.getValue;
				elseif value == ']'
					continue;
				else
					error('JSON parser requires commas between array elements');
				end
			end
			% turn number arrays to regular array
			fcn = @(x) isnumeric(x) && ~isscalar(x);
			if all(cellfun(fcn,array))
				array = [array{:}];
			end
		end
		
		%% Return a string
		function string = getString(this)
			first = this.index + 1;
			last = first;
			str = this.json;
			
			ch = str(last);
			while ch ~= '"'
				if(strcmp(ch,'\\'))
					last = last + 2;
				else 
					last = last + 1;
				end
				ch = str(last);
			end
			% get the string withou ""
			string = str(first:(last-1));
			this.index = last + 1;
		end
		
		%% Return a number
		function number = getNumber(this)
			first = this.index;
			last = first;
			ch = charAt(this,first);
			
			if(ch == '-')
				last = last + 1;
				ch = charAt(this,last);
			end
			
			while isDigit(ch)
				last = last + 1;
				ch = charAt(this,last);
			end
			
			if(ch == '.')
				last = last + 1;
				ch = charAt(this,last);
				while isDigit(ch)
					last = last + 1;
					ch = charAt(this,last);
				end
			end
			
			if ch == 'e' || ch == 'E'
				last = last + 1;
				ch = charAt(this,last);
				if ismember(ch,'+-')
					last = last + 1;
					ch = charAt(this,last);
				end
				while isDigit(ch)
					last = last + 1;
					ch = charAt(this,last);
				end
			end
			% get the string
			str = this.json(first:(last-1));
			number = str2double(str);
			
			this.index = last;
			
			% helper functions
			function char = charAt(this,position)
				if(position > length(this.json))
					char = 0;
				else
					char = this.json(position);
				end
			end
			
			function tf = isDigit(aChar)
				tf = aChar > 47 && aChar < 58;
			end
		end
	end
	
end