function clientTest()
	
	channel = connect('localhost', int32(10090), @receive);
	
	sendMessage(channel, 'Hello');
	
	function receive(varargin)
		disp('Client Receive:');
		disp(varargin);
	end
	
end