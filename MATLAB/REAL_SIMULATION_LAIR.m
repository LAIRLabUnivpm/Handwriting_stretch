options = vhacdOptions("RigidBodyTree",SourceMesh="VisualGeometry");

path = 'stretch_virtual_x_base.urdf';
% path = 'urdf\stretch.urdf';
robot = importrobot(path,"urdf");
% robot.Gravity=[0 0 -9.81];
robot.DataFormat = 'column';
%%

showdetails(robot)
limitJointChange = constraintJointBounds(robot);
fixOrientation = constraintOrientationTarget("link_grasp_center");
Initialguess = [0, 0.23, 0.0, 0.0, 0.0, 0.0, 3, 0.0, 0.0]';
show(robot,Initialguess);


%%

real_lair_path_idx = [2,4, 6, 7, 8, 9, 10, 12, 13];

pathway_real_LAIR = LAIR_ON.joint_variables(:,real_lair_path_idx);

l = zeros(length(pathway_real_LAIR),1);

for i = 2 : length(pathway_real_LAIR)
    % if i == 2
    %     l(i-1,1) = round(pathway_real_LAIR(i-1,1),1);
    % end
    % l(i,1) = l(i-1) + round(pathway_real_LAIR(i-1,1),1);
    l(i,1) = l(i-1) + pathway_real_LAIR(i-1,1);
end
pathway_real_LAIR(:,1) = l;

%%
time_interval = 0: 0.2: 2*(length(pathway_real_LAIR)/10)-0.1;

JointSegment = [time_interval',pathway_real_LAIR];


open("simulazione_stretch.slx");

paramStruct.StartTime = "0";
paramStruct.StopTime = string(time_interval(end));

out_2 = sim("simulazione_stretch.slx", paramStruct);



xPositionsEE = reshape(out_2.eePosData1.Data(1,:,:),1,size(out_2.eePosData1.Data,3));
yPositionsEE = reshape(out_2.eePosData1.Data(2,:,:),1,size(out_2.eePosData1.Data,3));
zPositionsEE = reshape(out_2.eePosData1.Data(3,:,:),1,size(out_2.eePosData1.Data,3));

jointConfigurationData = pathway_real_LAIR';


% For faster visualization, only display every few steps
vizStep = 50;

% Initialize a new figure window
figure
set(gcf,'Visible','on');

% Iterate through all joint configurations and end-effectort positions
for i = 1:vizStep:length(xPositionsEE)
    show(robot, jointConfigurationData(:,i),'Frames','off','PreservePlot',false);
    hold on
    plot3(xPositionsEE(1:i),yPositionsEE(1:i),zPositionsEE(1:i),'b','LineWidth',3)

    view(135,20)
    axis([-1.5 1 -1. .5 0 1.5])

    drawnow
end
hold off
%%


real_lair_path_idx = [2,4, 6, 7, 8, 9, 10, 12, 13];

pathway_real_LAIR = LAIR_ON.joint_variables(:,real_lair_path_idx);
pathway_real_LAIR_2 = LAIR_ON.joint_variables(:,real_lair_path_idx);

l = zeros(length(pathway_real_LAIR),1);
l_2 = zeros(length(pathway_real_LAIR),1);
for i = 2 : length(pathway_real_LAIR)
    if i == 2
        l(i-1,1) = round(pathway_real_LAIR(i-1,1),1);
    end
    l(i,1) = l(i-1) + round(pathway_real_LAIR(i-1,1),1);

    l_2(i,1) = l_2(i-1) + pathway_real_LAIR(i-1,1);
end

pathway_real_LAIR(:,1) = l;
open("simulazione_stretch.slx");
time_interval = 0: 0.2: 2*(length(pathway_real_LAIR)/10)-0.1;
JointSegment = [time_interval',pathway_real_LAIR];
paramStruct.StartTime = "0";
paramStruct.StopTime = string(time_interval(end));

profile on
out = sim("simulazione_stretch.slx", paramStruct);

pathway_real_LAIR_2(:,1) = l_2;
time_interval = 0: 0.2: 2*(length(pathway_real_LAIR_2)/10)-0.1;
JointSegment = [time_interval',pathway_real_LAIR_2];
out_2 = sim("simulazione_stretch.slx", paramStruct);
profile off

xPositionsEE = reshape(out.eePosData1.Data(1,:,:),1,size(out.eePosData1.Data,3));
yPositionsEE = reshape(out.eePosData1.Data(2,:,:),1,size(out.eePosData1.Data,3));
zPositionsEE = reshape(out.eePosData1.Data(3,:,:),1,size(out.eePosData1.Data,3));

jointConfigurationData = pathway_real_LAIR';

xPositionsEE_2 = reshape(out_2.eePosData1.Data(1,:,:),1,size(out_2.eePosData1.Data,3));
yPositionsEE_2 = reshape(out_2.eePosData1.Data(2,:,:),1,size(out_2.eePosData1.Data,3));
zPositionsEE_2 = reshape(out_2.eePosData1.Data(3,:,:),1,size(out_2.eePosData1.Data,3));

jointConfigurationData_2 = pathway_real_LAIR_2';

copyrbt=copy(robot);
%%
ax=show(robot, jointConfigurationData_2(:,end),'Frames','off','PreservePlot',false, FastUpdate=true);
rbtpatches=findobj(ax.Children,'Type','patch','-regexp','DisplayName','_mesh');
set(rbtpatches,'FaceAlpha',0.3);
% Now visualize another instance of the same robot
hold on;
show(copyrbt, jointConfigurationData(:,end),'Frames','off','PreservePlot',false, FastUpdate=true,Parent=ax);
patchesnew=findobj(ax.Children,'Type','patch','-regexp','DisplayName','_mesh');
copyrbtpatches=patchesnew(~ismember(patchesnew,rbtpatches));
% You can also change the color aside from alpha
set(copyrbtpatches,'FaceAlpha',0.7);
% set(copyrbtpatches,'FaceColor',[.5,0,0]);

plot3(xPositionsEE_2,yPositionsEE_2,zPositionsEE_2,'-r', "LineWidth", 3);
plot3(xPositionsEE,yPositionsEE,zPositionsEE,'-b', "LineWidth", 3);
view(-90,30)
axis([-1.5 0.3 -.8 .5 0 1.5])
ax.FontName = 'Times New Roman';
ax.FontSize = 15;
ax.FontWeight = 'bold';
xlabel = 'X [m]'