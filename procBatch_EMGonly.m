%% set data folder
cdslib = '/Users/kylepblum/LimbLab/workingData/cds-library';

files = dir(fullfile(cdslib,'*COactpas*'));
filenum = 1;
names = vertcat({files.name})';

load_params = struct(...
    'array_name','S1',...
    'cds_array_name','LeftS1Area2',...
    'cont_signal_names',{{...
        'pos',...
	    'vel',...
        'motor_control',...
        'muscle_len',...
        'muscle_vel',...
        'joint_ang',...
        'joint_vel'
        }},...
    'event_names',{{...
        'startTime',...
        'endTime',...
        'goCueTime',...
        'bumpTime',...
        }},...
    'trial_meta',{{...
        'bumpDir',...
        'target_direction',...
        'spaceNum',...
        }},...
     'extract_emg',false,...
     'extract_spikes',false,...
     'bin_size',0.001);

td_cell = cell(length(names),1);
for i = filenum%:length(names)
    td_cell{i} = loadTDfromCDS(fullfile(cdslib,names{i}),load_params);
    fprintf('File %d processed\n',i)
end



%%
savedir = '/Users/kylepblum/LimbLab/workingData/td-library';

file_info_cell = cell(length(names),6);

for i = filenum%:length(names)
    file_info_cell(i,:) = strsplit(names{i},{'_','.'});
end

file_info = struct(...
    'monkey',file_info_cell(:,1),...
    'date',file_info_cell(:,2),...
    'filenum',file_info_cell(:,5));

% for i = [1,4:length(td_cell)]
for i = filenum%:length(names)
    trial_data = td_cell{i};
    trial_data = getRelMusLen(trial_data,[]);
    trial_data = getNormEMG(trial_data,[]);
    fieldsToRemove = {'emg','muscle_len','muscle_vel'};  
    trial_data = rmfield(trial_data,fieldsToRemove);
    split_params = struct('split_idx_name','idx_startTime');
    trial_data = splitTD(trial_data,split_params);
    trial_data = removeNonRewardTrials(trial_data,[]);
    save(fullfile(savedir,sprintf('%s_%s_COactpas_1ms.mat',file_info(i).monkey,file_info(i).date)),'trial_data','-v7.3')
    fprintf('File %d saved\n',i)
end













