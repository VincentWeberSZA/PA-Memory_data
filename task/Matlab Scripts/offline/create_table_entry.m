function [table_entry] = create_table_entry(datadir, id, part_table, c)

%Read Tables out of files
d1 = dir([datadir filesep id filesep '*PA_delayed*']);
PA_delayed_table = readtable([datadir filesep id filesep d1.name]);
d2 = dir([datadir filesep id filesep '*PA_immediate*']);
PA_immediate_table = readtable([datadir filesep id filesep d2.name]);
d3 = dir([datadir filesep id filesep '*PA_encoding*']);
PA_encoding_table = readtable([datadir filesep id filesep d3.name]);
d4 = dir([datadir filesep id filesep '*Rest_delayed*']);
Rest_delayed_table = readtable([datadir filesep id filesep d4.name]);
d5 = dir([datadir filesep id filesep '*Rest_immediate*']);
Rest_immediate_table = readtable([datadir filesep id filesep d5.name]);
d6 = dir([datadir filesep id filesep '*Rest_encoding*']);
Rest_encoding_table = readtable([datadir filesep id filesep d6.name]);

d7 = dir([datadir filesep id filesep '*Polar_PA*']);
HR_PA_table = readtable([datadir filesep id filesep d7.name]);
d8 = dir([datadir filesep id filesep '*Polar_Rest*']);
HR_Rest_table = readtable([datadir filesep id filesep d8.name]);









    


%Create Table entries for finaltable

%PA_delayed
pc_PA_del_deep = mean(PA_delayed_table.correct(1:16)); %deep regarding retrival
pc_PA_del_shallow = mean(PA_delayed_table.correct(17:32)); %shallow regarding retrival
rt_PA_del_deep = mean(PA_delayed_table.rt(1:16));
rt_PA_del_shallow = mean(PA_delayed_table.rt(17:32));
%PA_immediate
pc_PA_im_deep = mean(PA_immediate_table.correct(1:16)); %deep regarding retrival
pc_PA_im_shallow = mean(PA_immediate_table.correct(17:32)); %shallow regarding retrival
rt_PA_im_deep = mean(PA_immediate_table.rt(1:16));
rt_PA_im_shallow = mean(PA_immediate_table.rt(17:32));
%PA_encoding
pc_PA_enc_deep = mean(PA_encoding_table.correct(1:16)); %deep regarding retrival
pc_PA_enc_shallow = mean(PA_encoding_table.correct(17:32)); %shallow regarding retrival
rt_PA_enc_deep = mean(PA_encoding_table.rt(1:16));
rt_PA_enc_shallow = mean(PA_encoding_table.rt(17:32));

%Rest_delayed
pc_Rest_del_deep = mean(Rest_delayed_table.correct(1:16)); %deep regarding retrival
pc_Rest_del_shallow = mean(Rest_delayed_table.correct(17:32)); %shallow regarding retrival
rt_Rest_del_deep = mean(Rest_delayed_table.rt(1:16));
rt_Rest_del_shallow = mean(Rest_delayed_table.rt(17:32));
%PA_immediate
pc_Rest_im_deep = mean(Rest_immediate_table.correct(1:16)); %deep regarding retrival
pc_Rest_im_shallow = mean(Rest_immediate_table.correct(17:32)); %shallow regarding retrival
rt_Rest_im_deep = mean(Rest_immediate_table.rt(1:16));
rt_Rest_im_shallow = mean(Rest_immediate_table.rt(17:32));
%PA_encoding
pc_Rest_enc_deep = mean(Rest_encoding_table.correct(1:16)); %deep regarding retrival
pc_Rest_enc_shallow = mean(Rest_encoding_table.correct(17:32)); %shallow regarding retrival
rt_Rest_enc_deep = mean(Rest_encoding_table.rt(1:16));
rt_Rest_enc_shallow = mean(Rest_encoding_table.rt(17:32));

%calculate Heartrates

if rem(c,2) == 1 %c==1, Rest condition first, important for 
counter = 1;
HR_mean = NaN(1,10);
for index = 22:2:40
    start_ = part_table{c,index};
    end_ = part_table{c,(index+1)};
    
    if counter < 6
    start_i = find(HR_Rest_table.Time == string(start_));
    end_i = find(HR_Rest_table.Time == string(end_));
    HR_mean(counter) = mean(HR_Rest_table.HR_bpm_(start_i:end_i));
    else
       start_i = find(HR_PA_table.Time == string(start_));
    end_i = find(HR_PA_table.Time == string(end_));
    HR_mean(counter) = mean(HR_PA_table.HR_bpm_(start_i:end_i)); 
    end
    
    
    counter = counter + 1;
end
HR_Rest_baseline = HR_mean(1);
HR_Rest_activity = HR_mean(2);
HR_Rest_cooldown = HR_mean(3);
HR_Rest_encoding = HR_mean(4);
HR_Rest_retrival = HR_mean(5);
HR_PA_baseline = HR_mean(6);
HR_PA_activity = HR_mean(7);
HR_PA_cooldown = HR_mean(8);
HR_PA_encoding = HR_mean(9);
HR_PA_retrival = HR_mean(10);

else %PA first
 counter = 1;
HR_mean = NaN(1,10);
for index = 22:2:40
    start_ = part_table{c,index};
    end_ = part_table{c,(index+1)};
    
    if counter < 6
    start_i = find(HR_PA_table.Time == string(start_));
    end_i = find(HR_PA_table.Time == string(end_));
    HR_mean(counter) = mean(HR_PA_table.HR_bpm_(start_i:end_i));
        
    else
    start_i = find(HR_Rest_table.Time == string(start_));
    end_i = find(HR_Rest_table.Time == string(end_));
    HR_mean(counter) = mean(HR_Rest_table.HR_bpm_(start_i:end_i));
     
    end
  
    counter = counter + 1;
    
end

HR_PA_baseline = HR_mean(1);
HR_PA_activity = HR_mean(2);
HR_PA_cooldown = HR_mean(3);
HR_PA_encoding = HR_mean(4);
HR_PA_retrival = HR_mean(5);
HR_Rest_baseline = HR_mean(6);
HR_Rest_activity = HR_mean(7);
HR_Rest_cooldown = HR_mean(8);
HR_Rest_encoding = HR_mean(9);
HR_Rest_retrival = HR_mean(10);

end





id = str2num(id);




table_entry = table(id, pc_PA_enc_deep, pc_PA_enc_shallow, rt_PA_enc_deep, rt_PA_enc_shallow,...
    pc_PA_im_deep, pc_PA_im_shallow, rt_PA_im_deep, rt_PA_im_shallow,...
    pc_PA_del_deep, pc_PA_del_shallow, rt_PA_del_deep, rt_PA_del_shallow,...
    pc_Rest_enc_deep, pc_Rest_enc_shallow, rt_Rest_enc_deep, rt_Rest_enc_shallow,...
    pc_Rest_im_deep, pc_Rest_im_shallow, rt_Rest_im_deep, rt_Rest_im_shallow,...
    pc_Rest_del_deep, pc_Rest_del_shallow, rt_Rest_del_deep, rt_Rest_del_shallow,...
    HR_Rest_baseline, HR_Rest_activity, HR_Rest_cooldown, HR_Rest_encoding, HR_Rest_retrival,... 
    HR_PA_baseline, HR_PA_activity, HR_PA_cooldown, HR_PA_encoding, HR_PA_retrival);


