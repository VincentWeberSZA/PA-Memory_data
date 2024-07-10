function [table_entry] = create_entry(datadir, id, part_table)


%CHECK if PA-REST or REST-PA,
REST_CONDITION_FIRST = strcmp(part_table.session_order(find(part_table.id == str2num(id))),'Rest-PA');
part_table_y = find(part_table.id == str2num(id));

%*********************************************************************************
%PHASE1
%read tables

%e.g.:
%PA_immediate_vector = correct responses
%PA_immediate_rt = reaction times
%*********************************************************************************

%PA Extract Immediate and encoding table entries
d1 = dir([datadir filesep id filesep '*PA_im*']);
PA_im_enc_table = readtable([datadir filesep id filesep d1.name]);
PA_encoding_table = PA_im_enc_table(1:(end-136),:);
PA_immediate_table = PA_im_enc_table((end-135):end,:);

tf_PA_im=cellfun(@(x)strcmp(x,'NA'),PA_immediate_table.correct); %tf is vector where 1 = 'NA'-values
PA_immediate_vector = str2double(PA_immediate_table.correct(~tf_PA_im)); %remove NaN value

PA_immediate_rt = PA_immediate_table.duration(strcmp(PA_immediate_table.ended_on,'form submission'));

%PA Extract Delayed table entries
d2 = dir([datadir filesep id filesep '*PA_del*']);
PA_delayed_table = readtable([datadir filesep id filesep d2.name]);

tf_PA_del=cellfun(@(x)strcmp(x,'NA'),PA_delayed_table.correct); %tf is vector where 1 = 'NA'-values
PA_delayed_vector = str2double(PA_delayed_table.correct(~tf_PA_del)); %remove NaN value

PA_delayed_rt = PA_delayed_table.duration(strcmp(PA_delayed_table.ended_on,'form submission'));

%REST Extract Immediate and encoding table entries
d3 = dir([datadir filesep id filesep '*REST_im*']);
REST_im_enc_table = readtable([datadir filesep id filesep d3.name]);
REST_encoding_table = REST_im_enc_table(1:(end-136),:);
REST_immediate_table = REST_im_enc_table((end-135):end,:);

tf_REST_im=cellfun(@(x)strcmp(x,'NA'),REST_immediate_table.correct); %tf is vector where 1 = 'NA'-values
REST_immediate_vector = str2double(REST_immediate_table.correct(~tf_REST_im)); %remove NaN value

REST_immediate_rt = REST_immediate_table.duration(strcmp(REST_immediate_table.ended_on,'form submission'));

%REST Extract Delayed table entries
d4 = dir([datadir filesep id filesep '*REST_del*']);
REST_delayed_table = readtable([datadir filesep id filesep d4.name]);

tf_REST_del=cellfun(@(x)strcmp(x,'NA'),REST_delayed_table.correct); %tf is vector where 1 = 'NA'-values
REST_delayed_vector = str2double(REST_delayed_table.correct(~tf_REST_del)); %remove NaN value

REST_delayed_rt = REST_delayed_table.duration(strcmp(REST_delayed_table.ended_on,'form submission'));



%*********************************************************************************
%PHASE2
%Create for immediate test an array where all "1" entries indicate indicies
%with shallow words. so in the test there are 32 words testet. Every
%indicies indicates if the word was shallow or deep encoded
%*********************************************************************************

%PA_immediate
wordlist = PA_immediate_table.german(~tf_PA_im);
for x = 1:size(wordlist)
f = PA_encoding_table.enc(strcmp(PA_encoding_table.german,wordlist{x}));
shallow_array(x,1) = f{1};
end
%entries 1:16 are cued recall decoded, entries 17:32 are MC decoded
PA_im_shallow_index = strcmp(shallow_array,"s");
PA_im_deep_index = ~PA_im_shallow_index;


%PA_delayed
wordlist = PA_delayed_table.german(~tf_PA_del);
for x = 1:size(wordlist)
f = PA_encoding_table.enc(strcmp(PA_encoding_table.german,wordlist{x}));
shallow_array(x,1) = f{1};
end
%entries 1:16 are cued recall decoded, entries 17:32 are MC decoded
PA_del_shallow_index = strcmp(shallow_array,"s");
PA_del_deep_index = ~PA_del_shallow_index;


%REST_immediate
wordlist = REST_immediate_table.german(~tf_REST_im);
for x = 1:size(wordlist)
f = REST_encoding_table.enc(strcmp(REST_encoding_table.german,wordlist{x}));
shallow_array(x,1) = f{1};
end
%entries 1:16 are cued recall decoded, entries 17:32 are MC decoded
REST_im_shallow_index = strcmp(shallow_array,"s");
REST_im_deep_index = ~REST_im_shallow_index;

%REST_delayed
wordlist = REST_delayed_table.german(~tf_REST_del);
for x = 1:size(wordlist)
f = REST_encoding_table.enc(strcmp(REST_encoding_table.german,wordlist{x}));
shallow_array(x,1) = f{1};
end
%entries 1:16 are cued recall decoded, entries 17:32 are MC decoded
REST_del_shallow_index = strcmp(shallow_array,"s");
REST_del_deep_index = ~REST_del_shallow_index;

%*********************************************************************************
%*********************************************************************************


%*********************************************************************************
%PHASE3
%create new table entries:
%*********************************************************************************

%MC = multiple choice retrival
%CR = cued recall retrival
%pc = percent corrrect
%rt = reaction times
%PA/REST
%im = immediate
%shal = shallow

%percent correct (differentiate CR and MP)
PA_immediate_CR = PA_immediate_vector(1:16);
PA_immediate_MP = PA_immediate_vector(17:32);
PA_delayed_CR = PA_delayed_vector(1:16);
PA_delayed_MP = PA_delayed_vector(17:32);

REST_immediate_CR = REST_immediate_vector(1:16);
REST_immediate_MP = REST_immediate_vector(17:32);
REST_delayed_CR = REST_delayed_vector(1:16);
REST_delayed_MP = REST_delayed_vector(17:32);

%percent correct (create final entries)
pc_CR_PA_im_shal = mean(PA_immediate_CR(PA_im_shallow_index(1:16)));
pc_MP_PA_im_shal = mean(PA_immediate_MP(PA_im_shallow_index(17:32)));
pc_CR_PA_im_deep = mean(PA_immediate_CR(PA_im_deep_index(1:16)));
pc_MP_PA_im_deep = mean(PA_immediate_MP(PA_im_deep_index(17:32)));

pc_CR_PA_del_shal = mean(PA_delayed_CR(PA_del_shallow_index(1:16)));
pc_MP_PA_del_shal = mean(PA_delayed_MP(PA_del_shallow_index(17:32)));
pc_CR_PA_del_deep = mean(PA_delayed_CR(PA_del_deep_index(1:16)));
pc_MP_PA_del_deep = mean(PA_delayed_MP(PA_del_deep_index(17:32)));

pc_CR_REST_im_shal = mean(REST_immediate_CR(REST_im_shallow_index(1:16)));
pc_MP_REST_im_shal = mean(REST_immediate_MP(REST_im_shallow_index(17:32)));
pc_CR_REST_im_deep = mean(REST_immediate_CR(REST_im_deep_index(1:16)));
pc_MP_REST_im_deep = mean(REST_immediate_MP(REST_im_deep_index(17:32)));

pc_CR_REST_del_shal = mean(REST_delayed_CR(REST_del_shallow_index(1:16)));
pc_MP_REST_del_shal = mean(REST_delayed_MP(REST_del_shallow_index(17:32)));
pc_CR_REST_del_deep = mean(REST_delayed_CR(REST_del_deep_index(1:16)));
pc_MP_REST_del_deep = mean(REST_delayed_MP(REST_del_deep_index(17:32)));

%reaction times (differentiate RT and MP)
rt_PA_immediate_CR = PA_immediate_rt(1:16);
rt_PA_immediate_MP = PA_immediate_rt(17:32);
rt_PA_delayed_CR = PA_delayed_rt(1:16);
rt_PA_delayed_MP = PA_delayed_rt(17:32);

rt_REST_immediate_CR = REST_immediate_rt(1:16);
rt_REST_immediate_MP = REST_immediate_rt(17:32);
rt_REST_delayed_CR = REST_delayed_rt(1:16);
rt_REST_delayed_MP = REST_delayed_rt(17:32);


%reaction times (create final entries)
rt_CR_PA_im_shal = mean(rt_PA_immediate_CR(PA_im_shallow_index(1:16)));
rt_MP_PA_im_shal = mean(rt_PA_immediate_MP(PA_im_shallow_index(17:32)));
rt_CR_PA_im_deep = mean(rt_PA_immediate_CR(PA_im_deep_index(1:16)));
rt_MP_PA_im_deep = mean(rt_PA_immediate_MP(PA_im_deep_index(17:32)));

rt_CR_PA_del_shal = mean(rt_PA_delayed_CR(PA_del_shallow_index(1:16)));
rt_MP_PA_del_shal = mean(rt_PA_delayed_MP(PA_del_shallow_index(17:32)));
rt_CR_PA_del_deep = mean(rt_PA_delayed_CR(PA_del_deep_index(1:16)));
rt_MP_PA_del_deep = mean(rt_PA_delayed_MP(PA_del_deep_index(17:32)));

rt_CR_REST_im_shal = mean(rt_REST_immediate_CR(REST_im_shallow_index(1:16)));
rt_MP_REST_im_shal = mean(rt_REST_immediate_MP(REST_im_shallow_index(17:32)));
rt_CR_REST_im_deep = mean(rt_REST_immediate_CR(REST_im_deep_index(1:16)));
rt_MP_REST_im_deep = mean(rt_REST_immediate_MP(REST_im_deep_index(17:32)));

rt_CR_REST_del_shal = mean(rt_REST_delayed_CR(REST_del_shallow_index(1:16)));
rt_MP_REST_del_shal = mean(rt_REST_delayed_MP(REST_del_shallow_index(17:32)));
rt_CR_REST_del_deep = mean(rt_REST_delayed_CR(REST_del_deep_index(1:16)));
rt_MP_REST_del_deep = mean(rt_REST_delayed_MP(REST_del_deep_index(17:32)));


%*********************************************************************************
%*********************************************************************************


%*********************************************************************************

%calculate Heartrates

%*********************************************************************************
d7 = dir([datadir filesep id filesep '*PA_Polar*']);
HR_PA_table = readtable([datadir filesep id filesep d7.name]);
d8 = dir([datadir filesep id filesep '*Rest_Polar*']);
HR_Rest_table = readtable([datadir filesep id filesep d8.name]);



if REST_CONDITION_FIRST  
counter = 1;
HR_mean = NaN(1,10);
for index = 22:2:40
    start_ = part_table{part_table_y,index};
    end_ = part_table{part_table_y,(index+1)};
    
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
    start_ = part_table{part_table_y,index};
    end_ = part_table{part_table_y,(index+1)};
    
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


%*********************************************************************************
%*********************************************************************************



%RETURN:



id = str2num(id);


table_entry = table(id, pc_CR_PA_im_shal, pc_MP_PA_im_shal, pc_CR_PA_im_deep, pc_MP_PA_im_deep, pc_CR_PA_del_shal, pc_MP_PA_del_shal, pc_CR_PA_del_deep, pc_MP_PA_del_deep,...
    pc_CR_REST_im_shal, pc_MP_REST_im_shal, pc_CR_REST_im_deep, pc_MP_REST_im_deep, pc_CR_REST_del_shal, pc_MP_REST_del_shal, pc_CR_REST_del_deep, pc_MP_REST_del_deep,...
   rt_CR_PA_im_shal, rt_MP_PA_im_shal, rt_CR_PA_im_deep, rt_MP_PA_im_deep, rt_CR_PA_del_shal, rt_MP_PA_del_shal, rt_CR_PA_del_deep, rt_MP_PA_del_deep,...
    rt_CR_REST_im_shal, rt_MP_REST_im_shal, rt_CR_REST_im_deep, rt_MP_REST_im_deep, rt_CR_REST_del_shal, rt_MP_REST_del_shal, rt_CR_REST_del_deep, rt_MP_REST_del_deep,...
HR_Rest_baseline, HR_Rest_activity, HR_Rest_cooldown, HR_Rest_encoding, HR_Rest_retrival,... 
    HR_PA_baseline, HR_PA_activity, HR_PA_cooldown, HR_PA_encoding, HR_PA_retrival);


