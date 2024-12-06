function [ChanlistSel] = ChanlistConversion(Chanlist, SUAnERP)

for c = 1:length(SUAnERP)
    ChanlistTable(c,:) = cell2table(regexp(SUAnERP{1,c}.label{1,1},'\d*','Match'),'VariableNames',{'Subject' 'Session' 'Channel' 'Unit' 'Wire'});
end

for m = [1,2,3,4]
    %ChanlistMat(:,n) = str2num([vertcat(ChanlistTable{:,m}{:,1})]);
    ChanlistMat(:,m) = cell2mat(cellfun(@str2num,ChanlistTable{:,m}(:,1),'un',0));
end

ChanlistSel = ChanlistMat(find(Chanlist),:);
end