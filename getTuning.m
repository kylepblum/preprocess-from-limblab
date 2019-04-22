function [fr] = getTuning(trial_data,params)

for trial = 1:length(trial_data)
    
    fr(trial,:) = sum(trial_data(trial).(params.array)(1:1000,:));
    
end

end