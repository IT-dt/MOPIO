function F = Cal(P)
%�������ݼ�
load re.txt
load datasets.txt
xSize = size(P,1);
D = size(P,2);
rel = re;
data = datasets;
f=1./(1+exp(-1.*rel))-0.5;
cost=zeros(1,xSize);   %���ӳɱ�Ŀ��
time=zeros(1,xSize);   %����ʱ��Ŀ��
relat=zeros(1,xSize);   %
for i=1:xSize
    for j=1:D %�������
        P(i,j) = round(P(i,j));
        cost(i) = cost(i)+data(P(i,j),1);  %���ӳɱ�
        time(i) = time(i)+data(P(i,j),2);  %����ʱ�� ����������㷨
    end
    % time(i) = compute(P(i,:));
    relat(i)=-relation(P,f,3,i);  %���ӹ�ϵ��
end
y = zeros(xSize, D);
y(:,1) = cost(:);
y(:,2) = time(:);
y(:,3) = relat(:);
F = y;
end