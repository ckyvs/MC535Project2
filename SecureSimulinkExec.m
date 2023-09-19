%% Calling simulink model and security

clc
clear all




Gain = 1000;
InitSpeed = 21.2;
decelLim = -100;

[A,B,C,D,Kess, Kr, Ke, uD] = designControl(secureRand(),Gain);
open_system('LaneMaintainSystem.slx')

set_param('LaneMaintainSystem/VehicleKinematics/Saturation','LowerLimit',num2str(decelLim))
set_param('LaneMaintainSystem/VehicleKinematics/vx','InitialCondition',num2str(InitSpeed))

simModel = sim('LaneMaintainSystem.slx');



