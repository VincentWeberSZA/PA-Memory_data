
clear all;
table_original = readtable('/Users/vincentweber/OneDrive - FernUni Schweiz/Physical Activity and Memory/task/results/Limesurvey/LimeSurveyExport_290524.csv');



%table(1:50,:) = [];

%remove NaN rows
table = rmmissing(table_original);

%remove id's < 105, not online study
table(find(table.Versuchsperson_ < 105),:) = [];

%sort rows by VP_nr
table = sortrows(table, 'Versuchsperson_');

%Remove double entries manual
table(18,:) = [];

%Prozente weiblich

n_part = size(table,1);

x = sum(strcmp(table.BiologischesGeschlecht,'Weiblich'))/n_part;
disp('weiblich:')
disp(x)
disp(x*n_part)

y = sum(strcmp(table.H_ndigkeit,'<span style="font-size:16px;">Rechtshänder</span>'))/size(table,1);
disp('Rechtshändig:')
disp(y)
disp(y*n_part)

z = mean(table.Alter);
a = std(table.Alter);
disp('Durchschnittsalter, Standardabweichung:')
disp(z)
disp(a)

disp('min to max:')
disp(min(table.Alter))
disp(max(table.Alter))



