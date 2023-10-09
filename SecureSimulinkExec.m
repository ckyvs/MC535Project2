%% Calling simulink model and security

clc
clear all




Gain = 200000;
InitSpeed = 40; 
decelLim = -200;

[A,B,C,D,Kess, Kr, Ke, uD] = designControl(secureRand(),Gain);
load_system('LaneMaintainSystem.slx')

set_param('LaneMaintainSystem/VehicleKinematics/Saturation','LowerLimit',num2str(decelLim))
set_param('LaneMaintainSystem/VehicleKinematics/vx','InitialCondition',num2str(InitSpeed))

simModel = sim('LaneMaintainSystem.slx');

disp(simModel.sx1.Data)

% figure
% plot(simModel.sx1.Time,simModel.sx1.Data)
% title('Distance from the car')
% 
% figure
% plot(simModel.vx1.Time,simModel.vx1.Data)
% title('Velocity of the car')
% 
% 
% figure
% plot(simModel.ax1.Time,simModel.ax1.Data)
% title('Deceleration of the car')