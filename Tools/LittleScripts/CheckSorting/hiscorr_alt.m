
function [corr, maxvalue]=mycorr(v1, v2, limit, bins)
    limit=abs(limit);    
    bins=abs(bins);
    numv1=length(v1);
    numv2=length(v2);
    timediff=zeros(1,floor(numv1*numv2));
    
    index=0;
    for i=1:numv1
        for j=1:numv2
            index=index+1;
            timediff(index)=v2(j)-v1(i);
        end 
    end    
    
    timediff=timediff(abs(timediff) < limit);

    maxvalue=max(hist(timediff, -limit:(2*limit/(bins-1)):limit));
    
    timediff=timediff(abs(timediff) > 0.5);

    corr=hist(timediff, -limit:(2*limit/(bins-1)):limit);
end

