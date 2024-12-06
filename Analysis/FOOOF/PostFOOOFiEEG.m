function [aperiodicparameters, perpamlong] = PostFOOOFiEEG(Basepath,M)
Vers{1}     = 'Micro';
Vers{2}     = 'MacroC';
Vers{3}     = 'MacroH';
Savepath = [Basepath,'Mircea\Datasaves\FOOOF\',Vers{M},'\'];
AllBand = {'Theta','Alpha'};
for AB = 1:2;
    Band = AllBand{AB};
    
    % Load the fooof-formated json file, saved out from Python
    fooofR{1,1} = load_fooof_results([Savepath,'fooof_resultsPreLAll.json']);
    fooofR{2,1} = load_fooof_results([Savepath,'fooof_resultsPostLAll.json']);
    
%     fooofR{1,2} = load_fooof_results([Savepath,'fooof_resultsPreHAll.json']);
%     fooofR{2,2} = load_fooof_results([Savepath,'fooof_resultsPostHAll.json']);
    load([Savepath,'periodicparametersL.mat'])
    load([Savepath,'aperiodicparametersL.mat'])
    col{1}= 'b';
    col{2} = 'r';
    col{3} = 'g';
    col{4} = 'k';
    
    if strcmp(Band,'Theta')
        fBand = [3,7];
    elseif strcmp(Band,'Alpha')
        fBand = [7,13];
    end
    
    %% Periodic Parmeters:
    %4 cells prelocal, predistal, postlocal, postdistal
    % each Centre Frequency, Power, BW,Subj
    perpamshort = periodicparameters;
    for x = 1:4
        y = 2;
        cntr = size(perpamshort{x},1);
        while y <= cntr
            if perpamshort{x}(y,1) > fBand(2)
                perpamshort{x}(y,:) = [];
                cntr = cntr-1;
            elseif perpamshort{x}(y,1) < fBand(1)
                perpamshort{x}(y,:) = [];
                cntr = cntr-1;
            elseif perpamshort{x}(y,4) == perpamshort{x}(y-1,4)
                if perpamshort{x}(y,2) > perpamshort{x}(y-1,4)
                    perpamshort{x}(y-1,:) = [];
                else
                    perpamshort{x}(y,:) = [];
                end
                cntr = cntr-1;
                
            else
                y = y+1;
            end
        end
        perpamshort{x}(:,4) = perpamshort{x}(:,4) +1;
        perpamlong{AB,x} = perpamshort{x};
        for z = 1:length(fooofR{1,1})
            if length(perpamlong{AB,x})<z
                perpamlong{AB,x} = [perpamlong{AB,x}; NaN,NaN,NaN,z];
            end
            diff = perpamlong{AB,x}(z,4)-z;
            if diff > 0
                perpamlong{AB,x} = [perpamlong{AB,x}(1:z-1,:); [NaN,NaN,NaN,z]; perpamlong{AB,x}(z:end,:)];
            end
        end
    end
    Per = [];
    Per = [perpamlong{AB,1}(:,2),perpamlong{AB,2}(:,2),perpamlong{AB,3}(:,2),perpamlong{AB,4}(:,2)];            
    Periodic = array2table(horzcat(Per));
    Periodic.Properties.VariableNames(1:4) = {'PreLocal','PreDistal','PostLocal','PostDistal'};
    writetable(Periodic,[Savepath,sprintf('PeriodicPreL%s.csv',AllBand{AB})]) 
end
%% Aperiodic parameters:
%preLocal/PreDistal/PostLocal/PostDistal x subj x offset1/exponent2
AE = [];
AO = [];
AP = [];
% if M == 1
    for x = 1:4
        AO(:,x) = [aperiodicparameters(x,:,1)'];
        AE(:,x) = [aperiodicparameters(x,:,2)'];
    end
    
    AP = array2table([AO,AE]);
    AP.Properties.VariableNames = {'OfLocalPre','OfDistalPre','OfLocalPost','OfDistalPost','ExpLocalPre','ExpDistalPre','ExpLocalPost','ExpDistalPost'};
    writetable(AP,[Savepath,'aperiodicparamtersL.csv'])
% else
%     cntr = 1;
%     for x = [1,3]
%         AOpre(:,cntr) = [aperiodicparameters{1,x}(:,1)'];
%         AEpre(:,cntr) = [aperiodicparameters{1,x}(:,2)'];
%         cntr = cntr+1;
%     end
%     cntr = 1;
%     for x = [2,4]
%         AOpost(:,cntr) = [aperiodicparameters{1,x}(:,1)'];
%         AEpost(:,cntr) = [aperiodicparameters{1,x}(:,2)'];
%         cntr = cntr+1;
%     end
%     APpre = array2table([AOpre,AEpre]);
%     APpost = array2table([AOpost,AEpost]);
%     APpre.Properties.VariableNames = {'OfLocalPre','OfDistalPre','ExpLocalPre','ExpDistalPre'};
%     APpost.Properties.VariableNames = {'OfLocalPost','OfDistalPost','ExpLocalPost','ExpDistalPost'};
%     writetable(APpre, [Savepath,'aperiodicparamtersLpre.csv'])
%     writetable(APpost,[Savepath,'aperiodicparamtersLpost.csv'])
end