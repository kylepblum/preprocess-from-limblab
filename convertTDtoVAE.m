function vae_data = convertTDtoVAE(trial_data,params)
pos = [];
vel = [];
force = [];
jointPos = [];
jointVel = [];
emg = [];
musclePos = [];
muscleVel = [];
spindles = [];

for trial = 1:length(trial_data)
    pos = [pos; trial_data(trial).pos];
    vel = [vel; trial_data(trial).vel];
    force = [force; trial_data(trial).force(:,1:3)];
    jointPos = [jointPos; trial_data(trial).joint_ang];
    jointVel = [jointVel; trial_data(trial).joint_vel];
    emg = [emg; trial_data(trial).emg];
    musclePos = [musclePos; trial_data(trial).musLenRel];
    muscleVel = [muscleVel; trial_data(trial).musVelRel];
    spindles = [spindles; trial_data(trial).spindles];
   
end

vae_data = [pos vel force jointPos jointVel emg musclePos muscleVel spindles];
      
end