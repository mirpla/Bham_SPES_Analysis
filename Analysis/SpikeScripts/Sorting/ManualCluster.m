function ManualCluster(Basepath, subjID, direction)

k = input('What Subject do you want to analyze');
z = input('What Session do you want to start from');
x = input('What channel do you want to start from');


Direct = [Basepath, 'Mircea/3 - SPES/Spike/', subjID{k},'/'];
for m = z:length(dir(Direct))-2
    NewDirect =  [Basepath,'Mircea/3 - SPES/Spike/', subjID{k},'/ses-',num2str(m),'/',direction,'/'];
    NewDirecty = accumarray(ones(length(NewDirect),1),[1:length(NewDirect)]',[],@(x){[NewDirect(x)]});
    cd(NewDirecty{1})
    
    channame = dir('times_*.mat');
    
    for chan = x:size(channame,1)
        disp(chan)
        wave_clus(channame(chan).name);
        pause
        checkchannel(chan)
        
        inp = 'a';
        inp = input('Re-open waveclus? (y/n)', 's');
        while inp ~= 'y' && inp ~= 'n'
            inp = input('Re-open waveclus? (y/n)', 's');
        end
        
        if inp=='y'
            wave_clus(channame(chan).name)
            pause
            checkchannel(chan)
            pause
        elseif inp=='n'
            continue
        end
    end
end
end