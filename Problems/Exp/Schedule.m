function [MaxTime, ratio] = Schedule(Dev, Timec, num, List)
% DevΪ�豸����TimecΪ��ʱ����ListΪ����˳��������[1,1,2,3,2,3,3,2], num�豸����
M=size(Dev,1);
step=zeros(1,M);%���Ʋ�Ʒ���ƶ�
suit=zeros(1,M);%���Ʋ�Ʒ��������
Time=zeros(1,num);%���豸������ʱ
TimeR = zeros(1,num);%���豸�ӹ���ʱ
for i=1:length(List)
    if step(List(i))==0
        step(List(i))=1;
        TimeR(Dev(List(i),step(List(i)))) = TimeR(Dev(List(i),step(List(i)))) + Timec(List(i),step(List(i)));
        Time(Dev(List(i),step(List(i)))) = Time(Dev(List(i),step(List(i)))) + Timec(List(i),step(List(i)));
        suit(List(i))=Time(Dev(List(i),step(List(i))));
    else
        step(List(i)) = step(List(i))+1;
        TimeR(Dev(List(i),step(List(i)))) = TimeR(Dev(List(i),step(List(i)))) + Timec(List(i),step(List(i)));
        Time(Dev(List(i),step(List(i)))) = Timec(List(i),step(List(i))) + max(suit(List(i)),Time(Dev(List(i),step(List(i)))));
        suit(List(i))=Time(Dev(List(i),step(List(i))));
    end
end
ratioA = TimeR ./ Time; %���豸��������
% MaxTime = Time;
% ratio = ratioA;
MaxTime = max(Time); %�������ʱ��
ratio = sum(ratioA(:))/M; %ƽ��������
end

