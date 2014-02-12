MATLAB-Chat
===========
MATLAB-Chat is a Client/Server encrypted chat system for communications between clients via a server.  The messages are encrypted before leaving the client, passed though the server, then finally decrypted by the receiving clients.  The messages CANNOT be decrypted by the server as it does not store nor know the keys for encryption.

##Running MATLAB-Chat
1. Obtain a copy of the scripts
2. Copy the ENTIRE MATLAB-Chat folder to the MATLAB directory or navigate to it from within MATLAB
3. From MATLAB, run either `LaunchClient.m` or `LaunchServer.m`. Its that easy!
	OR
1. Obtain a copy of the scripts
2. Drag the LaunchClient.m or LaunchServer.m file into the MATLAB Editor and run it.  Select "Move to folder" when the popup appears.