%% �ô���Ϊbp����

%% ��ջ�������
clc;clear;close all; format compact
%% ��������
%% ѵ������Ԥ��������ȡ����һ��

load data_tz
input=input;
label=output';
%%
no_dim=13;
[PCALoadings,PCAScores,PCAVar] = pca(input);%����PCA���н�ά
input=PCAScores(:,1:no_dim);%����pca���н�ά��no_dimsά
%%

%�������1ά���4ά
output=zeros(size(label,1),4);
for i=1:size(label,1)
    output(i,label(i))=1;
end

%�����ȡ150������Ϊѵ��������48������ΪԤ������
rand('seed',0)
[m n]=sort(rand(1,156));
m=100;
input_train=input(n(1:m),:)';
output_train=output(n(1:m),:)';
input_test=input(n(m+1:end),:)';
output_test=output(n(m+1:end),:)';




%% ����ṹ��ʼ��

innum=size(input_train,1);%�����ڵ���
midnum=12;%������ڵ�
outnum=size(output_train,1);%�����ڵ�
 
%Ȩֵ��ʼ��
w1=rands(midnum,innum);
b1=rands(midnum,1);
w2=rands(midnum,outnum);
b2=rands(outnum,1);

w2_1=w2;w2_2=w2_1;
w1_1=w1;w1_2=w1_1;
b1_1=b1;b1_2=b1_1;
b2_1=b2;b2_2=b2_1;


xite=0.01;%ѧϰ��
alfa=0.1;%������
loopNumber=100;%ѵ������
I=zeros(1,midnum);
Iout=zeros(1,midnum);
FI=zeros(1,midnum);
dw1=zeros(innum,midnum);
db1=zeros(1,midnum);

%% ����ѵ��
inputn=input_train;
E=zeros(1,loopNumber);
for ii=1:loopNumber
    E(ii)=0;
    for i=1:1:size(inputn,2)%ce
       %% 
        x=inputn(:,i);
        % ���������
        for j=1:1:midnum
            I(j)=inputn(:,i)'*w1(j,:)'+b1(j);
            Iout(j)=1/(1+exp(-I(j)));
        end
        % ��������
        yn=w2'*Iout'+b2;
        
       %% Ȩֵ��ֵ����
        %�������
        e=output_train(:,i)-yn;     
        E(ii)=E(ii)+sum(abs(e));
        
        %����Ȩֵ�仯��
        dw2=e*Iout;
        db2=e';
        
        for j=1:1:midnum
            S=1/(1+exp(-I(j)));
            FI(j)=S*(1-S);
        end      
        for k=1:1:innum
            for j=1:1:midnum
                dw1(k,j)=FI(j)*x(k)*(e(1)*w2(j,1)+e(2)*w2(j,2)+e(3)*w2(j,3)+e(4)*w2(j,4));
                db1(j)=FI(j)*(e(1)*w2(j,1)+e(2)*w2(j,2)+e(3)*w2(j,3)+e(4)*w2(j,4));
            end
        end
           
        w1=w1_1+xite*dw1'+alfa*(w1_1-w1_2);
        b1=b1_1+xite*db1'+alfa*(b1_1-b1_2);
        w2=w2_1+xite*dw2'+alfa*(w2_1-w2_2);
        b2=b2_1+xite*db2'+alfa*(b2_1-b2_2);
        
        w1_2=w1_1;w1_1=w1;
        w2_2=w2_1;w2_1=w2;
        b1_2=b1_1;b1_1=b1;
        b2_2=b2_1;b2_1=b2;
    end
end
figure
plot(E)
title('ѵ�����')
xlabel('��������')
ylabel('���')

%% ѵ���׶�
inputn_test=input_train;
fore=zeros(size(output_train));
for i=1:size(inputn_test,2)%56������
    %���������
    for j=1:1:midnum
        I(j)=inputn_test(:,i)'*w1(j,:)'+b1(j);
        Iout(j)=1/(1+exp(-I(j)));
    end
    fore(:,i)=w2'*Iout'+b2;
end
[I J1]=max(fore',[],2);
[I1 J2]=max(output_train',[],2);
test_accuracy=sum(J1==J2)/length(J1)
figure
stem(J1,'bo');
grid on
hold on 
plot(J2,'r*');
legend('�������','��ʵ��ǩ')
title('BP������ѵ����')
xlabel('������')
ylabel('�����ǩ')
hold off
%% ���Խ׶�
inputn_test=input_test;
fore=zeros(size(output_test));
for i=1:size(inputn_test,2)%56������
    %���������
    for j=1:1:midnum
        I(j)=inputn_test(:,i)'*w1(j,:)'+b1(j);
        Iout(j)=1/(1+exp(-I(j)));
    end
    fore(:,i)=w2'*Iout'+b2;
end
% �������
%������������ҳ�������������
[I J3]=max(fore',[],2);
[I1 J4]=max(output_test',[],2);
test_accuracy=sum(J3==J4)/length(J3)

figure
stem(J3,'bo');
grid on
hold on 
plot(J4,'r*');
legend('�������','��ʵ��ǩ')
title('BP��������Լ�')
xlabel('������')
ylabel('�����ǩ')
hold off