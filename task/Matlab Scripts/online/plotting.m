%plotting

load('final_table.mat')

y = final_table{:,:};

categories = ['PA_deep','PA_shal','REST_deep','REST_shallow'];


%Cued Recall
subplot(2,2,1)
boxplot([y(:,2),y(:,10)],'Labels',{'PA_im_shal', 'REST_im_shal'})

%multiple Choice
subplot(2,2,2)
boxplot([y(:,3),y(:,11)],'Labels',{'PA_im_shal', 'REST_im_shal'})

%Cued Recall
subplot(2,2,3)
boxplot([y(:,4),y(:,12)],'Labels',{'PA_im_deep', 'REST_im_deep'})

%multiple Choice
subplot(2,2,4)
boxplot([y(:,3),y(:,13)],'Labels',{'PA_im_deep', 'REST_im_deep'})
