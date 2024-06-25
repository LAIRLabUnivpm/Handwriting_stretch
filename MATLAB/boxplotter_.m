%% Offline
a = [];
b = [];
c = [];

a_2 = [];
b_2 = [];
c_2 = [];

for i = 1 : 26

    a = [a; err_offline(i).total];
    a_2 = [a_2; err_offline(i).total_2];

    for j = 1 : length(err_offline(i).total)

        b = [b; err_offline(i).letter];
        b_2 = [b_2; err_offline(i).letter];
        c = [c; "offline"];
        c_2 = [c_2; "offline_2"];
    end
end
%%
lett = categorical([b;b_2]);
groups = [c;c_2];
data = [a;a_2];

tbl_off = table(lett, groups, data);

figure, 
boxchart(tbl_off.lett, tbl_off.data, "GroupByColor", tbl_off.groups);
ax = gca; 
ax.YAxis.Scale ="log";
ax.Box = 'on';
ax.XGrid = 'on';
ax.FontName = 'Times New Roman';
ax.FontSize = 15;
ax.FontWeight = 'bold';
legend('Without TotBaseDis', 'With TotBaseDis', 'Location','south')
% title('Forward Kinematics Simulation, without and with total Base Displacement')


clear a b c a_2 b_2 c_2 
%% Online
a = [];
b = [];
c = [];

a_2 = [];
b_2 = [];
c_2 = [];

for i = 1 : 26

    a = [a; err_online(i).total];
    a_2 = [a_2; err_online(i).total_2];
    
    for j = 1 : length(err_online(i).total)

        b = [b; err_online(i).letter];
        b_2 = [b_2; err_online(i).letter];
        c = [c; "offline"];
        c_2 = [c_2; "offline_2"];
    end
end
%%
lett = categorical([b;b_2]);
groups = [c;c_2];
data = [a;a_2];

tbl_on = table(lett, groups, data);

figure, 
boxchart(tbl_on.lett, tbl_on.data, "GroupByColor", tbl_on.groups);
ax = gca;
ax.YAxis.Scale ="log";
ax.Box = 'on';
ax.XGrid = 'on';
ax.FontName = 'Times New Roman';
ax.FontSize = 15;
ax.FontWeight = 'bold';
legend('Without TotBaseDis', 'With TotBaseDis',  'Location','north')
% title('Forward Kinematics Real-time, without and with total Base Displacement')

%%


%% Offline
a = [];
b = [];
c = [];

a_2 = [];
b_2 = [];
c_2 = [];

a_3 = [];
b_3 = [];
c_3 = [];

for i = 1 : 26

    a = [a; err_offline(i).total];
    a_2 = [a_2; err_offline(i).total_2];
    a_3 = [a_3; err_offline(i).total_3];

    for j = 1 : length(err_offline(i).total_3)

        b = [b; err_offline(i).letter];
        b_2 = [b_2; err_offline(i).letter];
        b_3 = [b_3; err_offline(i).letter];

        c = [c; "offline"];
        c_2 = [c_2; "offline_2"];
        c_3 = [c_3; "offline_3"];
    end
end
%%
lett = categorical([b;b_2;b_3]);
groups = [c;c_2;c_3];
data = [a;a_2;a_3];

tbl_off = table(lett, groups, data);

figure, 
boxchart(tbl_off.lett, tbl_off.data, "GroupByColor", tbl_off.groups);
ax = gca; 
ax.YAxis.Scale ="log";
ax.Box = 'on';
ax.XGrid = 'on';
ax.FontName = 'Times New Roman';
ax.FontSize = 15;
ax.FontWeight = 'bold';
legend('Without', 'With', 'correction')
% title('Forward Kinematics Simulation, without and with total Base Displacement')


clear a b c a_2 b_2 c_2 a_3 b_3 c_3
%% Online
a = [];
b = [];
c = [];

a_2 = [];
b_2 = [];
c_2 = [];

a_3 = [];
b_3 = [];
c_3 = [];

for i = 1 : 26

    a = [a; err_online(i).total];
    a_2 = [a_2; err_online(i).total_2];
    a_3 = [a_3; err_online(i).total_3];

    for j = 1 : length(err_online(i).total_3)

        b = [b; err_online(i).letter];
        b_2 = [b_2; err_online(i).letter];
        b_3 = [b_3; err_online(i).letter];

        c = [c; "offline"];
        c_2 = [c_2; "offline_2"];
        c_3 = [c_3; "offline_3"];
    end
end
%%
lett = categorical([b;b_2;b_3]);
groups = [c;c_2;c_3];
data = [a;a_2;a_3];

tbl_on = table(lett, groups, data);

figure, 
boxchart(tbl_on.lett, tbl_on.data, "GroupByColor", tbl_on.groups);
ax = gca;
ax.YAxis.Scale ="log";
ax.Box = 'on';
ax.XGrid = 'on';
ax.FontName = 'Times New Roman';
ax.FontSize = 15;
ax.FontWeight = 'bold';
legend('Without TotBaseDis', 'With TotBaseDis', 'Threshold Applied', 'Location','north')
% title('Forward Kinematics Real-time, without and with total Base Displacement')
%%
lett = categorical(b_3);
groups = c_3;
data = a_3;

tbl_on = table(lett, groups, data);

figure, 
boxchart(tbl_on.lett, tbl_on.data, "GroupByColor", tbl_on.groups);
ax = gca;
ax.YAxis.Scale ="log";
ax.Box = 'on';
ax.XGrid = 'on';
ax.FontName = 'Times New Roman';
ax.FontSize = 15;
ax.FontWeight = 'bold';
legend('Correction')

%%
%%
a = [];
b = [];
c = [];

a_1 = [];
b_1 = [];
c_1 = [];

a_2 = [];
b_2 = [];
c_2 = [];

a_12 = [];
b_12 = [];
c_12 = [];

a_3 = [];
b_3 = [];
c_3 = [];

a_31 = [];
b_31 = [];
c_31 = [];

a = [a; err_lair.OFF.total];
a_2 = [a_2; err_lair.OFF.total_2];
a_3 = [a_3; err_lair.OFF.total_3];
c = ones(length(err_lair.OFF.total),1);
c_2 = 2*ones(length(err_lair.OFF.total),1);
c_3 = 3*ones(length(err_lair.OFF.total),1);

a_1 = [a_1; err_lair.ON.total];
a_12 = [a_12; err_lair.ON.total_2];
a_31 = [a_31; err_lair.ON.total_3];
c_1 = ones(length(err_lair.ON.total),1);
c_21 = 2*ones(length(err_lair.ON.total),1);
c_31 = 3*ones(length(err_lair.ON.total),1);




%%
lett = categorical(repmat("OFFLINE",[3*length(err_lair.OFF.total) 1]));
groups = [c;c_2;c_3];
data = [a;a_2;a_3];

tbl_lair_off = table(lett, groups, data);
clear lett data groups
lett = categorical(repmat("REAL TIME",[3*length(err_lair.ON.total) 1]));
groups = [c_1;c_21;c_31];
data = [a_1;a_12;a_31];

tbl_lair_on = table(lett, groups, data);
clear lett data groups

tbl_lair = [tbl_lair_off; tbl_lair_on];
figure, 
boxchart(tbl_lair.lett, tbl_lair.data, "GroupByColor", tbl_lair.groups);
ax = gca; 
ax.YAxis.Scale ="log";
ax.Box = 'on';
ax.XGrid = 'on';
ax.FontName = 'Times New Roman';
ax.FontSize = 15;
ax.FontWeight = 'bold';
legend('Without TotBaseDis', 'With TotBaseDis', 'Threshold Applied', 'Location', 'southeast')


