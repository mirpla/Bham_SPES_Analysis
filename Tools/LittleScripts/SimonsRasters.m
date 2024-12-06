DOIdum  = SUA.Conditions{1,subjidx}{1,ses}{1,chan}{1,su};
cfg = [];
cfg.trl = 
ft_selectdata(SUA.Conditions
cc = 8;
%                     if contains(DOI{1,1}.label{1,1},'ant')
%                         cc = 1;
%                     elseif contains(DOI{1,1}.label{1,1},'mid')
%                         cc = 2;
%                     elseif contains(DOI{1,1}.label{1,1},'post')
%                         cc = 3;
%                     end

param.trlsize   = round(DOI{1,cc}.trialtime(1,2));
param.convol    = 200;
[~,SUAnERPLocal] = SUA_Conv(DOI{1,cc},param);
%SUAERP = SUA_ERP(SUA.Conditions{1,1}{1,1}{1,6}{1,3}{1,1},param)
SUAnERPLocal.label{1,1}(1:4) = [];
SUAnERPLocal.label{1,1} = [num2str(subjidx),'s',num2str(ses),'c',num2str(chan),'u',num2str(su),SUAnERPLocal.label{1,1}];

param.trlsize   = round(DOI{1,7}.trialtime(1,2));
param.convol    = 200;
[~,SUAnERPDistal] = SUA_Conv(DOI{1,7},param);
SUAnERPDistal.label{1,1}(1:4) = [];
SUAnERPDistal.label{1,1} = [num2str(subjidx),'s',num2str(ses),'c',num2str(chan),'u',num2str(su),SUAnERPDistal.label{1,1}];

SUAnERP{1,1}{x} = SUAnERPLocal;
SUAnERP{1,2}{x} = SUAnERPDistal;

figure('units','normalized','outerposition',[0 0 0.5 1])
hold on

subplot(4,1,1:3)
RasterFromScratchSUA(DOI{1,cc},condit{subjidx,ses,cc},1, trlilabel);
title(['Subject',num2str(subjidx),'Session',num2str(ses),'Chan',num2str(chan),'Unit',num2str(su)])

subplot(4,1,4)

%plot(SUAERP.time{1,1},SUAERP.trial{1,1})
plot(SUAnERPLocal.time{1,1}(2000:end-2000),SUAnERPLocal.trial{1,1}(2000:end-2000),'k');
set(gca, 'XLimSpec', 'Tight');