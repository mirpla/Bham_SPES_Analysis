function [SUAmERP, Chanlist] = SelectResponseMd(SUAnERP, param)

resttrialsize   =   round(2*param.trlsize*param.fs+1);
cl = param.clsize;

for u = 1:size(SUAnERP,2)
    for k = 1:size(SUAnERP{1,u}.trial',1)
        if isempty(SUAnERP{1,u}.trial{1,k})
            SUAnERP{1,u}.trial{1,k} = zeros(1,resttrialsize);
        elseif any(isnan(SUAnERP{1,u}.trial{1,k}))
            SUAnERP{1,u}.trial{1,k} = zeros(1,resttrialsize);
        end        
    end
end

SUAmERP = zeros(size(SUAnERP,2),size(SUAnERP{1,1}.trial{1,1},2));

for unit = 1:size(SUAnERP,2)
    dum = cell2mat(SUAnERP{1,unit}.trial');
    disp(SUAnERP{1,unit}.label)
%     fbase = mean(mean(dum(:,1000:2500)));    
%     fstim = mean(dum(:,3000:4500));
%     plot(1-(fstim./fbase))   
    sdum = dum(:,param.stimwin);
    
    maxp = prctile(mean(dum(:,param.bswin)),param.maxpercentile);
    minp = prctile(mean(dum(:,param.bswin)),param.minpercentile);
    
    perP = mean(sdum)>maxp;
    perT = mean(sdum)<minp;
    maxClust = diff(find([0;perP(:);0]==0))-1;
    minClust = diff(find([0;perT(:);0]==0))-1;
    if max(maxClust)>cl || max(minClust)>cl
        
        SE = std(sdum)/sqrt(size(dum,1));
        pvarp = 0;
        if max(maxClust)>cl
            maxClust(maxClust==0,:) = [];
            clustidx = maxClust==max(maxClust);
            startp = find(diff([0;perP(:)])==1);
            endp = startp(clustidx) + maxClust(clustidx);           
            SEp = max(SE(startp:endp));
            SEpidx = find(SE(startp:endp) == SEp,1);
            datSE = mean(sdum(:,startp:endp));
            datSEp = datSE(SEpidx);
            pvarp = SEp/datSEp;
        end
        
        mvarp = 0;
        if max(minClust)>cl
            minClust(minClust==0,:) = [];
            clustidx = minClust==max(minClust);
            startp = find(diff([0;perT(:)])==1);
            endp = startp(clustidx) + maxClust(clustidx);
            SEm = min(SE(startp:endp));
            SEidx = find(SE(startp:endp) == SEm,1);
            datSE = mean(sdum(:,startp:endp));
            datSEm = datSE(SEidx);
            mvarp = SEm/datSEm;
        end
        
        Chanlist(unit,1) = 1;
        
%         dumt = cell2mat(SUAnERP{1,unit}.time');
%         figure
%         shadedErrorBar(dumt(1,param.stimwin),mean(sdum),SE)
%         hold on
%         yline(maxp)
%         yline(minp)
%         title([num2str(max(diff(find([0;perP(:);0]==0))-1)),'___',num2str(max(diff(find([0;perT(:);0]==0))-1)),'___',num2str(SEp),'/',num2str(pvarp),'/',num2str(mvarp)])
%         hold off
%         close all
    else
        Chanlist(unit,1) = 0;
    end
    
    SUAmERP(unit,:) = mean(cell2mat(SUAnERP{1,unit}.trial'));
end