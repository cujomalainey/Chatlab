function [success] = sendChatStartedPacket(channel, name, id, joining, key)
%sendChatStartedPacket Tell The Client That They Joined A Chat Room
packet = struct('Type', 'StartedChat',...
	'Joining', joining,...
	'Name', name,...
	'ID', id...
	);
success = sendMessage(channel, packet, key);
end