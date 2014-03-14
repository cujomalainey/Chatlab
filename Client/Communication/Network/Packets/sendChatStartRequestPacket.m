function [success] = sendChatStartRequestPacket(channel, username, key)
%sendChatStartRequestPacket Request The Server To Create A Chat Room And To Invite The User
packet = struct('Type', 'StartChat',...
	'Username', username...
	);
success = sendMessage(channel, packet, key);
end