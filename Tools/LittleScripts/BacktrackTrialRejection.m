%% Find Rejected Trials if Visual was used (long first)
A = AllMacro.Session{1,7}.cfg.previous.trlold
B = AllMacro.Session{1,7}.cfg.previous.trl 

[~,X] = setdiff(A,B);
X = sort(X);
R = A(X,:)
%% Find if Summary was used
 
 
 A =  AllMacro.Session{1,8}.cfg.trials; %use previous until you find the necessary cfg
 B = [1:179]; %Original Length
setdiff(B',A')
