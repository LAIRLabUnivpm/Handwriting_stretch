
err_online = struct;
err_offline = struct;
err_lair = struct;

for i = 1 : length(OFFLINE)
    err_online(i).letter = REF(i).Letter;
    err_offline(i).letter = REF(i).Letter;

    if i == 9
        k = 100;
    else
        k = 1;
    end

    x_ref = REF(i).points(:,1)/k;
    y_ref = REF(i).points(:,2);
    z_ref = REF(i).points(:,3);
    
    x_err_on = -1* ONLINE(i).trajectories(:,2);
    y_err_on = ONLINE(i).trajectories(:,3);
    z_err_on = ONLINE(i).trajectories(:,1);

    x_err_off = -1* OFFLINE(i).trajectories(:,2);
    y_err_off = OFFLINE(i).trajectories(:,3);
    z_err_off = OFFLINE(i).trajectories(:,1);

    % Without total displacement error along x
    err_online(i).y = x_ref - (x_err_on(2:end) - 0.20);
    err_online(i).z = y_ref - y_err_on(2:end);
    err_online(i).x = z_ref - (z_err_on(2:end)-0.23);

    err_offline(i).y = x_ref - (x_err_off - 0.20);
    err_offline(i).z = y_ref - y_err_off;
    err_offline(i).x = z_ref - (z_err_off-0.23);

    aa = [z_ref,x_ref,zeros(length(y_ref),1)];
    err_online(i).xyz = [z_err_on(2:end)-0.23, x_err_on(2:end)-0.20, y_err_on(2:end)-y_ref];
    err_offline(i).xyz = [z_err_off-0.23, x_err_off-0.20, y_err_off-y_ref];

    err_online(i).total = vecnorm(aa-err_online(i).xyz, 2, 2);
    err_offline(i).total = vecnorm(aa-err_offline(i).xyz, 2, 2);

    err_online(i).mean = mean(err_online(i).total);
    err_online(i).standar_deviation = std(err_online(i).total);

    err_offline(i).mean = mean(err_offline(i).total);
    err_offline(i).standar_deviation = std(err_offline(i).total);

    % With Total displacement error along x
    q = zeros(length(err_online(i).x),1);
    q_2 = zeros(length(err_online(i).x),1);
    
    for j = 1 : length(err_online(i).x)-1
        if j == 1
            q(j) = err_online(i).x(j);
            q_2(j) = err_offline(i).x(j);
        else
            q(j+1) = q(j) + err_online(i).x(j);
            q_2(j+1) = q_2(j) + err_offline(i).x(j);
        end
    
    end
    err_online(i).total_base_movement = q;
    err_offline(i).total_base_movement = q_2;
   
    aa = [z_ref,x_ref,zeros(length(y_ref),1)];
    err_online(i).xyz_2 = [err_online(i).total_base_movement, x_err_on(2:end)-0.20, y_err_on(2:end)-y_ref];
    err_offline(i).xyz_2 = [err_offline(i).total_base_movement, x_err_off-0.20, y_err_off-y_ref];

    err_online(i).total_2 = vecnorm(aa-err_online(i).xyz_2, 2, 2);
    err_offline(i).total_2 = vecnorm(aa-err_offline(i).xyz_2, 2, 2);

    err_online(i).mean_2 = mean(err_online(i).total_2);
    err_online(i).standar_deviation_2 = std(err_online(i).total_2);

    err_offline(i).mean_2 = mean(err_offline(i).total_2);
    err_offline(i).standar_deviation_2 = std(err_offline(i).total_2);

    clear aa q q_2
    
    % Without error along x
    aa = [z_ref,x_ref,zeros(length(y_ref),1)];
    err_online(i).xyz_3 = [zeros(length(z_ref),1), x_err_on(2:end)-0.20, y_err_on(2:end)-y_ref];
    err_offline(i).xyz_3 = [zeros(length(z_ref),1), x_err_off-0.20, y_err_off-y_ref];

    err_online(i).total_3 = vecnorm(aa-err_online(i).xyz_3, 2, 2);
    err_offline(i).total_3 = vecnorm(aa-err_offline(i).xyz_3, 2, 2);

    err_online(i).mean_3 = mean(err_online(i).total_3);
    err_online(i).standar_deviation_3 = std(err_online(i).total_3);

    err_offline(i).mean_3 = mean(err_offline(i).total_3);
    err_offline(i).standar_deviation_3 = std(err_offline(i).total_3);
    
    clear x_ref y_ref z_ref x_err_on y_err_on z_err_on x_err_off y_err_off z_err_off aa

end

x_ref = REF_LAIR.points(:,1);
y_ref = REF_LAIR.points(:,2);
z_ref = REF_LAIR.points(:,3);

x_err_on = -1* LAIR_ON.trajectories(:,2);
y_err_on = LAIR_ON.trajectories(:,3);
z_err_on = LAIR_ON.trajectories(:,1);

x_err_off = -1* LAIR_OFF.trajectories(:,2);
y_err_off = LAIR_OFF.trajectories(:,3);
z_err_off  = LAIR_OFF.trajectories(:,1);

err_lair.ON.y = x_ref - (x_err_on(2:end) - 0.20);
err_lair.ON.z = y_ref - y_err_on(2:end);
err_lair.ON.x = z_ref - (z_err_on(2:end)-0.23);

err_lair.OFF.y = x_ref - (x_err_off - 0.20);
err_lair.OFF.z = y_ref - y_err_off;
err_lair.OFF.x = z_ref - (z_err_off-0.23);

aa = [z_ref,x_ref,zeros(length(y_ref),1)];
err_lair.ON.xyz = [z_err_on(2:end)-0.23, x_err_on(2:end)-0.20, y_err_on(2:end)-y_ref];
err_lair.OFF.xyz = [z_err_off-0.23, x_err_off-0.20, y_err_off-y_ref];

err_lair.ON.total = vecnorm(aa-err_lair.ON.xyz, 2, 2);
err_lair.OFF.total = vecnorm(aa-err_lair.OFF.xyz, 2, 2);

err_lair.ON.mean = mean(err_lair.ON.total);
err_lair.ON.standar_deviation = std(err_lair.ON.total);

err_lair.OFF.mean = mean(err_lair.OFF.total);
err_lair.OFF.standar_deviation = std(err_lair.OFF.total);

q = zeros(length(err_lair.ON.x),1);
q_2 = zeros(length(err_lair.ON.x),1);

for j = 1 : length(err_lair.ON.x)-1
    if j == 1
        q(j) = err_lair.ON.x(j);
        q_2(j) = err_lair.OFF.x(j);
    else
        q(j+1) = q(j) + err_lair.ON.x(j);
        q_2(j+1) = q_2(j) + err_lair.OFF.x(j);
    end

end
err_lair.ON.total_base_movement = q;
err_lair.OFF.total_base_movement = q_2;

aa = [z_ref,x_ref,zeros(length(y_ref),1)];
err_lair.ON.xyz_2 = [err_lair.ON.total_base_movement, x_err_on(2:end)-0.20, y_err_on(2:end)-y_ref];
err_lair.OFF.xyz_2 = [err_lair.OFF.total_base_movement, x_err_off-0.20, y_err_off-y_ref];

err_lair.ON.total_2 = vecnorm(aa-err_lair.ON.xyz_2, 2, 2);
err_lair.OFF.total_2 = vecnorm(aa-err_lair.OFF.xyz_2, 2, 2);

err_lair.ON.mean_2 = mean(err_lair.ON.total_2);
err_lair.ON.standar_deviation_2 = std(err_lair.ON.total_2);

err_lair.OFF.mean_2 = mean(err_lair.OFF.total_2);
err_lair.OFF.standar_deviation_2 = std(err_lair.OFF.total_2);

clear aa q q_2

aa = [z_ref,x_ref,zeros(length(y_ref),1)];
err_lair.ON.xyz_3 = [zeros(length(z_ref),1), x_err_on(2:end)-0.20, y_err_on(2:end)-y_ref];
err_lair.OFF.xyz_3 = [zeros(length(z_ref),1), x_err_off-0.20, y_err_off-y_ref];

err_lair.ON.total_3 = vecnorm(aa-err_lair.ON.xyz_3, 2, 2);
err_lair.OFF.total_3 = vecnorm(aa-err_lair.OFF.xyz_3, 2, 2);

err_lair.ON.mean_3 = mean(err_lair.ON.total_3);
err_lair.ON.standar_deviation_3 = std(err_lair.ON.total_3);

err_lair.OFF.mean_3 = mean(err_lair.OFF.total_3);
err_lair.OFF.standar_deviation_3 = std(err_lair.OFF.total_3);

clear x_ref y_ref z_ref x_err_on y_err_on z_err_on x_err_off y_err_off z_err_off aa
%%

plot(err_lair.ON.total_base_movement, "b")
hold on
plot(err_lair.OFF.total_base_movement, "r")
title("'LAIR' execution by Stretch")
legend("real", "simu")
ylabel('Error along X [m]')

%%



alf = string(mat2cell('a':'z',1,ones(1,26)));
cd online\tempo_esecuzione
out = struct;
for i  =  1 : length(alf)

    fileID = fopen(alf(i)+".txt", 'r');
    formato = repmat('%f ', 1, 1);
    dati = textscan(fileID, formato);
    fclose(fileID);
    matrice = cat(2, dati{:});
    dmatrice = diff(matrice);
    m = zeros(size(matrice));
    for j = 2 : length(dmatrice)+1

        m(j) = m(j-1) + dmatrice(j-1);

    end

    out(i).tempo = m;
    out(i).tempo_per_step = [0;dmatrice];
    out(i).media_step = mean(dmatrice);
end

cd ..\..