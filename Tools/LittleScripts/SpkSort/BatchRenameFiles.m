function BatchRenameFiles
% Get all NCS files in the current folder
files = dir('*.ncs');
% save original Channel label List to make back conversion possible
writetable((cell2table({files.name}','VariableNames', {'Names'})), 'Original_Filenames.csv') 
% Loop through each
for id = 1:length(files)
    % Get the file name (minus the extension)
    [~, f] = fileparts(files(id).name);
      % Convert to number
      num = id;
      % If numeric, rename
      movefile(files(id).name, sprintf('CSC%d.ncs', num));
end