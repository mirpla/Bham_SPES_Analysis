function [R,P] = SUAScatters(DUAs,allpkss,sildurs,subvecs, neurvecs,alllocs)
% normidflag = [];
% while isempty(normidflag)
%     normid = input('Do you want to Normalize per subject (s) or neuron (n) or not at all (~)?','s');
%     if normid == 's'
%         disp('Values will be normalized per subject')
%         normidflag = 1;
%     elseif normid == '~'
%         disp('Natural Values will be used')
%         normidflag = 0;
%     elseif normid == 'n'
%         disp('Values will be normalized per Neuron')
%         normidflag = 2;
%     else
%         disp('Please give either a ''s'', a ''n'', or a ''~'' as input')        
%     end
% end
% 
% logidflag = [];
% while isempty(logidflag)
%     logid = input('Do you want to use a Log transform? (y,n)','s');
%     if logid == 'y'
%         disp('Values will be log10 transformed')
%         logidflag = 1;
%     elseif logid == 'n'
%         disp('Natural Values will be used')
%         logidflag = 0;
%     else
%         disp('Please give either a ''y'' or a ''n'' as input')
%     end
% end
logidflag = 0;
normidflag = 2;
while size(alllocs,2)<size(sildurs,2)
    alllocs(end+1) = 0;
end
% normalize per neuron instead of per subject
%% Calculate all Variables
c = [255,255,204;161,218,180;65,182,196;44,127,184;37,52,148];
maxdist = 100;

clear DistVec
DistVec = [];
for xidx = 1:size(DUAs,2)
    if DUAs{xidx}.dist < maxdist
        DistVec(xidx) = [DUAs{xidx}.dist];
    end
end


%% Calculate the Variables
corrx = [];
corrpky = [];
corrsily = [];
corrlocy = [];
dumn = 1;
for nvid = 1:length(DistVec)
    if dumn < length(neurvecs)
        if nvid == neurvecs(dumn+1)
            dumn = dumn+1;
        end
    end
    neurvecdum(nvid) = dumn;
end
for x = 1:size(alllocs,2)
    if DistVec(x) ~= 0
        subjidx = subvecs(x);
        neuridx = neurvecdum(x);
        if normidflag == 1
            snsil   = nanmean(sildurs(subvecs==subjidx & sildurs>0));
            snssil  = nanstd(sildurs(subvecs==subjidx & sildurs>0));
            normsil(x)  = (sildurs(x)-snsil)/snssil;
            
            ap   = nanmean(allpkss(subvecs==subjidx & allpkss>0));
            aps  = nanstd(allpkss(subvecs==subjidx & allpkss>0));
            apsn(x)  = (allpkss(x)-ap)/aps;
            
            al   = nanmean(allpkss(subvecs==subjidx & allpkss>0));
            als  = nanstd(allpkss(subvecs==subjidx & allpkss>0));
            alsn(x)  = (alllocs(x)-al)/als;
            
            corrsily = [corrsily, normsil(x)];
            corrpky = [corrpky, apsn(x)];
            corrlocy = [corrlocy, alsn(x)];
        elseif normidflag == 2
            snsil   = nanmean(sildurs(neurvecdum==neuridx & sildurs>0));
            snssil  = nanstd(sildurs(neurvecdum==neuridx & sildurs>0));
            normsil(x)  = (sildurs(x)-snsil)/snssil;
            
            ap   = nanmean(allpkss(neurvecdum==neuridx & allpkss>0));
            aps  = nanstd(allpkss(neurvecdum==neuridx & allpkss>0));
            apsn(x)  = (allpkss(x)-ap)/aps;
            
            al   = nanmean(alllocs(neurvecdum==neuridx & alllocs>0));
            als  = nanstd(alllocs(neurvecdum==neuridx & alllocs>0));
            alsn(x)  = (alllocs(x)-al)/als;
            
            corrsily = [corrsily, normsil(x)];
            corrpky = [corrpky, apsn(x)];
            corrlocy = [corrlocy, alsn(x)];
        else
            normsil(x)  = sildurs(x);
            apsn(x)  = allpkss(x);
            alsn(x)  = alllocs(x);
            
            corrsily    = [corrsily, normsil(x)];
            corrpky     = [corrpky, apsn(x)];
            corrlocy    = [corrlocy, alsn(x)];
        end
        corrx = [corrx, DistVec(x)];
    end
end

corrsily = corrsily(corrsily>0);
corrpky = corrpky(corrpky>0);
corrlocy = corrlocy(corrlocy>0);

if  logidflag == 1
    corrsilyl    = log10(corrsily);
    corrpkyl     = log10(corrpky);
    corrlocyl    = log10(corrlocy);
end

fig = figure('units','normalized','outerposition',[0 0 1 1]);
til = tiledlayout(fig, 'flow');

%%
nexttile
hold on

% Scatter plot
b1 = scatter(corrx(corrsily~=0),corrsily(corrsily~=0), [], c(3,:)/256, 'MarkerFaceColor', c(3,:)/256);
title(['Peak Height depending on Distance'])
xlabel('Distance in mm')
ylabel('Peak Height')

% Check if log scaling is needed
if logidflag == 1
    set(gca, 'YScale', 'log')
end 

xlim([0,maxdist])

% Fit a linear regression line
xFiltered = corrx(corrsily~=0);  % Filter corrx to match the length of corrpky
yFiltered = corrsily(corrsily~=0);
coefficients = polyfit(xFiltered, yFiltered, 1);
xFit = linspace(0, maxdist, 100);
yFit = polyval(coefficients, xFit);

% Plot the line
plot(xFit, yFit, 'r-', 'LineWidth', 2);

% Compute the standard error of the estimate
X = [ones(length(xFiltered), 1) xFiltered'];  % Use filtered corrx
[b, bint, r, rint, stats] = regress(yFiltered', X);
se = sqrt(stats(4));

% Compute the upper and lower bounds of the confidence interval
ci = tinv([0.025 0.975], length(yFiltered')-2);
yFitUpper = yFit + ci(2)*se;
yFitLower = yFit - ci(2)*se;

% Plot the shaded area representing the confidence interval
fill([xFit fliplr(xFit)], [yFitUpper fliplr(yFitLower)], 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

hold off

%%
nexttile    
hold on
% Scatter plot
b2 = scatter(corrx(corrpky~=0), corrpky(corrpky~=0), [], c(3,:)/256, 'MarkerFaceColor', c(3,:)/256);
title(['Peak Height depending on Distance'])
xlabel('Distance in mm')
ylabel('Peak Height')

% Check if log scaling is needed
if logidflag == 1
    set(gca, 'YScale', 'log')
end 

xlim([0,maxdist])

% Fit a linear regression line
xFiltered = corrx(corrpky~=0);  % Filter corrx to match the length of corrpky
yFiltered = corrpky(corrpky~=0);
coefficients = polyfit(xFiltered, yFiltered, 1);
xFit = linspace(0, maxdist, 100);
yFit = polyval(coefficients, xFit);

% Plot the line
plot(xFit, yFit, 'r-', 'LineWidth', 2);

% Compute the standard error of the estimate
X = [ones(length(xFiltered), 1) xFiltered'];  % Use filtered corrx
[b, bint, r, rint, stats] = regress(yFiltered', X);
se = sqrt(stats(4));

% Compute the upper and lower bounds of the confidence interval
ci = tinv([0.025 0.975], length(yFiltered')-2);
yFitUpper = yFit + ci(2)*se;
yFitLower = yFit - ci(2)*se;

% Plot the shaded area representing the confidence interval
fill([xFit fliplr(xFit)], [yFitUpper fliplr(yFitLower)], 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
hold off
%%
nexttile
hold on

% Scatter plot
b3 = scatter(corrx(corrlocy~=0), corrlocy(corrlocy~=0), [], c(3,:)/256, 'MarkerFaceColor', c(3,:)/256);
title(['Peak Height depending on Distance'])
xlabel('Distance in mm')
ylabel('Peak Height')

% Check if log scaling is needed
if logidflag == 1
    set(gca, 'YScale', 'log')
end 

xlim([0,maxdist])

% Fit a linear regression line
xFiltered = corrx(corrlocy~=0);  % Filter corrx to match the length of corrpky
yFiltered = corrlocy(corrlocy~=0);
coefficients = polyfit(xFiltered, yFiltered, 1);
xFit = linspace(0, maxdist, 100);
yFit = polyval(coefficients, xFit);

% Plot the line
plot(xFit, yFit, 'r-', 'LineWidth', 2);

% Compute the standard error of the estimate
X = [ones(length(xFiltered), 1) xFiltered'];  % Use filtered corrx
[b, bint, r, rint, stats] = regress(yFiltered', X);
se = sqrt(stats(4));

% Compute the upper and lower bounds of the confidence interval
ci = tinv([0.025 0.975], length(yFiltered')-2);
yFitUpper = yFit + ci(2)*se;
yFitLower = yFit - ci(2)*se;

% Plot the shaded area representing the confidence interval
fill([xFit fliplr(xFit)], [yFitUpper fliplr(yFitLower)], 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

hold off

%%
if logidflag == 1
    [R{1},P{1}] = corrcoef(corrsilyl(~isinf(corrsilyl)),corrx(~isinf(corrsilyl)),'Rows','pairwise');
    [R{2},P{2}] = corrcoef(corrpkyl(~isinf(corrsilyl)),corrx(~isinf(corrsilyl)),'Rows','pairwise');
    [R{3},P{3}] = corrcoef(corrlocyl(~isinf(corrsilyl)),corrx(~isinf(corrsilyl)),'Rows','pairwise');
else
    [R{1},P{1}] = corrcoef(corrsily(corrsily>0),corrx(corrsily>0),'Rows','pairwise');
    [R{2},P{2}] = corrcoef(corrpky(corrpky>0),corrx(corrpky>0),'Rows','pairwise');
    [R{3},P{3}] = corrcoef(corrlocy(corrlocy>0),corrx(corrlocy>0),'Rows','pairwise');
end

end 