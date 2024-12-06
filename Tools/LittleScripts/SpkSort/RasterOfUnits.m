function RasterOfUnits(Data, DataTime, r1, r2)
% Script to create Rasterplot of Whole Session to be able to make sanity
% check on whether Trial-Cutting was Successful

cnt = 1;
figure('units','normalized','outerposition',[0 0 1 1])
hold on
for x = 1:length(Data.label)
    uvec = find(Data.unit{1,x});
    if ~isempty(uvec)
        dataTS = Data.timestamp{1,x}(uvec);
        for it = 1:length(dataTS)
            s = Data.timestamp{1,x}(it);
            s = [s;s];                  % plot lines in horizontal
            y = cnt*ones(1,length(x)); % plot on y axis dependant on what trial is at
            y = [y-.5;y+.5];            % determine line height
            line(s,y,'Color','k');
        end
        cnt = cnt +1;
    end
    %    xlim([Data.timestamp{1,2}(round(length(Data.timestamp{1,2})*r1)),Data.timestamp{1,2}(round(length(Data.timestamp{1,2})*r2))])
end
