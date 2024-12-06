function [SUAnERP,w] = SUAnalysis_w(SUA, Basepath, direction, condit, p,param)
% p = 1 for Rasters
x = 1;
wc = 1;
w=[];
for subjidx = 1:length(SUA.Conditions)
    for ses = 1:length(SUA.Conditions{1,subjidx})
        trlilabel = SUA.stimsite{1,subjidx}{1,ses};
        for chan = 1:length(SUA.Conditions{1,subjidx}{1,ses})%SUA.AllChan{1, subjidx}{1, ses}{1,cc}
            if ~isempty(SUA.Conditions{1,subjidx}{1,ses}{1,chan})
                for su = 1:length(SUA.Conditions{1,subjidx}{1,ses}{1,chan})
                    DOI  = SUA.Conditions{1,subjidx}{1,ses}{1,chan}{1,su};
                    cc = 4;
                    
                    param.trlsize   = round(DOI{1,cc}.trialtime(1,2));
                    
                    [~,SUAnERPLocal] = SUA_ConvIn(DOI{1,cc},param);
                    %SUAERP = SUA_ERP(SUA.Conditions{1,1}{1,1}{1,6}{1,3}{1,1},param)
                    SUAnERPLocal.label{1,1}(1:4) = [];
                    SUAnERPLocal.label{1,1} = [num2str(subjidx),'s',num2str(ses),'c',num2str(chan),'u',num2str(su),SUAnERPLocal.label{1,1}];
                    
                    SUAnERP{x} = SUAnERPLocal;
                    mtrL = mean(cell2mat(SUAnERPLocal.trial'),'omitnan');
                    if p == 1
                        try
                        figure('units','normalized','outerposition',[0 0 0.5 1])
                        hold on
                        
                        subplot(4,1,1:3)
                        RasterFromScratchSUA(DOI{1,cc},condit{subjidx,ses,cc},1, trlilabel);
                        title(['Subject',num2str(subjidx),'Session',num2str(ses),'Chan',num2str(chan),'Unit',num2str(su)])
                        
                        subplot(4,1,4)
                        
                        %plot(SUAERP.time{1,1},SUAERP.trial{1,1})
                        plot(SUAnERPLocal.time{1,1}(2000:end-2000),mtrL(2000:end-2000),'k');
                        set(gca, 'XLimSpec', 'Tight');
                        
                        saveas(gcf, [Basepath,'\Mircea\Datasaves\FIGS\wSUA\',num2str(subjidx),'s',num2str(ses),'c',num2str(chan),'u',num2str(su), '.jpg']);
                        
                        catch
                            w{wc} = warning(['Problem with unit ',num2str(subjidx), '/',num2str(ses),'/',num2str(chan),'/',num2str(su),'/']);
                            wc = wc+1;
                        end
                    end
                    x = x + 1;
                end
            end
            close all
        end
    end
end
