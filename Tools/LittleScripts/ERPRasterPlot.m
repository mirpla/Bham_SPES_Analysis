% Figure producing ERPs local vs Distal in same Coordinate system. 
% Raster of the two different conditions are plotted below

                subplot(8,1,1:4)
                ID = AllMicro.SubjID{1,1};
                Datal = eval(sprintf('CSCHippCond.%s.Conditions{1,1}', ID));
                Datad = eval(sprintf('CSCHippCond.%s.Conditions{1,7}', ID));
                
                for a = 1:length(Datal.trial)
                    ERPlocal(a,:) = [Datal.trial{a}(5,1:2980), NaN(1, 3026 - 2981),  Datal.trial{a}(5,3026:end)];
                end
                
                for a = 1:length(Datad.trial)
                    ERPdistal(a,:) = [Datad.trial{a}(5,1:2980), NaN(1, 3026 - 2981),  Datad.trial{a}(5,3026:end)];
                end
                hold on
                shadedErrorBar(Datal.time{1,1}, mean(ERPlocal,1), std(ERPlocal)/sqrt(length(Datal.trial)),'lineProps', 'b')
                
                shadedErrorBar(Datal.time{1,1}, mean(ERPdistal,1), std(ERPlocal)/sqrt(length(Datal.trial)),'lineProps', 'r')
                rectangle('Position', [-0.02,-600, 0.04, 800], 'FaceColor', 'w','EdgeColor','r')
                
                %legend(['Local Stimulation', 'Cortical Stimulation'])
                
                hold off
                xlim([-0.1 1]);
                
                
                
                subplot(8,1,5:6)
                cfg = [];
                cfg.topplotfunc = 'line';
                cfg.spikechannel = AllMicro.MUAs{1,1}.label(6);
                cfg.latency = [-0.1 1];
                cfg.plotselection = 'yes';
                cfg.errorbars = 'std';
                cfg.interactive = 'no';
                cfg.trials = TrialSelCond{1,1};
                ft_spike_plot_raster(cfg, AllMicro.MUAs{1,1});
                hold on
                x1 = -0.015;
                y1 = get(gca,'ylim');
                x2 = 0.015;
                y2 = y1;
                %plot([x1 x1],y1, 'r')
                rectangle('Position', [x1,y1(1), 0.03, 65], 'FaceColor', 'w','EdgeColor','r')
                
                subplot(8,1,7:8)
                cfg = [];
                cfg.topplotfunc = 'line';
                cfg.spikechannel = AllMicro.MUAs{1,1}.label(6);
                cfg.latency = [-0.1 1];
                cfg.plotselection = 'yes';
                cfg.errorbars = 'std';
                cfg.interactive = 'no';
                cfg.trials = TrialSelCond{1,7};
                ft_spike_plot_raster(cfg, AllMicro.MUAs{1,1});
                hold on
                x1 = -0.015;
                y1 = get(gca,'ylim');
                x2 = 0.015;
                y2 = y1;
                %plot([x1 x1],y1, 'r')
                rectangle('Position', [x1,y1(1), 0.03, y1(2)], 'FaceColor', 'w','EdgeColor','r')
                
                
%                 subplot(10,1,9:10)
%                 hold on
%                 plot(MUAeCond.P07.COnditions{1,1}.time{1,1}, MUAeCond.P07.COnditions{1,1}.trial{1,1}(6,:),'Color', 'b')
%                 plot(MUAeCond.P07.COnditions{1,1}.time{1,1}, MUAeCond.P07.COnditions{1,7}.trial{1,1}(6,:), 'Color', 'r')
%                 rectangle('Position', [-0.02,0, 0.04, 10], 'FaceColor', 'w','EdgeColor','r')                
%                 hold off
%                 xlim([-0.1 1])