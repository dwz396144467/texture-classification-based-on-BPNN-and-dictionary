
function feature=fenci_tezheng(report)
report; %���������ı��������ѷ��ڹ�����

%% dictionary.mat��һ��������׼���õ�������

%����dict��14636*1���ֵ������������������صĹٷ����Ͽ�ת���õ���

load dictionary.mat;

Maxlen=max(cellfun(@length,dict)); %���ʳ��������10

%% ���������ִ� --�־�

cut='[\��\��\��\��\��\��\��\��\��\��\��\��\��\��\��\<\>\����\��]'; %�����ŵ�������ʽ

F=regexp(report,cut,'split')'; %ת�ã���������� 

% ��ʱ���������ľ伯F�ʹʵ䶼�Ѿ���

 

%% �㷨ԭ��

% �����ж��Ƿ�Ϊ��Ч�䣺�䳤�Ƿ����0��С��0�Ĳ��������൱������

% ������Ч�䣬����䳤�����ʳ�Maxlen����Сֵmaxlen����ѡ�ִ����Ȳ��ܴ��ڸó���

% ��maxlen���ȿ�ʼ��ȡ����ѡ�ִ�

% ƥ�䣬�ɹ����������ǡ����ɹ���ƽ��maxlen����λ�������ɹ���ƽ��1����λ

% ѡ����һ����ѡ�ִ���ƥ�䣬�ظ�������ֱ���ƶ����䳤����

% �����һ������ƥ��ɹ�����ô�Ͳ�����ƥ���ˣ��þ����������meet==0���ظ���һ������

% ����maxlen����1��ҲҪƥ�䣬��Ϊ�ʿ�����һ���ֵĴʣ�maxlen==0����ֹ�źš�

 

%% ���ƥ�䷨��һ���ִ�

sentence=[]; %�Ǵַֺ�F�е�ÿһ��Ԫ��

word=[];

words={};

k=1;

 

for i=1:length(F) %����F

    sentence=cell2mat(F(i,1)); %��cellת�����ַ���

    sentence_len=length(sentence); %����䳤

    meet=0; %���³�ʼ״̬

    

    if(sentence_len>0) %��Ч��

        maxlen=min(Maxlen,sentence_len);

        while(maxlen>0)

            start=1;

            while((start+maxlen)<=sentence_len)  %���������ƶ�����������

                word=sentence(start:start+maxlen);

                if(ismember(word,dict))%���ƥ��ɹ�

                    meet=1;

                    words(k)=cellstr(word);

                    k=k+1;

                    start=start+maxlen; %�ƶ�maxlen����λ��ƥ��

                else

                    start=start+1; %�ƶ�һ����λ��ƥ��

                end

            end

            %�Ѿ��ƶ�������������

            if(meet==0)

                maxlen=maxlen-1;

            else

                break;

            end

        end

    end

    %��Ч�䣬�䳤Ϊ0��������ֱ������

end

 

%% ������

rank = tabulate(words); %rank�������������������ƣ����ִ����Ͱٷֱ�
ANS=sortrows(rank,-2); %ֻ���ݵڶ��н������� -2��ʾ����

% xlswrite('resultschinese',ANS(1:50,1:3));%���Ϊexcel�ļ� ���ڴ��ｫ��1777�������ֻ���ǰ100��
label=zeros(1,length(dict));
for i=1:size(ANS,1)
    for j=7:length(dict)
%     if char(dict(j))==char(ANS(i,1))
        if strcmp(char(dict{j}),char(ANS{i,1}))==1
             label(j)=1;
        end
    end
end
feature=label;
