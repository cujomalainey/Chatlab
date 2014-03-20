ChatLab
=======
ChatLab is a Client/Server encrypted chat system for communications between clients via a server using encryption based on RSA.  Tbe goal of this project is to allow secure communication between clients without the server being able to decryp the message.  To accomplish this, we used one layer of encryption between the clients and the server, and then a second layer of encryption between the clients in a chat room.  This implementation in MATLAB is a proof of concept, and should not be taken as absolutely secure due to MATLAB's limitation with working with large numbers (the encryption isn't as strong as the standard).

##Running ChatLab From The Source
1. Obtain a copy of the software
2. Open either `LaunchClient.m` or `LaunchServer.m` in MATLAB and run it.
3. Select "Move to folder" when the popup appears

##Running ChatLab From The Release
1. Obtain a copy of the software
2. Go to the `Release` folder
3. Run either `LaunchClient.p` or `LaunchServer.p` in MATLAB.

##License - MIT
	Copyright (c) 2014 David Skrundz, Curtis Malainey

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.