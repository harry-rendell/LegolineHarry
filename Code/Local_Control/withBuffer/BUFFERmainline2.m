addpath RWTHMindstormsNXT;

fstatus = memmapfile('status.txt', 'Writable', true, 'Format', 'int8');
fstatus.Data(6) = 49;
j3 = memmapfile('junction3.txt', 'Writable', true);

%open config file and save variable names and values column 1 and 2
%respectively.
config = fopen('config.txt','rt');
out = textscan(config, '%s %s');
fclose(config);

power = str2double(out{2}(strcmp('SPEED_M',out{1})));
M2addr = char(out{2}(strcmp('Main2',out{1})));

nxtM2 = COM_OpenNXTEx('USB', M2addr);

OpenLight(SENSOR_1, 'ACTIVE', nxtM2);
OpenLight(SENSOR_2, 'ACTIVE', nxtM2);





mainline = NXTMotor(MOTOR_A,'Power',-power,'SpeedRegulation',false);
fstatus.Data(6) = 50;
disp('MAINLINE 2');
disp('waiting for ready signal');
while fstatus.Data(1) == 48
    pause(0.1);
end

ambientLight2 = GetLight(SENSOR_1, nxtM2);
mainline.SendToNXT(nxtM2);

clearPalletM = [timer('TimerFcn', 'j3.Data(1) = j3.Data(1) - 1', 'StartDelay', 3.8);
                timer('TimerFcn', 'j3.Data(1) = j3.Data(1) - 1', 'StartDelay', 3.8);
                timer('TimerFcn', 'j3.Data(1) = j3.Data(1) - 1', 'StartDelay', 3.8);
                timer('TimerFcn', 'j3.Data(1) = j3.Data(1) - 1', 'StartDelay', 3.8);
                timer('TimerFcn', 'j3.Data(1) = j3.Data(1) - 1', 'StartDelay', 3.8);
                timer('TimerFcn', 'j3.Data(1) = j3.Data(1) - 1', 'StartDelay', 3.8);
                timer('TimerFcn', 'j3.Data(1) = j3.Data(1) - 1', 'StartDelay', 3.8);
                timer('TimerFcn', 'j3.Data(1) = j3.Data(1) - 1', 'StartDelay', 3.8);
                timer('TimerFcn', 'j3.Data(1) = j3.Data(1) - 1', 'StartDelay', 3.8);
                timer('TimerFcn', 'j3.Data(1) = j3.Data(1) - 1', 'StartDelay', 3.8);
                timer('TimerFcn', 'j3.Data(1) = j3.Data(1) - 1', 'StartDelay', 3.8);
                timer('TimerFcn', 'j3.Data(1) = j3.Data(1) - 1', 'StartDelay', 3.8);
                timer('TimerFcn', 'j3.Data(1) = j3.Data(1) - 1', 'StartDelay', 3.8);
                timer('TimerFcn', 'j3.Data(1) = j3.Data(1) - 1', 'StartDelay', 3.8);
                timer('TimerFcn', 'j3.Data(1) = j3.Data(1) - 1', 'StartDelay', 3.8);
                timer('TimerFcn', 'j3.Data(1) = j3.Data(1) - 1', 'StartDelay', 3.8);
                timer('TimerFcn', 'j3.Data(1) = j3.Data(1) - 1', 'StartDelay', 3.8)];


k=0;
while (k<6) && (fstatus.Data(1) == 49)
	while abs(GetLight(SENSOR_1, nxtM2) - ambientLight1) < 11
		pause(0.05);
	end
	j3.Data(1) = j3.Data(1) + 1;
	if waitForPalletExit(nxtM2, SENSOR_1, ambientLight1, 6) == false
		disp('Error');
	end

	waitForPalletExit(nxtM2, SENSOR_1, ambientLight1, 4);
	start(clearPalletM(k));
	k = k+1;
	disp('Main1 clear');
end

mainline.Stop('off', nxtM2);
disp('Main 2 STOPPED');
clear j3;
delete(timerfind);%Remove all timers from memory
CloseSensor(SENSOR_1, nxtM2);
CloseSensor(SENSOR_2, nxtM2);
COM_CloseNXT(nxtM2);



