clear; close; clc;

alf = string(mat2cell('a':'z',1,ones(1,26))); %#ok<MMTC>

%% Acquisition data from folders
% ONLINE
cd data
cd online
on_1 = extractor_data(alf, "join_variables_online", dir("join_variables_online"), 15, "joint_variables", 0);
on_2 = extractor_data(alf, "strect_online_trajectories_", dir("strect_online_trajectories_"), 3, "trajectories", 1);
on_3 = extractor_data(alf, "stretch_online_dis_ERROR", dir("stretch_online_dis_ERROR"), 1, "errors", 1);

ONLINE = cell2struct([struct2cell(on_1); struct2cell(on_2); struct2cell(on_3)], [fieldnames(on_1); fieldnames(on_2); fieldnames(on_3)]);
cd ..

% OFF-LINE
cd offline
off_1 = extractor_data(alf, "join_variable_offline", dir("join_variable_offline"), 15, "joint_variables", 0);
off_2 = extractor_data(alf, "stretch_trajectories_", dir("stretch_trajectories_"), 3, "trajectories", 1);
off_3 = extractor_data(alf, "stretch_displacement_ERROR", dir("stretch_displacement_ERROR"), 1, "errors", 1);

OFFLINE = cell2struct([struct2cell(off_1); struct2cell(off_2); struct2cell(off_3)], [fieldnames(off_1); fieldnames(off_2); fieldnames(off_3)]);
cd ..
% Reference
REF = extractor_data(alf, "alfabeto", dir("alfabeto"), 3, "points", 0);


cd lair_offline
lair_off_1 = extractor_data(1, "join_variable_offline", dir("join_variable_offline"), 15, "joint_variables", 1);
lair_off_2 = extractor_data(1, "stretch_trajectories_", dir("stretch_trajectories_"), 3, "trajectories", 1);
lair_off_3 = extractor_data(1, "stretch_displacement_ERROR", dir("stretch_displacement_ERROR"), 1, "errors", 1);

LAIR_OFF = cell2struct([struct2cell(lair_off_1); struct2cell(lair_off_2); struct2cell(lair_off_3)], [fieldnames(lair_off_1); fieldnames(lair_off_2); fieldnames(lair_off_3)]);
cd ..

cd lair_online
lair_on_1 = extractor_data(1, "join_variables_online", dir("join_variables_online"), 15, "joint_variables", 1);
lair_on_2 = extractor_data(1, "strect_online_trajectories_", dir("strect_online_trajectories_"), 3, "trajectories", 1);
lair_on_3 = extractor_data(1, "stretch_online_dis_ERROR", dir("stretch_online_dis_ERROR"), 1, "errors", 1);

LAIR_ON = cell2struct([struct2cell(lair_on_1); struct2cell(lair_on_2); struct2cell(lair_on_3)], [fieldnames(lair_on_1); fieldnames(lair_on_2); fieldnames(lair_on_3)]);
cd ..

fileID = fopen("LAIR.txt", 'r');
% Legge i dati dal file
formato = repmat('%f ', 1, 3);  % Specifica il formato dei dati con 15 colonne
dati = textscan(fileID, formato);
% Chiude il file
fclose(fileID);
cd ..
% Trasforma i dati in una matrice
matrice = cat(2, dati{:});
REF_LAIR.points = matrice;

clear on_1 on_2 on_3 off_1 off_2 off_3 lair_off_1 lair_off_2 lair_off_3 lair_on_1 lair_on_2 lair_on_3

function out = extractor_data(alphabet, address, folder, number_column, type_data, in)
    out = struct;
for i = 1 : length(alphabet)
    fileID = fopen(address + "/" + folder(i+2).name, 'r');
    % Legge i dati dal file
    formato = repmat('%f ', 1, number_column);  % Specifica il formato dei dati con 15 colonne
    dati = textscan(fileID, formato);
    % Chiude il file
    fclose(fileID);

    % Trasforma i dati in una matrice
    matrice = cat(2, dati{:});
    if in == 0
        out(i).Letter = alphabet(i);
    end
    out(i).(string(type_data)) = matrice;
end
end


