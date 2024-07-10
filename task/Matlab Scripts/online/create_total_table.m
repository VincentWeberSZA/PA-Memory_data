table1 = readtable('/Users/vincentweber/OneDrive - FernUni Schweiz/Physical Activity and Memory/task/Matlab Scripts/online/final_table_vweber.csv');
table2 = readtable('/Users/vincentweber/OneDrive - FernUni Schweiz/Physical Activity and Memory/task/Matlab Scripts/online/final_table_fink.csv');
table3 = readtable('/Users/vincentweber/OneDrive - FernUni Schweiz/Physical Activity and Memory/task/Matlab Scripts/online/final_table_liechti.csv');
table4 = readtable('/Users/vincentweber/OneDrive - FernUni Schweiz/Physical Activity and Memory/task/Matlab Scripts/online/final_table_aberisha.csv');
table5 = readtable('/Users/vincentweber/OneDrive - FernUni Schweiz/Physical Activity and Memory/task/Matlab Scripts/online/final_table_jbanninger.csv');

total_table = [table1;table2;table3;table4;table5];

writetable(total_table,'total_table.csv')