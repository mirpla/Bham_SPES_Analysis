dum = StimSiteInfo 
clear StimSiteInfo
for i = 1:length(dum.TrialLabels)
    for j = 1:2
    StimSiteInfo.TrialLabels{j,i} = char([dum.TrialLabels(j,i)]);
    end 
end

StimSiteInfo.Indices = dum.Indices;

for i = 1:length(dum.Labels)
     StimSiteInfo.Labels{1,i} = char([dum.Labels(1,i)]);
end 