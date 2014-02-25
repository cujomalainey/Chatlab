function [channel] = bindServer(port)
%bindServer Create a socket on a port at the local address
% 	channel = connect(char(java.net.InetAddress.getLocalHost().getHostAddress()), port, 1);
	channel = connect('localhost', port, 1);
end