A = mean(sdum)>maxp;
T = table();
T.OnesLength = diff(find([0;A(:);0]==0))-1;
T(T.OnesLength==0,:) = []; 
% Index of 1st '1' in each group of consecutive 1s
T.OnesStart = find(diff([0;A(:)])==1);
% Index of last '1' in each group of consecutive 1s
T.OnesStop = T.OnesStart + T.OnesLength - 1; 
% Determine the number of 0s between consecutive 1s
ZerosBetween = [T.OnesStart(2:end) - T.OnesStop(1:end-1); NaN]-1;
disp(T)
    OnesLength    OnesStart    OnesStop
    __________    _________    ________

        3             4            6   
        3             9           11   
        6            18           23   
        2            29           30   
        1            32           32   
        2            34           35   
        1            37           37   
        4            42           45   
% join groups of consecutive 1s with less than n zeros between. 
n = 3; 
joinGroups = ZerosBetween < n;
t = find(diff([0;joinGroups])==1);
f = find(diff([0;joinGroups])==-1);
T.remove = false(height(T),1); 
for i = 1:numel(t)
    T.OnesStop(t(i)) = T.OnesStop(f(i));
    T.OnesLength(t(i)) = sum(T.OnesLength(t(i):f(i))) + sum(ZerosBetween(t(i):f(i)-1));  
    T.remove(t(i)+1:f(i)) = true; 
end
T(T.remove,:) = []; 
T.remove = [];
disp(T)