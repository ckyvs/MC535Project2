%% Calling simulink model and security

clc
clear all

avg_lcw_hr = 68.67;
sd_lcw_hr = 14.33;
avg_lcw_rr = 15.33;
sd_lcw_rr = 6.0;

avg_hcw_hr = 86.0;
sd_hcw_hr = 23.0;
avg_hcw_rr = 20.33;
sd_hcw_rr = 11.67;

lcw_hr_user_profile = normrnd(avg_lcw_hr, sd_lcw_hr);
lcw_rr_user_profile = normrnd(avg_lcw_rr, sd_lcw_rr);

disp(lcw_hr_user_profile)
disp(lcw_rr_user_profile)

hcw_hr_user_profile = normrnd(avg_hcw_hr, sd_hcw_hr);
hcw_rr_user_profile = normrnd(avg_hcw_rr, sd_hcw_rr);

disp(hcw_hr_user_profile)
disp(hcw_rr_user_profile)

lcw_rt = 0.01 * (lcw_hr_user_profile / lcw_rr_user_profile);
hcw_rt = 0.01 * (hcw_hr_user_profile / hcw_rr_user_profile);

Gain = 94000;
InitSpeed = 40; 
normalDecelLim = -200;
poorDecelLim = -150;

[A,B,C,D,Kess, Kr, Ke, uD] = designControl(secureRand(),Gain);
load_system('LaneMaintainSystem.slx')

set_param('LaneMaintainSystem/VehicleKinematics/Saturation','LowerLimit',num2str(poorDecelLim))

for speed = 20:40
    set_param('LaneMaintainSystem/VehicleKinematics/vx','InitialCondition',num2str(speed))
    simModel = sim('LaneMaintainSystem.slx');
    controller_stopping_dist_idx = find(simModel.sx1.Data>0,1);

    if isempty(controller_stopping_dist_idx)
        controller_stopping_dist_idx = 0;
    end

    if controller_stopping_dist_idx == 0
        fprintf("No Collision for speed %g kmph\n", speed)
    else
        fprintf("Collision for speed %g kmph\n", speed)
        decelLimit = 1.1*poorDecelLim;
        collision_time = simModel.sx1.Time(controller_stopping_dist_idx)
        user_stop_time = hcw_rt + abs((InitSpeed * 5/18) / decelLimit)

        if collision_time > user_stop_time
            fprintf("User can stop at speed %g kmph\n, switching", speed)
        else
            fprintf("Collision inevitable at speed %g kmph\n", speed)
        end
    end
end