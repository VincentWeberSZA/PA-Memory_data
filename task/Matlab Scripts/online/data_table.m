



%who should be taken for the final table? you can only choose one
vweber = 0;
sliechti = 0;
sfink = 0;
jbanninger = 1;
aberisha = 0;


if vweber
part_file = '/Users/vincentweber/OneDrive - FernUni Schweiz/Physical Activity and Memory/task/other files/participants vweber.xlsx';
datadir = '/Users/vincentweber/OneDrive - FernUni Schweiz/Physical Activity and Memory/task/results/csv/vweber/online';
end

if sliechti
part_file = '/Users/vincentweber/OneDrive - FernUni Schweiz/Physical Activity and Memory/task/other files/participants sliechti.xlsx';
datadir = '/Users/vincentweber/OneDrive - FernUni Schweiz/Physical Activity and Memory/task/results/csv/sliechti';
end

if sfink
part_file = '/Users/vincentweber/OneDrive - FernUni Schweiz/Physical Activity and Memory/task/other files/participants sfink.xlsx';
datadir = '/Users/vincentweber/OneDrive - FernUni Schweiz/Physical Activity and Memory/task/results/csv/sfink';
end

if jbanninger
part_file = '/Users/vincentweber/OneDrive - FernUni Schweiz/Physical Activity and Memory/task/other files/participants jbaenninger.xlsx';
datadir = '/Users/vincentweber/OneDrive - FernUni Schweiz/Physical Activity and Memory/task/results/csv/jbaenninger';
end

if aberisha
part_file = '/Users/vincentweber/OneDrive - FernUni Schweiz/Physical Activity and Memory/task/other files/participants aberisha.xlsx';
datadir = '/Users/vincentweber/OneDrive - FernUni Schweiz/Physical Activity and Memory/task/results/csv/aberisha';
end





part_table = readtable(part_file);
part_table = convert_table(part_table);

f = dir(datadir);


part_folders = f(4:end); %remove the ".","..","DC-Store" Folders
Num_part = size(part_folders,1); %#participants

for c = 1:Num_part
   
    
if size(dir([datadir filesep part_folders(c).name]),1) < 8, continue; end    
    
table_entry = create_entry(datadir, part_folders(c).name, part_table);

if c == 1
final_table = table_entry;
else
    final_table(c,:) = table_entry;
end
end



writetable(final_table,'final_table_jbannnger.csv')



