function vae_data = convertTDtoVAE(trial_data,params)

vel = [];
jointVel = [];
muscleVel = [];


for trial = 1:length(trial_data)
   vel = [vel; trial_data(trial).vel];
   jointVel = [jointVel; trial_data(trial).joint_vel];
   
   if isfield(trial_data,'musVelRel')
       muscleVel = [muscleVel; trial_data(trial).musVelRel];
   elseif isfield(trial_data,'muscle_vel')
       muscleVel = [muscleVel; trial_data(trial).muscle_vel];
   end
    
    
end

vae_data = [vel jointVel muscleVel];
      
end