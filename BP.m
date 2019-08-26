%% �ô������������繤�������ͼƬ����
clc;clear;close all; format compact
%% ��������
%% ѵ������Ԥ��������ȡ����һ��

load data_tz
input=input;
label=output';
%%
no_dim=15;
[PCALoadings,PCAScores,PCAVar] = pca(input);%����PCA���н�ά
input=PCAScores(:,1:no_dim);%����pca���н�ά��no_dimsά
%%

%�������1ά���4ά
output=zeros(size(label,1),4);
for i=1:size(label,1)
    output(i,label(i))=1;
end
%%
rand('seed',0)

[m n]=sort(rand(1,size(input,1)));
m=100;%�����ȡm������Ϊѵ��������ʣ�µ�ΪԤ������
P_train=input(n(1:m),:)';
T_train=output(n(1:m),:)';
P_test=input(n(m+1:end),:)';
T_test=output(n(m+1:end),:)';

%% ��������
s1=12;%������ڵ�
net_bp=newff(P_train,T_train,s1);
% ����ѵ������
net_bp.trainParam.epochs = 100;
net_bp.trainParam.goal = 0.0001;
net_bp.trainParam.lr = 0.01;
net_bp.trainParam.showwindow = 1;

%% ѵ��������BP����
net_bp = train(net_bp,P_train,T_train);%ѵ��
%%ѵ����׼ȷ��
bp_sim = sim(net_bp,P_train);%����
[I J]=max(bp_sim',[],2);
[I1 J1]=max(T_train',[],2);
disp('չʾBP��ѵ��������')
bp_train_accuracy=sum(J==J1)/length(J)
figure
stem(J,'bo');
grid on
hold on 
plot(J1,'r*');
legend('����ѵ�����','��ʵ��ǩ')
title('BP������ѵ����')
xlabel('������')
ylabel('�����ǩ')
hold off
%% ���Լ�׼ȷ��
tn_bp_sim = sim(net_bp,P_test);%����
[I J]=max(tn_bp_sim',[],2);
[I1 J1]=max(T_test',[],2);
disp('չʾBP�Ĳ��Լ�����')
bp_test_accuracy=sum(J==J1)/length(J)
figure
stem(J,'bo');
grid on
hold on 
plot(J1,'r*');
legend('�������','��ʵ��ǩ')
title('BP��������Լ�')
xlabel('������')
ylabel('�����ǩ')
hold off
save net_bp net_bp PCALoadings