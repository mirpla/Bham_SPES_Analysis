%% Experimental Correct
writematrix(cell2mat(arrayfun(@(c) horzcat(OutputRep{c,1}(:,3)), (subAr), 'UniformOutput', false)),'ExperimentalCorrect.csv')

%% Control Correct
writematrix(cell2mat(arrayfun(@(c) horzcat(OutputRep{c,2}(:,3)), (subAr), 'UniformOutput', false)),'ControlCorrect.csv')

%% Experimental Phasediff Values
writematrix(cell2mat(arrayfun(@(c) horzcat(OutputRep{c,1}(:,5)), (subAr), 'UniformOutput', false)),'ExperimentalPhase.csv')

%% Control Phasediff Values
writematrix(cell2mat(arrayfun(@(c) horzcat(OutputRep{c,2}(:,5)), (subAr), 'UniformOutput', false)),'ControlPhase.csv')
