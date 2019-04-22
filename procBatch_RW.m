%% set data folder
cdslib = '/Users/kylepblum/LimbLab/workingData/cds-library';

files = dir(fullfile(cdslib,'*RW*'));
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
        }},...
    'trial_meta',{{...
        'target_direction'
        }},...
     'extract_emg',false,...
     'extract_spikes',true,...
     'bin_size',0.05);

td_cell = cell(length(names),1);
for i = 1%:length(names)
    td_cell{i} = loadTDfromCDS(fullfile(cdslib,names{i}),load_params);
    fprintf('File %d processed\n',i)
end

%% Deal with VAE spikes
% Load csv with VAE spikes first
td_cell{1}.VAE_spikes = Han20160325RW10msVAE;
trial_data = td_cell{1};

%Deal with size differences by appending zeros
td_length = size(trial_data.pos,1);
rates_length = size(trial_data.VAE_spikes,1);
rates_width = size(trial_data.VAE_spikes,2);
td_length_diff = td_length - rates_length;
trial_data.VAE_spikes = [trial_data.VAE_spikes; zeros(td_length_diff,rates_width)];



smoothVAE.signals = {'VAE_spikes'};
smoothVAE.kernel_width = 0.05;
smoothVAE.calc_rate = true;
trial_data = smoothSignals(trial_data,smoothVAE);

VAE_unit_guide = zeros(size(trial_data.VAE_spikes,2),2);
trial_data.VAE_unit_guide = VAE_unit_guide;

%%
savedir = '/Users/kylepblum/LimbLab/workingData/td-library';

trial_data = td_cell{1};

file_info_cell = cell(length(names),6);

for i = 1%:length(names)
    file_info_cell(i,:) = strsplit(names{i},{'_','.'});
end

file_info = struct(...
    'monkey',file_info_cell(:,1),...
    'date',file_info_cell(:,2),...
    'filenum',file_info_cell(:,5));

LengthParams.opensimChris = false;
LengthParams.L0 = 'session_mean';
% for i = [1,4:length(td_cell)]
for i = 1%:length(names)
%     trial_data = td_cell{i};
    trial_data = getRelMusLen(trial_data,LengthParams);
    if isfield(trial_data,'emg')
        trial_data = getNormEMG(trial_data,[]);
    end
    smoothKin.signals = {'musLenRel','musVelRel'};
    smoothKin.kernel_width = 0.05;
    smoothKin.calc_rate = false;
    trial_data = smoothSignals(trial_data,smoothKin);
    
    
    
    params.split_idx_name = 'idx_startTime';
    trial_data = splitTD(trial_data,params);
    
    save(fullfile(savedir,sprintf('%s_%s_RW_50ms.mat',file_info(i).monkey,file_info(i).date)),'trial_data','-v7.3')
    fprintf('File %d saved\n',i)
end



