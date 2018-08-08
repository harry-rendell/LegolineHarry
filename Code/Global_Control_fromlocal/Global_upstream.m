addpath RWTHMindstormsNXT;
%establish memory map to status.txt. 
fstatus = memmapfile('status.txt', 'Writable', true, 'Format', 'int8');
fstatus.Data(2) = 49; %initalise
wait = memmapfile('wait.txt', 'Writable', true, 'Format', 'int8');
global wait
wait.Data(1) = 48;


%open config file and save variable names and values column 1 and 2
%respectively.
config = fopen('config.txt','rt');
out = textscan(config, '%s %s');
fclose(config);

%retrieve parameters
power = str2double(out{2}(strcmp('SPEED_U',out{1})));
Uaddr = char(out{2}(strcmp('Upstream',out{1})));
Udelay = str2double(out{2}(strcmp('Udelay',out{1})));	
T_U = str2double(out{2}(strcmp('T_U',out{1})));	
Uthreshold = str2double(out{2}(strcmp('Uthreshold',out{1})));	
nxtU = COM_OpenNXTEx('USB', Uaddr);

%establish memory map to junction file
%j1 = memmapfile('Junction1.txt','Writable',true);
u1 = memmapfile('count_u1.txt', 'Writable', true, 'Format', 'int8');
u1.Data(1) = 48;

upstreampallet = 49;

OpenLight(SENSOR_2,'ACTIVE',nxtU);
OpenSwitch(SENSOR_1,nxtU);
fstatus.Data(2) = 50; %ready
disp('UPSTREAM');
disp('waiting for ready signal');
while fstatus.Data(1) == 48
    pause(0.1); %wait for ready sign
end
currentValueU = GetLight(SENSOR_2,nxtU);

upstreampallet = 49;
toc = T_U + 1;
tic;
k=0;
while (k<12) && (fstatus.Data(1) == 49)
    
	if toc > T_U
		clear toc
		tic;
		feedPallet(nxtU,SENSOR_1,MOTOR_A);
		
		addpallet(upstreampallet,'count_u1.txt')
		
		k=k+1;
        if fstatus.Data(1) ~= 49
            break
            disp('break');
        end
		movePalletPastLSupstream(MOTOR_B,power,nxtU,SENSOR_2,3,Uthreshold);
		
		addpallet(upstreampallet,'count_m1.txt')
        pause(0.3);
        removepallet('count_u1.txt')
		
	end
	pause(0.1)
end

delete(timerfind);
disp('Upstream STOPPED')
clear u1;
CloseSensor(SENSOR_1, nxtU);
CloseSensor(SENSOR_2, nxtU);
COM_CloseNXT(nxtU);
quit;