function [ channel ] = connect(host, port, receiveCallback)
%connect Creates a SocketChannel and connect it to the host:port
	try
		%% Create the address
		address = java.net.InetSocketAddress(host, port);
		%% Create The Channel
		channel = java.nio.channels.SocketChannel.open();
		channel.configureBlocking(false);
		%% Get the socket
		socket = channel.socket();
		socket.setReceiveBufferSize(int32(1024*1024*2));
		socket.setSendBufferSize(int32(1024*1024*2));
		socket.setTcpNoDelay(true);
		%% Connect to the host
		channel.connect(address);
		%% Register the connection so it can run in the background
		socketManager = ca.Skrundz.Communications.SocketManager.init();
		set(socketManager, 'ReceiveMessageCallback', receiveCallback);
		socketManager.register(channel);
		%% Wait for the connection to complete (or fail)
		while ~channel.finishConnect()
			pause(0.1);
		end
	catch
		disp('failed to connect');
		try
			channel.close();
		catch
		end
		channel = [];
	end
end