%put all final tables together

a = readtable('final_table_sfink.csv');
b = readtable('final_table_sliechti.csv');
c = readtable('final_table_jbanninger.csv');
d = readtable('final_table_aberisha.csv');
e = readtable('final_table_vweber.csv');

complete_table = [a;b;c;d;e];

writetable(complete_table,'complete_table_20_01_25.csv')