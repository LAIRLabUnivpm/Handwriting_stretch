options = vhacdOptions("RigidBodyTree",SourceMesh="VisualGeometry");

path = 'stretch_virtual_x_base.urdf';
% path = 'urdf\stretch.urdf';
robot = importrobot(path,"urdf");
% robot.Gravity=[0 0 -9.81];
robot.DataFormat = 'column';
%%

% % showdetails(robot)
limitJointChange = constraintJointBounds(robot);
fixOrientation = constraintOrientationTarget("link_grasp_center");
Initialguess = [0, 0.23, 0.0, 0.0, 0.0, 0.0, 3, 0.0, 0.0]';
% % % % % % % Initialguess = [0, 0.23, 0.0, 0.0, 0.0, 0.0, pi/2, 0.0, 0.0]';

% show(robot,Initialguess);
%% Solver IK
s=rng(0);
ik =  inverseKinematics('RigidBodyTree',robot, 'SolverAlgorithm','LevenbergMarquardt');
weights = limitJointChange.Weights;
eeName = 'link_grasp_center';

%%

numJoints = length(robot.homeConfiguration);

e_orientation = axang2rotm([0,0,1,0]);


ref = REF(i).points;
ref(:,1) = 0.23 + REF(i).points(:,3); % z cart -> x robot
ref(:,2) = -0.25 - REF(i).points(:,1); % x cart -> y robot
ref(:,3) = REF(i).points(:,2); % y cart -> z robot

% lair_ref = load("LAIR.mat");

% ref = zeros(length(lair_ref.pos),3);
% 
% ref(:,1) = 0.2363 + lair_ref.pos(:,3); % z cart -> x robot
% ref(:,2) = -0.05 - lair_ref.pos(:,1)/100; % x cart -> y robot
% ref(:,3) = (lair_ref.pos(:,2)+60)/100; % y cart -> z robot

currentJointSegment = zeros(numJoints, length(ref));

% Compute IK at each waypoint along each segment
for i = 1:length(ref)
    
    pose = [e_orientation ref(i,:)'; 0 0 0 1];
    currentJointSegment(:,i) = ik(eeName,pose,weights(1:6),Initialguess);
    if currentJointSegment(1,i) < 0.01
        currentJointSegment(1,i) = 0;
    end
    Initialguess = currentJointSegment(:,i);
end

time_interval = 0: 0.2: 2*(length(ref)/10)-0.1;

JointSegment = [time_interval',currentJointSegment'];


open("simulazione_stretch.slx");

paramStruct.StartTime = "0";
paramStruct.StopTime = string(time_interval(end));

out = sim("simulazione_stretch.slx", paramStruct);



xPositionsEE = reshape(out.eePosData1.Data(1,:,:),1,size(out.eePosData1.Data,3));
yPositionsEE = reshape(out.eePosData1.Data(2,:,:),1,size(out.eePosData1.Data,3));
zPositionsEE = reshape(out.eePosData1.Data(3,:,:),1,size(out.eePosData1.Data,3));

jointConfigurationData = currentJointSegment;


% For faster visualization, only display every few steps
vizStep = 10;

% Initialize a new figure window
figure
set(gcf,'Visible','on');

% Iterate through all joint configurations and end-effectort positions
for i = 1:vizStep:length(xPositionsEE)
    show(robot, jointConfigurationData(:,i),'Frames','off','PreservePlot',false);
    hold on
    plot3(xPositionsEE(1:i),yPositionsEE(1:i),zPositionsEE(1:i),'b','LineWidth',3)

    view(135,20)
    axis([-0.3 1 -1. .5 0 1.5])

    drawnow
end
hold off