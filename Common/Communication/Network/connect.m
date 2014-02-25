function [ channel ] = connect(host, port, server)
%connect Creates a SocketChannel and connect it to the host:port
	try
		%% Create the address
		address = java.net.InetSocketAddress(host, port);
		%% Create The Channel
		channel = java.nio.channels.SocketChannel.open();
		channel.configureBlocking(false);
		%% Get the socket
		socket = channel.socket();
		socket.setReceiveBufferSize(1024*1024*2);
		socket.setSendBufferSize(1024*1024*2);
		socket.setTcpNoDelay(true);
		%% Connect to the host
		if (server)
			channel.bind(address);
		else
			channel.connect(address);
		end
		% Not sure what this does...
		while ~channel.finishConnect()
			pause(0.1);
		end
	catch
		try
			channel.close();
		catch
		end
	end
end