clear variables;close all;clc;
%%
addpath("MATLAB")

uploading_new %% Acquisition data from folders
error_calculator %% Compute the precision errors
boxplotter_ %% Errors boxplots
%%

up = true;
while up
    choosen_letter = input("Choose a letter:\n", "s");
    comparison_letter = strcmp(choosen_letter, alf);
    if sum(comparison_letter)
        i = find(comparison_letter);
        up = false;
        IK_stretch;
    else
        clc
    end

    if strcmp(choosen_letter, "lair")
        REAL_SIMULATION_LAIR
    end

    decision = input("Do you want to try again? [Y/N]\n", "s");
    if strcmp(decision, "N") | strcmp(decision, "n")
        up = false;
    elseif strcmp(decision, "Y") | strcmp(decision, "y")
        up = true;
    end
end

%% Simulation


base = currentJointSegment(1, :);
lift = currentJointSegment(2, :);
figure("Name","Simulation"),
subplot(2,2,1)
plot(base)
title('Base Joint Variable')
ylabel('[m]')

subplot(2,2,3)

plot(lift)
title('Lift Joint Variable')
ylabel('[m]')


Arm = currentJointSegment(3:6, :);

subplot(2,2,2)

plot(Arm(1,:), 'r')
hold on
plot(Arm(2,:), 'b')
plot(Arm(3,:), 'g')
plot(Arm(4,:), 'k')

title("ARM Joint Variable")
legend('l3', 'l2', 'l1', 'l0')

wrist =  currentJointSegment(7:end, :);

subplot(2,2,4)

plot(wrist(1,:), 'r')
hold on
plot(wrist(2,:), 'b')
plot(wrist(3,:), 'g')
ylabel('[rad]')

title("wrist Joint Variable")
legend('yaw', 'pitch', 'roll')

%%

%% OFFLINE
offline=OFFLINE(i).joint_variables';

base = offline(2, :);
lift = offline(4, :);

figure("Name","OFFLINE"),
subplot(2,2,1)
plot(base)
title('Base Joint Variable')
ylabel('[m]')

subplot(2,2,3)

plot(lift)
title('Lift Joint Variable')
ylabel('[m]')


Arm = offline(6:9, :);

subplot(2,2,2)

plot(Arm(1,:), 'r',"LineWidth",2)
hold on
plot(Arm(2,:), 'b',"LineWidth",1.5)
plot(Arm(3,:), 'g',"LineWidth",1)
plot(Arm(4,:), 'k',"LineWidth",0.5)

title("ARM Joint Variable")
legend('l3', 'l2', 'l1', 'l0')
ylabel('[m]')

wrist =  offline([10, 12,13], :);

subplot(2,2,4)

plot(wrist(1,:), 'r')
hold on
plot(wrist(2,:), 'b')
plot(wrist(3,:), 'g')
ylabel('[rad]')

title("wrist Joint Variable")
legend('yaw', 'pitch', 'roll')

%% ONLINE

online=ONLINE(i).joint_variables';

base = online(2, :);
lift = online(4, :);

figure("Name","ONLINE"),
subplot(2,2,1)
plot(base)
title('Base Joint Variable')
ylabel('[m]')

subplot(2,2,3)

plot(lift)
title('Lift Joint Variable')
ylabel('[m]')


Arm = online(6:9, :);

subplot(2,2,2)

plot(Arm(1,:), 'r',"LineWidth",2)
hold on
plot(Arm(2,:), 'b',"LineWidth",1.5)
plot(Arm(3,:), 'g',"LineWidth",1)
plot(Arm(4,:), 'k',"LineWidth",0.5)

title("ARM Joint Variable")
legend('l3', 'l2', 'l1', 'l0')
ylabel('[m]')

wrist =  online([10, 12,13], :);

subplot(2,2,4)

plot(wrist(1,:), 'r')
hold on
plot(wrist(2,:), 'b')
plot(wrist(3,:), 'g')
ylabel('[rad]')
title("wrist Joint Variable")
legend('yaw', 'pitch', 'roll')
