load('Z:\RDS\Mircea\Datasaves\Micro\P11\Ses2\P112_Base.mat', 'CSCdatNF') 
load('Z:\RDS\Mircea\Datasaves\Micro\P11\Ses2\P112_trlMatrixes.mat')

chan = 9;
trl = 10;
dur = [newMTrl(trl,1)+95950:newMTrl(trl,2)-95900];
plot([-50:1:100],CSCdatNF.trial{1,1}(chan,dur))
xticks([-32 0 32 64 96]) 
xticklabels({'-1','0','1','2','3'})
xlabel(['Time in ms'])
yticks([-3000 0 3000])
ylabel(['Current Strength in ',char(181),'V'])
ylim([-3500 3500])