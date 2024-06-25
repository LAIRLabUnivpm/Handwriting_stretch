
i = 11;

x_ref = REF(i).points(:,1);
y_ref = REF(i).points(:,2);
z_ref = REF(i).points(:,3);

on_x = -1* ONLINE(i).trajectories(:,2);
on_y = ONLINE(i).trajectories(:,3);
on_z = ONLINE(i).trajectories(:,1);%round(ONLINE(i).trajectories(:,1),2);

off_x = -1* OFFLINE(i).trajectories(:,2);
off_y = OFFLINE(i).trajectories(:,3);
off_z = OFFLINE(i).trajectories(:,1);

err_on = ONLINE(i).errors;
err_off = OFFLINE(i).errors;

err_x = x_ref - (on_x(2:end) - 0.20);
err_z = y_ref - on_y(2:end);
err_y = z_ref - (on_z(2:end)-0.23);

err_x_off = x_ref - (off_x - 0.20);
err_z_off = y_ref - off_y;
err_y_off = z_ref - (off_z-0.23);

aa = [x_ref,y_ref,z_ref];
bb = [on_x(2:end)-0.20, on_y(2:end), on_z(2:end)-0.23];
cc = [off_x-0.20, off_y, off_z-0.23];

figure
subplot(2,2,1)
plot3(x_ref, z_ref, y_ref, "*b")

hold on
plot3(x_ref(1,1), z_ref(1,1), y_ref(1,1),'b', Marker="hexagram", MarkerSize=20)

plot3(on_x-0.20, on_z-0.23, on_y, "*k")

plot3(on_x(1,1)-0.20, on_z(1,1)-0.23, on_y(1,1),'k', Marker="hexagram", MarkerSize=20)


plot3(off_x-0.20, off_z-0.23, off_y, "or")


legend("Reference", "", "On-line", "","Simulation", 'Location', 'southeast')
hold off

%figure
subplot(2,2,2)
plot(err_on, 'k')
hold on
plot(err_off, 'r')

legend("On-line", "Simulation")
title("Error computation using chain.forwardkinematics!")

%figure
subplot(2,2,3)
plot(err_x)
hold on
plot(err_y)
plot(err_z)

legend("y", "x", "z")
title("Error as Ref - Online")

%figure
subplot(2,2,4)
plot(err_x_off)
hold on
plot(err_y_off)
plot(err_z_off)

legend("y", "x", "z")
title("Error as Ref - Offline")
%
figure
plot(vecnorm(aa-bb, 2, 2))
hold on
plot(vecnorm(aa-cc, 2, 2))

legend("On-line", "Simulation")
title("Distances between Ref -> On-line and Simulation")

%%
figure

on_trajec = ONLINE(i).joint_variables(:,2);
off_trajec = OFFLINE(i).joint_variables(:,2);

plot(on_trajec, "k", "LineWidth",3)
hold on
plot(off_trajec, "r")

hold off
legend("On-line", "Simulation")

%%

rr = [-1*yPositionsEE'-0.20,xPositionsEE'-0.23,zPositionsEE'];
% rr = rr*rotz(180);

figure
subplot(2,2,1)
plot3(x_ref, z_ref, y_ref, "*b")
xlabel('x')
ylabel('y')
zlabel('z')
hold on
plot3(x_ref(1,1), z_ref(1,1), y_ref(1,1),'b', Marker="hexagram", MarkerSize=20)

plot3(on_x-0.20, on_z-0.23, on_y, "*k")

plot3(on_x(1,1)-0.20, on_z(1,1)-0.23, on_y(1,1),'k', Marker="hexagram", MarkerSize=20)

plot3(rr(:,1) - 0.05, rr(:,2), rr(:,3), "oc", "MarkerSize",10)

plot3(off_x-0.20, off_z-0.23, off_y, "or")

legend("Reference", "", "On-line", "","matlab_SIM", "Simulation")
hold off
%%


plot3(LAIR_OFF.trajectories(:,1), LAIR_OFF.trajectories(:,2), LAIR_OFF.trajectories(:,3), 'r')
hold on
plot3(0.23*ones(length(LAIR_ON.trajectories(:,1)),1), LAIR_ON.trajectories(:,2), LAIR_ON.trajectories(:,3), 'b')

legend('off', 'on')
% axis('equal')
%%
l = zeros(length(LAIR_ON.trajectories),1);

for i = 2 : length(LAIR_ON.trajectories)
    l(i,1) = l(i-1) + LAIR_ON.trajectories(i-1,1);
end

plot(l)
%%





a = zeros(26,1);
c = [];
b = [];
d = [];

k = 0;
err_offline;
err_online;
for i  = 1 : 26

    a = zeros(length(err_online(i).y),1);
    for j = 1 : length(err_online(i).total)
    
        b = [b; err_online(i).total(j)];
        c = [c; err_online(i).letter];
        d = [d; "online"];
        k = k + 1;
    end
    
    % a(i) = size(err_online(i).y,1);
    % b(i) = err_online(i).mean;
    % c(i) = err_online(i).standar_deviation;
    
end
%% AS Forward Kinematics

lett = categorical(c);
tbl = table(lett, b, d);
colori = lines(numel(unique(lett))); % Genera una sequenza di colori in base al numero di categorie

% 
% box = boxchart(tbl.b, "GroupByColor", tbl.lett);
% 
% title('Box Chart');
% legend([err_online.letter])
figure,
box = boxchart(tbl.lett, tbl.b, "GroupByColor", tbl.d);
% 
% Modifica della dimensione del font degli assi x
ax = gca; % Ottieni l'oggetto "current axes"
ax.XAxis.FontSize = 15; % Imposta la dimensione del font degli assi x
ax.YAxis.FontSize = 15;
ax.Box = 'on';
ax.XGrid = 'on';
ax.FontName = 'Times New Roman';
ax.FontSize = 15;
legend('Simulation', 'Real-time')

figure,
meanWeight = groupsummary(b,lett,'mean');
box =  boxchart(tbl.lett, tbl.b, "GroupByColor", tbl.d);
hold on
plot(meanWeight,'-o')
hold off
legend('Simulation', 'Real-time',"Error Mean")
ax = gca; % Ottieni l'oggetto "current axes"
ax.Box = 'on';
ax.XGrid = 'on';
ax.FontName = 'Times New Roman';
ax.FontSize = 15;


%% Taking account the completly base displacement

a = zeros(26,1);
c = [];
b = [];
d = [];
%%
k = 0;
err_offline;
err_online;
for i  = 1 : 26

    a = zeros(length(err_offline(i).y),1);
    for j = 1 : length(err_offline(i).total_2)
    
        b = [b; err_offline(i).total_2(j)];
        c = [c; err_offline(i).letter];
        d = [d; "offline"];
        k = k + 1;
    end
    
    % a(i) = size(err_online(i).y,1);
    % b(i) = err_online(i).mean;
    % c(i) = err_online(i).standar_deviation;
    
end

lett = categorical(c);
tbl = table(lett, b, d);
colori = lines(numel(unique(lett))); % Genera una sequenza di colori in base al numero di categorie

% 
% box = boxchart(tbl.b, "GroupByColor", tbl.lett);
% 
% title('Box Chart');
% legend([err_online.letter])
figure,
box = boxchart(tbl.lett, tbl.b, "GroupByColor", tbl.d);
% 
% Modifica della dimensione del font degli assi x
ax = gca; % Ottieni l'oggetto "current axes"
ax.XAxis.FontSize = 15; % Imposta la dimensione del font degli assi x
ax.YAxis.FontSize = 15;
ax.Box = 'on';
ax.XGrid = 'on';
ax.FontName = 'Times New Roman';
ax.FontSize = 15;
legend('Simulation', 'Real-time')

figure,
meanWeight = groupsummary(b,lett,'mean');
box =  boxchart(tbl.lett, tbl.b, "GroupByColor", tbl.d);
hold on
plot(meanWeight,'-o')
hold off
legend('Simulation', 'Real-time',"Error Mean")
ax = gca; % Ottieni l'oggetto "current axes"
ax.Box = 'on';
ax.XGrid = 'on';
ax.FontName = 'Times New Roman';
ax.FontSize = 15;

%%
%%
%%
%%
%%



x_ref = REF_LAIR.points(:,1);
y_ref = REF_LAIR.points(:,2);
z_ref = REF_LAIR.points(:,3);

on_x = -1* LAIR_ON.trajectories(:,2);
on_y = LAIR_ON.trajectories(:,3);
on_z = LAIR_ON.trajectories(:,1);%round(ONLINE(i).trajectories(:,1),2);

off_x = -1*LAIR_OFF.trajectories(:,2);
off_y = LAIR_OFF.trajectories(:,3);
off_z = LAIR_OFF.trajectories(:,1);

l = zeros(length(LAIR_ON.trajectories),1);

for i = 2 : length(LAIR_ON.trajectories)
    l(i,1) = l(i-1) + LAIR_ON.trajectories(i-1,1);
end

on_z = l;

plot3(x_ref, z_ref, y_ref, "*b")
xlabel('x')
ylabel('y')
zlabel('z')
hold on
plot3(x_ref(1,1), z_ref(1,1), y_ref(1,1),'b', Marker="hexagram", MarkerSize=20)

plot3(on_x-0.20, on_z-0.23, on_y, "*k")

plot3(on_x(1,1)-0.20, on_z(1,1)-0.23, on_y(1,1),'k', Marker="hexagram", MarkerSize=20)


plot3(off_x-0.20, off_z-0.23, off_y, "or")

legend("Reference", "", "On-line", "","Simulation")
hold off