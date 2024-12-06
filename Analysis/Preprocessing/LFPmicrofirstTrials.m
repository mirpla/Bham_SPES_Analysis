%%


if exist('cfg_del', 'var')
    cfg = [];
    cfg = cfg_del;   
    cfg.viewmode = 'vertical';
    cfg_del = ft_databrowser(cfg, CSCdatNF);
else
    cfg = [];
    cfg.viewmode = 'vertical';
    cfg_del =  ft_databrowser(cfg, CSCdatNF);
    
    filnam = sprintf('cfg_del%s', subjID);
    save([DataLocationMC, filnam], 'cfg_del');
end



%% creation of temporary trials to look for peaks in

temptrl = [cfg_del.artfctdef.visual.artifact(:,1), cfg_del.artfctdef.visual.artifact(:,2)+50, zeros(length(cfg_del.artfctdef.visual.artifact),1)]; %trialmatrix

cfg = [];
cfg.continuous = 'yes';
cfg.trl = temptrl;
[dumCSC] = ft_redefinetrial( cfg, CSCdatNF); % creation of dummy variable defined according to above trl

%pk = zeros(length(CSCdatNF.label), length(cfg_del.artfctdef.visual.artifact));
%locations = zeros(length(CSCdatNF.label), length(cfg_del.artfctdef.visual.artifact));
for i=1:length(cfg_del.artfctdef.visual.artifact);
    dumCSC.trial{1,i} = abs(cell2mat(dumCSC.trial(1,i)));
    for j = 1:length(CSCdatNF.label) % find peak individually for each channel
        [pk, locations] = findpeaks(dumCSC.trial{1,i}(j,:), 'SortStr', 'descend');
        if isempty(pk)
            pkmicro(j,i) = 0 ;
            locationsmicro(j,i) = 0;
        else
            pkmicro(j,i) = pk(1,1);
            locationsmicro(j,i) = locations(1,1);
        end
        
    end
end


%% create a trialsmatrix that is fieldtrip compatible

Fs = 32e3;
pre = Fs*3;
post = Fs*3;
newtrl = [];
for it = 1:size(temptrl,1);
    locationsNozero = locationsmicro(locationsmicro(:,it)>100,it);
    if isempty(locationsNozero)
        locationsNozero = 0; 
    end 
    LocMed = mode(locationsNozero)-1;
    
    newtrl(it,:) = [temptrl(it,1)+LocMed-(pre) temptrl(it,1)+LocMed+(post) (-pre)];
end;

filnam = sprintf('%s_PeakLoc', subjID);

% cfg = [];
% cfg.continuous = 'yes';
% cfg.trl = newtrl;
% [dumCSC2] = ft_redefinetrial(cfg, CSCdatNF); % creation of dummy variable defined according to above trl
% cfg = [];
% cfg.viewmode = 'vertical';
% ft_databrowser(cfg, dumCSC2);

save([DataLocationMC, filnam], 'temptrl', 'pkmicro', 'locationsmicro', 'newtrl');

%% free up space
clear redCSCdat
clear dumCSC
clear newdumCSC
clear CSCdatintLinpre
clear CSCdatintLin
clear CSCdatNF