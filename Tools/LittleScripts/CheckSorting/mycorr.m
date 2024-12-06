function [corr, maxvalue]=mycorr(times1, times2, resolution, maxlag, minlag)
% function [corr, maxvalue]=mycorr(times1, times2, resolution, maxlag, minlag)
% alle times und die maxlags und minlags sollten in der gleichen Zeiteinheit sein
% für Autokorrelogramm: times1 = times2
% maxlag = bis zu welchem maximalen lag (Betrag) wird das korrelogramm erzeugt
% minlag = soll ein Bereich um das lag Null nicht beruecksichtigt werden?
% resolution = binbreite
% z.B. [corr, maxvalue]=mycorr(cluster_class(:,2)', cluster_class(:,2)', 2, 100, 0.1);

% Johannes' alter Python-Code: 
% table = tile(times1, [len(times2), 1])-times2.reshape((len(times2), -1))
% return table[(abs(table) > .01) & (abs(table) <= lag)]

if nargin<5,
    minlag=0.1; %in ms
end
if nargin<4,
    maxlag=100; %in ms
end
if nargin<3,
    resolution=1; %in ms
end

% % Zeilenvektoren:
% if size(times1,1) > size(times1,2)
%     times1 = times1';
% end
% if size(times2,1) > size(times2,2)
%     times2 = times2';
% end

% erzeuge Matrix mit den Differenzen: Zeitpunkte 1 - Zeitpunkte 2
%table = repmat(times1, length(times2), 1) - repmat(times2',1,length(times1));  

numv1=length(times1);
numv2=length(times2);
%table=zeros(1,floor(numv1*numv2));
thresh=maxlag+resolution/2; %damit das Randbin nicht nur halb voll ist
index=0;
for i=1:numv1
    for j=1:numv2
        if abs(times2(j)-times1(i))<=thresh,
            index=index+1;
            table(index)=times2(j)-times1(i);
            if(table(index)<0)
                table(index)=table(index)+0.000001; %mit diesem bloeden Trick wird Matlabs Fehler in der Hist-Funktion kompensiert, und die autokorrelogramme werden wieder symmetrisch
            end
        end
    end
end


% behalte davon nur jene, die lags im Intervall -maxlag bis maxlag liegen
% und evtl. (wenn minlag > 0) auch nur jene lags > minlag anzeigen
%table = table((abs(table) <= thresh));
if index>0
    [maxvalue xbin]=max(hist(table, -maxlag:resolution:maxlag));
else
    maxvalue=0;
end
% if xbin~=floor(maxlag/resolution)+1,  %auskommentiert, da nur fuer autokorrelogramme, nicht aber fuer kreuzkorrelogramme sinnvoll
%     warning('Maximum des Autokorrelogramms nicht bei Null!');
% end
if index>0
    table = table((abs(table) > minlag));
    corr=hist(table, -maxlag:resolution:maxlag);
else
    corr(1:(2*maxlag/resolution)+1)=0;
end
end
