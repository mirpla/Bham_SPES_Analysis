for sub = [1,3,4] 
    figure;
    hist(cell2mat(cellfun(@(x)x(:),faketval{sub}(:),'un',0)),50)
end 

