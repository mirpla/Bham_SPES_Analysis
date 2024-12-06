%% Figures
%% Macro Artefact 
plot(ICtrials.time{1,2}(1,:), ICtrials.trial{1,2}(23:30,:));
ylim([-9000, 9000]);
xlim([-0.02 0.05]);
xlabel('Time in s', 'Fontsize' , 24);
ylabel('Voltage in microV','Fontsize' , 24);
title('Example of Stimulation Artefact as Recorded in an Anterior Macro-Electrode','Fontsize' , 24);
legend({'1 Hippocampal Contact', '2 Hippocampal Contact (Stimulation Site)', '3 Hippocampal Contact (Stimulation Site)', '4 White Matter Contact', '5 White Matter Contact', '6 Cortical Contact', '7 Cortical Contact', '8 Cortical Contact'}, 'Fontsize', 18)

%% Micro Artefact
plot(dumtime(1,:), dumtrial(1:8,:));
%ylim([-9000, 9000]);
xlim([-0.02 0.05]);
xlabel('Time in s', 'Fontsize' , 24);
ylabel('Voltage in microV','Fontsize' , 24);
title({'Example of Stimulation Artefact as Recorded in the Anterior Microwires', '(Artefacts recorded at same time as A)'},'Fontsize' , 24);
legend({'Wire 1', 'Wire 2', 'Wire 3', 'Wire 4', 'Wire 5', 'Wire 6', 'Wire 7', 'Wire 8'}, 'Fontsize', 20)

