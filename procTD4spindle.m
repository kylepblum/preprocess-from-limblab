%% set data folder
cdslib = 'C:\Users\kpb8927\data\cds-library';


files = dir(fullfile(cdslib,'*COactpas*'));
names = vertcat({files.name})';

load_params = struct(...
    'array_name','S1',...
    'cds_array_name','LeftS1Area2',...
    'cont_signal_names',{{...
        'pos',...
	    'vel',...
        'force',...
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
        }},...
    'trial_meta',{{...
        'bumpDir',...
        'tgtDir',...
        'spaceNum',...
        }},...
     'extract_emg',true,...
     'extract_spikes',true,...
     'bin_size',0.005);

td_cell = cell(length(names),1);
for i = 1%:length(names)
    td_cell{i} = loadTDfromCDS(fullfile(cdslib,names{i}),load_params);
    fprintf('File %d processed\n',i)
end

%%
savedir = 'C:\Users\kpb8927\data\td-library';

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
    trial_data = td_cell{i};
    trial_data = getRelMusLen(trial_data,LengthParams);
    if isfield(trial_data,'emg')
        trial_data = getNormEMG(trial_data,[]);
    end
    
    smoothKin.signals = {'musLenRel','musVelRel','joint_ang','joint_vel',...
        'pos','vel','emgNorm'};
    smoothKin.kernel_width = 0.05;
    smoothKin.calc_rate = false;
    trial_data = smoothSignals(trial_data,smoothKin);
    



    
    params.split_idx_name = 'idx_startTime';
    params.extra_bins = [200 0]; %Extra bins at the beginning because muscle spindles are history-dependent
    trial_data = splitTD(trial_data,params);

    
    save(fullfile(savedir,sprintf('%s_%s_TRT_5ms.mat',file_info(i).monkey,file_info(i).date)),'trial_data','-v7.3')
    fprintf('File %d saved\n',i)
end

%% Run spindle model before this

% for i = [1,4:length(td_cell)]
for i = 1%:length(names)
   
    for trial = 1:numel(trial_data)
        for mus = 1:numel(spindleData)
            trial_data(trial).spindles(:,mus) = spindleData(mus).SimOut(trial).r;
            trial_data(trial).spindleMeta(mus) = spindleData(mus).metaParams;
        end
    end
   
%     save(fullfile(savedir,sprintf('Han_20171106_TRT_5ms_spindle.mat','trial_data','-v7.3')
%     fprintf('File %d saved\n',i)
end






