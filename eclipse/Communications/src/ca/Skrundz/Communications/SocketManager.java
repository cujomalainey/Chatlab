package ca.Skrundz.Communications;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.ByteBuffer;
import java.nio.channels.CancelledKeyException;
import java.nio.channels.ClosedChannelException;
import java.nio.channels.ClosedSelectorException;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map.Entry;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

// This file is adapted from an example of network communications in MATLAB
// Thanks to Jude Collins for this amazing example!

/* *Original*

Copyright (c) 2012, Jude Collins
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in
      the documentation and/or other materials provided with the distribution

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
*/

public class SocketManager extends Thread {
	
	private static ConcurrentHashMap<String, SocketManager> socketManagers = new ConcurrentHashMap<String, SocketManager>();
	
	//====================================================================
	// MATLAB Event callback
	//====================================================================
	private java.util.Vector<SocketListener> eventListeners	= new java.util.Vector<SocketListener>(4,1);
	
	public synchronized void addListener(SocketListener lis) {
		eventListeners.addElement(lis);
	}
	
	public synchronized void removeListener(SocketListener lis) {
		eventListeners.removeElement(lis);
	}
	
	public interface SocketListener extends java.util.EventListener {
		void receiveMessage(MessageEvent event);
		void acceptConnection(SocketChannel channel);
		void disconnected(SocketChannel channel);
	}
	
	public class MessageEvent extends java.util.EventObject {
		private static final long serialVersionUID = 1L;
		public SocketChannel channel = null;
		public String message = null;

		public MessageEvent(Object source, SocketChannel channel, byte[] data) {
			super(source);
			this.channel = channel;
			this.message = new String(data);
		}
	}
	// End ================================================================
	
	public static class UniqueInt {
		private static int id	= 0;
		public static int get() {
			id = (id == Integer.MAX_VALUE) ? 1 : id+1;
			return id;
		}
	}
	
	private Selector selector = null;
	
	private boolean shutdown = false;
	
	private HashMap<SocketChannel,ByteBuffer> buffers = new HashMap<SocketChannel,ByteBuffer>(8);
	private List<RegisterRequest> registerRequests = new LinkedList<RegisterRequest>();
	
	public static SocketManager init() {
		String name = String.valueOf(UniqueInt.get());
		SocketManager manager = new SocketManager(name);
		manager.start();
		// Make sure we don't lose a reference
		socketManagers.put(name, manager);
		return manager;
	}
	
	public static void closeAll() {
		for (Entry<String, SocketManager> entry : socketManagers.entrySet()) {
			entry.getValue().close();
		}
	}
	
	private SocketManager(String name) {
		super(name);
		try {
			selector = Selector.open();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	private void fireAcceptEvent(SocketChannel channel) {
		for (SocketListener listener : eventListeners) {
			if (listener != null) {
				listener.acceptConnection(channel);
			}
		}
	}
	
	private void fireReceiveEvent(SocketChannel channel, byte[] data) {
		for (SocketListener listener : eventListeners) {
			if (listener != null) {
				listener.receiveMessage(new MessageEvent(this, channel, data));
			}
		}
	}
	
	private void fireDisconnectEvent(SocketChannel channel) {
		for (SocketListener listener : eventListeners) {
			if (listener != null) {
				listener.disconnected(channel);
			}
		}
	}
	
	public void run() {
		try {
			while (true) {
				// Select the next channel
				selector.select();
				
				if(shutdown == true) {
					break;
				}
				
				try {
					//  Get set of ready objects, those objects that are ready to have occur one of the operations that we flagged (OP_READ, OP_ACCEPT, etc...)
					Set<SelectionKey> readyKeys = selector.selectedKeys();
					Iterator<SelectionKey> readyItor = readyKeys.iterator();
					
					while(readyItor.hasNext()) {
						// Get the key and remove it
						SelectionKey key = (SelectionKey)readyItor.next();
						readyItor.remove();
						
						// Sanity Check
						if(!key.isValid()) continue;
						
						//==============================
						// OP_READ
						//==============================
						if(key.isReadable()) {
							
							// Get the channel and read in the data
							SocketChannel keyChannel = (SocketChannel)key.channel();
							ByteBuffer buffer = buffers.get(keyChannel);
							
							int length	= 0;
							
							try {
								length = keyChannel.read(buffer);
							} catch ( IOException ioe) {
								key.cancel();
								closeChannel(keyChannel);
							}
							
							if(length > 0) {
								buffer.flip();
								// Gather the entire message before processing
								while( buffer.remaining() > 0) {
									byte[] data = new byte[buffer.remaining()];
									buffer.get(data);
									fireReceiveEvent(keyChannel, data);
								}
								buffer.compact();
							} else if (length < 0) {
								key.cancel();
								closeChannel(keyChannel);
							}
							
						//==============================
						// OP_ACCEPT
						//==============================
						} else if (key.isAcceptable()) {
							
							// Get channel
							ServerSocketChannel keyChannel = (ServerSocketChannel)key.channel();
							// Get server socket
							ServerSocket serverSocket = keyChannel.socket();
							
							// Accept request
							Socket socket = serverSocket.accept();
							socket.setReceiveBufferSize(1024*1024*2);
							
							SocketChannel sockChannel 	= socket.getChannel();
							sockChannel.configureBlocking(false);
							sockChannel.register(selector, SelectionKey.OP_READ);
							
							register(sockChannel, selector, SelectionKey.OP_READ);
							
							fireAcceptEvent(sockChannel);
							
						}
					}
					synchronized(registerRequests) {
						while(!registerRequests.isEmpty()) {
							RegisterRequest request 	= registerRequests.remove(0);
							register(request);
						}
					}
				} catch (CancelledKeyException cke) {
					
				} catch (ClosedChannelException cce) {
					
				}
			}
		} catch (ClosedSelectorException cse) {
			
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			shutdown();
		}
	}
	
	private void closeChannel(SocketChannel channel) {
		try {
			channel.close();
		} catch (IOException e) {
			
		}
		fireDisconnectEvent(channel);
		buffers.remove(channel);
	}
	
	public void close() {
		shutdown = true;
		selector.wakeup();
	}
	
	private void shutdown() {
		try {
			selector.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		socketManagers.remove(this);
	}
	
	//====================================================
	// class RegisterRequest
	// Internal class to aid in grouping registration
	// requests and the associated options.
	//====================================================
	public class RegisterRequest{
		public Object channel;
		
		public RegisterRequest(SocketChannel channel) {
			this.channel 			= channel;
		}
		
		public RegisterRequest(ServerSocketChannel channel) {
			this.channel 		= channel;
		}
	}
	// End ==========================================================
	
	//==========================================================
	// register()
	// Private methods only to be called by the selector thread.
	//==========================================================
	private void register(RegisterRequest request) {
		if(request.channel instanceof SocketChannel) {
			SocketChannel channel = (SocketChannel) request.channel;
			register(channel, selector, SelectionKey.OP_READ );
		} else if (request.channel instanceof ServerSocketChannel) {
			ServerSocketChannel channel = (ServerSocketChannel) request.channel;
			register(channel, selector, SelectionKey.OP_ACCEPT);
		}
		
	}
	
	private void register(ServerSocketChannel channel, Selector selector, int selectionKeys) {
		try {
			channel.register(selector, selectionKeys);
		} catch (ClosedChannelException e) {
			e.printStackTrace();
		}
	}
	
	//NOTE: you can NOT register a blocking socket with a selector.  If you try 
	// to do it an IllegalBlockingModeException will be thrown.
	private void register(SocketChannel channel, Selector selector, int selectionKeys) {
		try {
			channel.configureBlocking(false);
			channel.register(selector, selectionKeys);
			buffers.put(channel, ByteBuffer.allocate(1024*1024*2));
		} catch (ClosedChannelException e) {
			e.printStackTrace();
		} catch (IOException e) {
			try {
				channel.close();
			} catch (IOException e1) {
				
			}
			e.printStackTrace();
		}
	}
	
	//==========================================================
	// register()
	// Public methods available to MATLAB.  These will queue the
	// registration request and notify the selector thread that
	// they are there.
	//==========================================================
	public void register(SocketChannel channel) {
		RegisterRequest request = new RegisterRequest(channel);
		synchronized( registerRequests ) {
			registerRequests.add(request);
		}
		//notify the selector
		selector.wakeup();
	}
	
	public void register(SocketChannel channel, int msgSizePosition ) {
		RegisterRequest request = new RegisterRequest(channel);
		synchronized( registerRequests ) {
			registerRequests.add(request);
		}
		//notify the selector
		selector.wakeup();
	}
	
	public void register(ServerSocketChannel channel) {
		RegisterRequest request = new RegisterRequest(channel);
		synchronized( registerRequests ) {
			registerRequests.add(request);
		}
		selector.wakeup();
	}
	
	public void register(ServerSocketChannel channel, boolean autoRegister) {
		RegisterRequest request = new RegisterRequest(channel);
		synchronized( registerRequests ) {
			registerRequests.add(request);
		}
		selector.wakeup();
	}
	
	public void register(ServerSocketChannel channel, int msgSizePosition) {
		RegisterRequest request = new RegisterRequest(channel);
		synchronized( registerRequests ) {
			registerRequests.add(request);
		}
		selector.wakeup();
	}
}