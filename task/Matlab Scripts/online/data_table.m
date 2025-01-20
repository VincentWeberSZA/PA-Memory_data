



%who should be taken for the final table? you can only choose one
vweber = 1;
sliechti = 0;
sfink = 0;
jbanninger = 0;
aberisha = 0;


if vweber
part_file = '/Users/vincentweber/Library/CloudStorage/OneDrive-FreigegebeneBibliotheken–FernUniSchweiz/Research Projects Reber - Physical Activity and Memory/task/other files/participants vweber.xlsx';
datadir = '/Users/vincentweber/Library/CloudStorage/OneDrive-FreigegebeneBibliotheken–FernUniSchweiz/Research Projects Reber - Physical Activity and Memory/task/results/csv/vweber/online';
start_ = 3; %how many orders should be excluded in the beginning.
end

if sliechti
part_file = '/Users/vincentweber/Library/CloudStorage/OneDrive-FreigegebeneBibliotheken–FernUniSchweiz/Research Projects Reber - Physical Activity and Memory/task/other files/participants sliechti.xlsx';
datadir = '/Users/vincentweber/Library/CloudStorage/OneDrive-FreigegebeneBibliotheken–FernUniSchweiz/Research Projects Reber - Physical Activity and Memory/task/results/csv/sliechti';
start_ = 4;
end

if sfink
part_file = '/Users/vincentweber/Library/CloudStorage/OneDrive-FreigegebeneBibliotheken–FernUniSchweiz/Research Projects Reber - Physical Activity and Memory/task/other files/participants sfink.xlsx';
datadir = '/Users/vincentweber/Library/CloudStorage/OneDrive-FreigegebeneBibliotheken–FernUniSchweiz/Research Projects Reber - Physical Activity and Memory/task/results/csv/sfink';
start_ = 4;
end

if jbanninger
part_file = '/Users/vincentweber/Library/CloudStorage/OneDrive-FreigegebeneBibliotheken–FernUniSchweiz/Research Projects Reber - Physical Activity and Memory/task/other files/participants jbaenninger.xlsx';
datadir = '/Users/vincentweber/Library/CloudStorage/OneDrive-FreigegebeneBibliotheken–FernUniSchweiz/Research Projects Reber - Physical Activity and Memory/task/results/csv/jbaenninger';
start_ = 3;
end

if aberisha
part_file = '/Users/vincentweber/Library/CloudStorage/OneDrive-FreigegebeneBibliotheken–FernUniSchweiz/Research Projects Reber - Physical Activity and Memory/task/other files/participants aberisha.xlsx';
datadir = '/Users/vincentweber/Library/CloudStorage/OneDrive-FreigegebeneBibliotheken–FernUniSchweiz/Research Projects Reber - Physical Activity and Memory/task/results/csv/aberisha';
start_ = 3;
end





part_table = readtable(part_file);
part_table = convert_table(part_table);

f = dir(datadir);


part_folders = f(start_:end); %remove the ".","..","DC-Store" Folders
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



writetable(final_table,'final_table_vweber.csv')



