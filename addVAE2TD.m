function trial_data = addVAE2TD(trial_data,VAE,params)

totalLen = 0;
for trial = 1:length(trial_data)
    totalLen = totalLen + size(trial_data(trial).pos,1);
end

bufferSize = totalLen - size(VAE.zhatMuscle2Hand,1);
VAE.zhatMuscle2Hand = [VAE.zhatMuscle2Hand; NaN(bufferSize,25)];
VAE.zhatMuscle2Joints = [VAE.zhatMuscle2Joints; NaN(bufferSize,25)];
VAE.zhatMuscle2Muscle = [VAE.zhatMuscle2Muscle; NaN(bufferSize,25)];

startIdx = 1;
for trial = 1:length(trial_data)
    trial_data(trial).zhatMuscle2Hand_spikes = VAE.zhatMuscle2Hand(startIdx:startIdx+trial_data(trial).idx_trial_end-1,:);
    trial_data(trial).zhatMuscle2Joints_spikes = VAE.zhatMuscle2Joints(startIdx:startIdx+trial_data(trial).idx_trial_end-1,:);
    trial_data(trial).zhatMuscle2Muscle_spikes = VAE.zhatMuscle2Muscle(startIdx:startIdx+trial_data(trial).idx_trial_end-1,:);

    startIdx = startIdx + size(trial_data(trial).zhatMuscle2Muscle_spikes,1);
end

end