% Use like: h = rm_raincloud(data, colours, plot_top_to_bottom, density_type, bandwidth)
% Where 'data' is an M x N cell array of N data series and M measurements
% And 'colours' is an N x 3 array defining the colour to plot each data series
% plot_top_to_bottom: Default plots left-to-right, set to 1 to rotate.
% density_type: 'ks' (default) or 'RASH'. 'ks' uses matlab's inbuilt 'ksdensity' to
% determine the shape of the rainclouds. 'RASH' will use the 'rst_RASH'
% method from Cyril Pernet's Robust Stats toolbox, if that function is on
% your matlab path.
% bandwidth: If density_type == 'ks', determines bandwidth of density estimate
% h is a cell array containing handles of the various figure parts:
% h.p{i,j} is the handle to the density plot from data{i,j}
% h.s{i,j} is the handle to the 'raindrops' (individual datapoints) from data{i,j}
% h.m(i,j) is the handle to the single, large dot that represents mean(data{i,j})
% h.l(i,j) is the handle for the line connecting h.m(i,j) and h.m(i+1,j)

%% TO-DO:
% Patch can create colour gradients using the 'interp' option to 'FaceColor'. Allow this?

function h = rm_raincloud(data,SE, colours, plot_top_to_bottom, density_type, bandwidth,raindrop_size,mean_size, indv)
%% check dimensions of data

[n_plots_per_series, n_series] = size(data);

% make sure we have correct number of colours
assert(all(size(colours) == [n_series 3]), 'number of colors does not match number of plot series');

%% default arguments

if nargin < 3
    plot_top_to_bottom  = 0;    % left-to-right plotting by default
end

if nargin < 4
    density_type        = 'ks'; % use 'ksdensity' to create cloud shapes
end

if nargin < 5
    bandwidth           = [];   % let the function specify the bandwidth
end

%% Calculate properties of density plots

% Probably okay to hard-code this as it just determines the granularity of
% the density estimate
density_granularity = 200;

n_bins = repmat(density_granularity, n_plots_per_series, n_series);

% calculate kernel densities
for i = 1:n_plots_per_series
    for j = 1:n_series
       
        switch density_type
            
            case 'ks'
                
                % compute density using 'ksdensity'
                [ks{i, j}, x{i, j}] = ksdensity(data{i, j}, 'NumPoints', n_bins(i, j), 'bandwidth', bandwidth);
                
            case 'rash'
                
                % check for rst_RASH function (from Robust stats toolbox) in path, fail if not found 
                assert(exist('rst_RASH', 'file') == 2, 'Could not compute density using RASH method. Do you have the Robust Stats toolbox on your path?');
                
                % compute density using RASH
                [x{i, j}, ks{i, j}] = rst_RASH(data{i, j});
                
                % override default 'n_bins' as rst_RASH determines number of bins
                n_bins(i, j) = size(ks{i, j}, 2);
        end
        
        % Define the faces to connect each adjacent f(x) and the corresponding points at y = 0.
        q{i, j}     = (1:n_bins(i, j) - 1)';
        faces{i, j} = [q{i, j}, q{i, j} + 1, q{i, j} + n_bins(i, j) + 1, q{i, j} + n_bins(i, j)];
        
    end
end

% determine spacing between plots
spacing     = 3 * mean(mean(cellfun(@max, ks)));
ks_offsets  = [0:n_plots_per_series-1] .* spacing;

% flip so first plot in series is plotted on the *top*
ks_offsets  = fliplr(ks_offsets);

% calculate patch vertices from kernel density
for i = 1:n_plots_per_series
    for j = 1:n_series
        verts{i, j} = [x{i, j}', ks{i, j}' + ks_offsets(i); x{i, j}', ones(n_bins(i, j), 1) * ks_offsets(i)];
        verts{i, j} = [x{i, j}', ks{i, j}' + ks_offsets(i); x{i, j}', ones(n_bins(i, j), 1) * ks_offsets(i)];
    end
end


%% jitter for the raindrops

jit_width = spacing / 8;

for i = 1:n_plots_per_series
    for j = 1:n_series
        jit{i,j} = jit_width + rand(1, length(data{i,j})) * jit_width;
    end
end

%% means (for mean dots)

cell_means = cellfun(@mean, data);

%% plot
% note - we *could* plot everything here in one big loop, but then
% different figure parts would overlay each other in a silly way.
% faces{2,1} = faces{2,1}*-1;
% faces{2,2} = faces{2,2}*-1;

verts{2,1}(:,2) = (verts{2,1}(:,2)*-1) + ((spacing / 8) - 3)+ ks_offsets(i)-0.3;
verts{2,2}(:,2) = (verts{2,2}(:,2)*-1) + ((spacing / 8) - 3)+ ks_offsets(i)-0.3;


hold on
% patches
for i = 1:n_plots_per_series
    for j = 1:n_series       
        % plot patches
        h.p{i, j} = patch('Faces', faces{i, j}, 'Vertices', verts{i, j}, 'FaceVertexCData', colours(j, :), 'FaceColor', 'flat', 'EdgeColor', 'none', 'FaceAlpha', 0.5);
      
        if i == 2 
        % scatter rainclouds
        h.s{i, j} = scatter(data{i, j}, -jit{i, j}+ 1, 'MarkerFaceColor', colours(j, :), 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.5, 'SizeData', raindrop_size);        
        else
        h.s{i, j} = scatter(data{i, j}, -jit{i, j} + ks_offsets(i) - 1, 'MarkerFaceColor', colours(j, :), 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.5, 'SizeData', raindrop_size);        
            
        end
    end 
end

yl = get(gca, 'YLim');
for i = 1:n_plots_per_series
    for j = 1:n_series         
        quartiles   = quantile(data{i,j}, [0.25 0.75 0.5]);
        iqr         = quartiles(2) - quartiles(1);
        Xs          = sort(data{i,j});
        whiskers(1) = min(Xs(Xs > (quartiles(1) - (1.5 * iqr))));
        whiskers(2) = max(Xs(Xs < (quartiles(2) + (1.5 * iqr))));
        Y           = [quartiles whiskers];
        
        if i == 1
            posi = ks_offsets(i)-(jit_width*0.65)-(j*0.8-1);
        elseif i == 2
            % boxpos = (-yl(2) + box_dodge_amount)
            posi = ks_offsets(i)+(jit_width*0.65)-(j*0.8+1);
        end
        line_width = 2;
        
        box_pos = [Y(1) (posi - (jit_width * 0.3)) Y(2) - Y(1) (jit_width * 0.6)];
        
        % mean line
        b{4} = line([cell_means(i,j) cell_means(i,j)], [(posi - (jit_width * 0.3)) (posi + (jit_width * 0.3))], 'col', 'k', 'LineWidth', line_width);
        
        % whiskers
        b{5} = line([Y(2) Y(5)], [posi posi], 'col', 'k', 'LineWidth', line_width);
        b{6} = line([Y(1) Y(4)], [posi posi], 'col', 'k', 'LineWidth', line_width);
        
        
        SEPOS = [cell_means(i,j)-SE{i,j} box_pos(2) SE{i,j}*2 box_pos(4)];
        b{8} = rectangle('Position', SEPOS);
        set(b{8}, 'EdgeColor', [1 1 1])
        set(b{8}, 'FaceColor', [1 1 1]);

       
        b{7} = rectangle('Position', SEPOS);
        set(b{7}, 'EdgeColor', 'k')
        set(b{7}, 'LineWidth', line_width);
        set(b{7}, 'FaceColor', [colours(j,:),0.5]);
        set(b{7}, 'EdgeColor', [0 0 0]);

       
        
        % 'box' of 'boxplot'
        b{3} = rectangle('Position', box_pos);
        set(b{3}, 'EdgeColor', 'k')
        set(b{3}, 'LineWidth', line_width);
             
        uistack(b{4},'top')
    end
end
%%
% plot mean lines
for i = 1:n_plots_per_series - 1 % We have n_plots_per_series-1 lines because lines connect pairs of points
    for j = 1:n_series
        posi = [ks_offsets(i)-(jit_width*0.65)-(j*0.8-1) ks_offsets(i+1)-(jit_width*0.65)-(j*0.8-0.2)];
        h.l(i, j) = line(cell_means([i i+1], j), posi, 'LineWidth', line_width*2, 'Color', [colours(j, :),0.6]);        
        uistack( h.l(i, j),'bottom')
        if indv == 1
            h.li{i,j} = line([h.s{i,j}.XData;h.s{i+1,j}.XData], [h.s{i,j}.YData;h.s{i+1,j}.YData], 'LineWidth', line_width*0.5, 'Color', [colours(j, :),0.3]);
            uistack(h.li{i,j},'bottom')
        end
    end
end

% % plot mean dots
% for i = 1:n_plots_per_series
%     for j = 1:n_series
%         posi = [ks_offsets(i)-(jit_width*0.65)-(j*0.8-1) ks_offsets(i+1)-(jit_width*0.65)-(j*0.8-1)];
%         h.m(i, j) = scatter(cell_means(i, j), [ks_offsets(i)-(jit_width*0.65)-(j*0.8-1)], 'MarkerFaceColor', colours(j, :), 'MarkerEdgeColor', [0 0 0], 'MarkerFaceAlpha', 0.5, 'SizeData', mean_size , 'LineWidth', 1);
%     
%     end
% end

%% clear up axis labels

% 'YTick', likes values that *increase* as you go up the Y-axis, but we plot the first
% raincloud at the top. So flip the vector around
set(gca, 'YTick', fliplr(ks_offsets));

set(gca, 'YTickLabel', n_plots_per_series:-1:1);

%% determine plot rotation
% default option is left-to-right
% plot_top_to_bottom can be set to 1 
% NOTE: Because it's easier, we actually prepare everything plotted
% top-to-bottom, then - by default - we rotate it here. That's why the
% logical is constructed the way it is.

% rotate and flip
if ~plot_top_to_bottom
    view([90 -90]);
    axis ij
end

legend([h.p{1,1} h.p{1,2}], 'DLPFC', 'Vertex' )
