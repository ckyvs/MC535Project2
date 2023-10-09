%% Test code in class

clc
clear all

close all

%% Conditions for rainy road
lcw_gain = 94000;
hcw_gain = 90000;

normalDecelLim = -200;
poorDecelLim = -150;


numSteps = 10;
P = [0.6 0.4; 0.85 0.15];

mc = dtmc(P);

scenario = simulate(mc,numSteps); % 2 is HCW, 1 is LCW

% disp(scenario)

for condition = 1:length(scenario)
    disp(scenario(condition))
    InitSpeed = randi([20 60], 1, 1);

    lcw_hr = normrnd(61, 14);
    lcw_rr = normrnd(17, 8);

    lcw_rt = 0.01*(lcw_hr/lcw_rr);
    
    disp(lcw_hr)
    disp(lcw_rr)
    
    hcw_hr = normrnd(92, 23);
    hcw_rr = normrnd(26, 16);

    hcw_rt = 0.01*(hcw_hr/hcw_rr);
    
    disp(hcw_hr)
    disp(hcw_rr)

end

% HilHipMethod

