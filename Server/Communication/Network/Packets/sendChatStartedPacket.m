function [success] = sendChatStartedPacket(channel, name, id, joining, key)
%sendChatStartedPacket Tell the client the chat was started
	packet = struct(	'Type', 'StartedChat',...
						'Joining', joining,...
						'Name', name,...
						'ID', id...
						);
	success = sendMessage(channel, packet, key);
end