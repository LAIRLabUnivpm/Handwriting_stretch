
fid = fopen('lairelement_base.txt', 'r');
C = textscan(fid, '[%f, %f, %f, %f, %f, %f, %f]', 'Delimiter', '\n');
fclose(fid);

% Estrai i numeri dalle celle risultanti
numeri_base = cell2mat(C);

%%

fid = fopen('lairelement_left_wheel.txt', 'r');
C = textscan(fid, '[%f, %f]', 'Delimiter', '\n');
fclose(fid);

% Estrai i numeri dalle celle risultanti
numeri_left_wheel = cell2mat(C);
%%
fid = fopen('lairelement_right_wheel.txt', 'r');
C = textscan(fid, '[%f, %f]', 'Delimiter', '\n');
fclose(fid);

% Estrai i numeri dalle celle risultanti
numeri_right_wheel = cell2mat(C);
%%

fid = fopen('lairelement_imu.txt', 'r');
C = textscan(fid, '[%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f]', 'Delimiter', '\n');
fclose(fid);

% Estrai i numeri dalle celle risultanti
numeri_imu = cell2mat(C);
