function serverTest()
	
	hostName	= 'localhost';
	port		= int32(10101);
	server		= bindServer(hostName, port, @receive, @accept);
	
	channel = connect('localhost', port, @receive);
	sendMessage(channel, 'Hello');
	
	function accept(id, socket)
		disp('Accept:');
		disp(socket);
	end
	
	function receive(id, string)
		disp('Receive:');
		disp(char(string));
	end
	
end