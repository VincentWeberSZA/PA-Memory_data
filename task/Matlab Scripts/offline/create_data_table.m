%Prepare data.
part_file = '/Users/vincentweber/OneDrive - FernUni Schweiz/Physical Activity and Memory/task/other files/participants.xlsx';
datadir = '/Users/vincentweber/OneDrive - FernUni Schweiz/Physical Activity and Memory/task/results';


part_table = readtable(part_file);
part_table = convert_table(part_table); %Convert datetimes

f = dir(datadir);
part_folders = f(4:end); %remove the ".","..","DC-Store" Folders
Num_part = size(part_folders.folder,1); %#participants

for c = 1:Num_part
    
if size(dir([datadir filesep part_folders(c).name]),1) < 10, continue; end    
    
table_entry = create_table_entry(datadir, part_folders(c).name, part_table, c);
if c == 1
final_table = table_entry;
else
    final_table(c,:) = table_entry;
end



end


writetable(final_table,'final_table.csv')


