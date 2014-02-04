function out = get_config(caseString)
	out = [];
	switch lower(caseString)
		case 'db'
			out.user = 'root';
			out.host = 'localhost';
			out.password = '';
			out.db = 'matlab';
		case 'process'
			out.max_threads = 1;
			out.max_inputbuffer = 30000;
    end
end