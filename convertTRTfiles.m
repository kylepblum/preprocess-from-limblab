%% set data folder
cdslib = '/Users/kylepblum/LimbLab/workingData/cds-library';

files = dir(fullfile(cdslib,'*TRT*'));
names = vertcat({files.name})';

load_params = struct(...
    'array_name','S1',...
    'cds_array_name','LeftS1Area2',...
    'cont_signal_names',{{...
        'pos',...
	    'vel',...
	    'markers',...
	    'joint_ang',...
	    'joint_vel',...
	    'muscle_len',...
	    'muscle_vel',...
        }},...
    'event_names',{{...
        'startTime',...
        'endTime',...
        'goCueTime',...
        'bumpTime',...
        'targetStartTime',...
        'ctHoldTime',...
        'otHoldTime',...
        }},...
    'trial_meta',{{...
        'bumpDir',...
        'spaceNum',...
        }});

td_cell = cell(length(names),1);
for i = 1:length(names)
    td_cell{i} = loadTDfromCDS(fullfile(cdslib,names{i}),load_params);
    fprintf('File %d processed\n',i)
end

%%
savedir = '/Users/kylepblum/LimbLab/workingData/td-library';

file_info_cell = cell(length(names),6);

for i = 1:length(names)
    file_info_cell(i,:) = strsplit(names{i},{'_','.'});
end

file_info = struct(...
    'monkey',file_info_cell(:,1),...
    'date',file_info_cell(:,2),...
    'filenum',file_info_cell(:,5));

for i = [1,4:length(td_cell)]
    trial_data = td_cell{i};
    save(fullfile(savedir,sprintf('%s_%s_TRT_TD.mat',file_info(i).monkey,file_info(i).date)),'trial_data')
    fprintf('File %d saved\n',i)
end

%%
trial_data = horzcat(td_cell{2:3});
save(fullfile(savedir,sprintf('%s_%s_COactpas_TD.mat',file_info(2).monkey,file_info(2).date)),'trial_data')