function [] = LaunchServer()
%LaunchServer Start the server process
	AddPath('Server');
	AddPath('Common');
	ClearPath();
	main_server();
end


% x=[];
% num=17;
% for i=1:1:32
% 	x(end+1)=mod(3^i, num);
% 	hist(x,num-1);
% 	pause(0.1);
% end
% 
% x=[];
% num=7;
% for i=1:1:30
% 	x(end+1)=mod(3^i, num);
% 	hist(x,num-1);
% 	pause(0.1);
% end

% fails = 0;
% for i=1:1:1000
% 	a = KeyManager();
% 	b = KeyManager();
% 	ka = a.buildKey(1);
% 	kb = b.finishKey(ka, 1);
% 	while strcmp(kb, '-1')
% 		kb = b.finishKey(ka, 1);
% 	end
% 	a.addKey(kb, 1);
% 	ka2 = a.getKey(1);
% 	kb2 = b.getKey(1);
% 	match = ka2 == kb2;
% 	if match
% 	else
% 		fails = fails+1;
% 	end
% end
% disp(fails);