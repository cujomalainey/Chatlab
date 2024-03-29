function [channel] = BindServer(host, port, receiveCallback, acceptCallback)
%BindServer Create A ServerSocket And Bind It To A Port
try
	%% Create the address
	address = java.net.InetSocketAddress(host, port);
	%% Create The Channel
	channel = java.nio.channels.ServerSocketChannel.open();
	channel.configureBlocking(false);
	%% Get the socket
	socket = channel.socket();
	socket.setReceiveBufferSize(1024*1024*2);
	socket.setReuseAddress(true);
	%% Connect to the host
	socket.bind(address);
	%% Register so it can run in the background
	socketManager = ca.Skrundz.Communications.SocketManager.init();
	set(socketManager, 'AcceptConnectionCallback', acceptCallback);
	set(socketManager, 'ReceiveMessageCallback', receiveCallback);
	socketManager.register(channel);
catch e
	try
		channel.close();
	catch
	end
	rethrow(e);
end
end