function serverTest()
	
	hostName	= 'localhost';
	port		= int32(10108);
	server		= bindServer(hostName, port, @receive, @accept);
	sock = [];
	
	channel = connect('localhost', port, @receive);
	sendMessage(channel, 'Hello');
	
	pause(0.1);
	
	sendMessage(sock, 'Welcome, client');
	
	function accept(id, socket)
		disp('Accept:');
		disp(socket);
		sock = socket;
	end
	
	function receive(id, channel, string)
		disp('Receive:');
		disp(char(string));
	end
	
	ca.Skrundz.Communications.SocketManager.closeAll();
	disconnect(channel);
	disconnect(server);
	
end