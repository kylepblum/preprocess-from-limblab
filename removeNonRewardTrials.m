function trial_data = removeNonRewardTrials(trial_data,params)


trial_idx = trial_data(1).result;
keep_idx = strfind(trial_idx,'R');
trial_data = trial_data(keep_idx);

new_result = trial_data(1).result(keep_idx);
if isfield(trial_data,'bumpDir')
    new_bumpDir = trial_data(1).bumpDir(keep_idx);
end

for i = 1:numel(trial_data)
    trial_data(i).result = new_result;
    if isfield(trial_data,'bumpDir')
        trial_data(i).bumpDir = new_bumpDir;
    end
end



end