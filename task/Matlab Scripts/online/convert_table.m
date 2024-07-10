function [y] = convert_table(x)

y = x;
		
y.session1_start_baseline = datetime(datevec(x.session1_start_baseline),'Format','HH:mm:ss');
y.session1_end_baseline = datetime(datevec(x.session1_end_baseline),'Format','HH:mm:ss');
y.session1_start_activity = datetime(datevec(x.session1_start_activity),'Format','HH:mm:ss');
y.session1_start_activity = datetime(datevec(x.session1_start_activity),'Format','HH:mm:ss');
y.session1_end_activity = datetime(datevec(x.session1_end_activity),'Format','HH:mm:ss');
y.session1_start_cooldown = datetime(datevec(x.session1_start_cooldown),'Format','HH:mm:ss');
y.session1_end_cooldown = datetime(datevec(x.session1_end_cooldown),'Format','HH:mm:ss');
y.session1_start_encoding = datetime(datevec(x.session1_start_encoding),'Format','HH:mm:ss');
y.session1_end_encoding = datetime(datevec(x.session1_end_encoding),'Format','HH:mm:ss');
y.session1_start_retrieval = datetime(datevec(x.session1_start_retrieval),'Format','HH:mm:ss');
y.session1_end_retrieval = datetime(datevec(x.session1_end_retrieval),'Format','HH:mm:ss');

y.session3_start_baseline = datetime(datevec(x.session3_start_baseline),'Format','HH:mm:ss');
y.session3_end_baseline = datetime(datevec(x.session3_end_baseline),'Format','HH:mm:ss');
y.session3_start_activity = datetime(datevec(x.session3_start_activity),'Format','HH:mm:ss');
y.session3_start_activity = datetime(datevec(x.session3_start_activity),'Format','HH:mm:ss');
y.session3_end_activity = datetime(datevec(x.session3_end_activity),'Format','HH:mm:ss');
y.session3_start_cooldown = datetime(datevec(x.session3_start_cooldown),'Format','HH:mm:ss');
y.session3_end_cooldown = datetime(datevec(x.session3_end_cooldown),'Format','HH:mm:ss');
y.session3_start_encoding = datetime(datevec(x.session3_start_encoding),'Format','HH:mm:ss');
y.session3_end_encoding = datetime(datevec(x.session3_end_encoding),'Format','HH:mm:ss');
y.session3_start_retrieval = datetime(datevec(x.session3_start_retrieval),'Format','HH:mm:ss');
y.session3_end_retrieval = datetime(datevec(x.session3_end_retrieval),'Format','HH:mm:ss');

end
