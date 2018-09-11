function timebest = Scheduling(A,B,num,list)
%SCHEDULING �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
T = 1000; %ѭ������
pnum = 100; %��������
D = size(list,2);
% ���ò���
R=0.9;
wmax=1.0;  %��������
wmin=0.0729;  %��������
dnum = num; %�豸����
x = zeros(pnum,D); %λ��ʸ��
v = zeros(pnum,D); %�ٶ�ʸ��
time = zeros(1,pnum); %����Ŀ��ֵ
ratio = zeros(1,pnum);
% ����ֵ��ʼ��
tibest=zeros(1,pnum); %����ʱ��Ŀ��
ratiobest=zeros(1,pnum);  %��ϵ
round = [10, 30]; %���ӷ�Χ
for i=1:pnum
    for j=1:D
        x(i,j) = round(1) + (round(2)-round(1))*rand;
    end
end
xbest=x;           %�������ֵ
%% ��������ǰ
xsort = zeros(1,D);
lsort = zeros(1,D);
for i=1:pnum
    xsort = x(i,:); 
    [~,pos] = sort(xsort);
    lsort = list(1,pos);
    [time(i),ratio(i)] = Schedule(A,B,dnum,lsort);
end
% ��������λ��
tibest=time;
ratiobest=ratio;

%% ��ʼɸѡ���ӽ�
flj=[];
fljx=[];
fljNum=0;
%����ʵ����Ⱦ���
for i=1:pnum
    flag=0;  %֧���־
    for j=1:pnum
        if j~=i
            if (time(i)>time(j) && ratio(i)<ratio(j))
                flag=1;%��֧���־
                break;
            end
        end
    end
    
    %�ж����ޱ�֧��
    if flag==0
        fljNum=fljNum+1;
        % ��¼���ӽ�
        flj(fljNum,1)=time(i);
        flj(fljNum,2)=ratio(i);      

        % ���ӽ�λ��
        fljx(fljNum,:)=x(i,:); 
    end
end


%% ѭ������
for iter=1:T
    
    % Ȩֵ����
    %w=wmin+(wmax-wmin)*exp(-iter);
     
    %�ӷ��ӽ���ѡ��������Ϊȫ�����Ž�
    s=size(fljx,1);       
    index=randi(s,1,1);  
    gbest=fljx(index,:);

    %% Ⱥ�����
    for i=1:pnum
        %�ٶȸ���
        %v(i,:) = w*v(i,:) + rand*(gbest-v(i,:));
        v(i,:) = v(i,:) + rand*(gbest-v(i,:));
        %λ�ø���
        x(i,:)   = x(i,:)*(1-exp(-R*iter))+ v(i,:);
        %Խ���жϣ�ֻ�ж��ٶ�
        for j=1:D
            if(x(i,j)>round(2))||(x(i,j)<round(1))
                x(i,j) = round(1) + (round(2)-round(1))*rand;
            end
        end
    end

    %% ���������Ӧ��
    tiPrior(:)=0;
    ratioPrior(:)=0;
    for i=1:pnum
        xsort = x(i,:); 
        [~,pos] = sort(xsort);
        lsort = list(1,pos);
        [tiPrior(i),ratioPrior(i)] = Schedule(A,B,dnum,lsort);
    end
    
    %% ����������ʷ���
    %for %i=1:xSize
        %for j=1:xSize
        %���ڵ�֧��ԭ�еģ����ԭ�е�
        % if ((cost(i)<cost(j)) &&  (time(i)<time(j)) && reliable(i)>reliable(j) && ec(i)<ec(j))
         %       xbest(i,:)=x(i,:);%      û�м�¼Ŀ��ֵ
          %      cobest(i)=coPrior(i);
           %     tibest(i)=tiPrior(i);
            %    rebest(i)=rePrior(i);
             %   ecbest(i)=ecPrior(i);
       % elseif rand(1,1)<0.5
        %        xbest(i,:)=x(i,:);
         %       cobest(i)=coPrior(i);
          %      tibest(i)=tiPrior(i);
           %     rebest(i)=rePrior(i);
            %    ecbest(i)=ecPrior(i);
         %end
        %end
    %end
 %% ����������ʷ���
    for i=1:pnum
         if ((tibest(i)>tiPrior(i)) && ratiobest(i)<ratioPrior(i))
                xbest(i,:)=x(i,:);%      û�м�¼Ŀ��
                tibest(i)=tiPrior(i);
                ratiobest(i)=ratioPrior(i);
        elseif rand(1,1)<0.1
                xbest(i,:)=x(i,:);
                tibest(i)=tiPrior(i);
                ratiobest(i)=ratioPrior(i);
        end
    end
    %% ���·��ӽ⼯��
    time=tiPrior;
    ratio=ratioPrior;
    %�����������ӽ⼯��
    s=size(flj,1);%Ŀǰ���ӽ⼯����Ԫ�ظ���
   
    %�Ƚ����ӽ⼯�Ϻ�xbest�ϲ�
    tttx=zeros(1,s+pnum);
    rrrx=zeros(1,s+pnum);
    
    tttx(1:pnum)=tibest;tttx(pnum+1:end)=flj(:,1)';
    rrrx(1:pnum)=ratiobest;rrrx(pnum+1:end)=flj(:,2)';
    
    xxbest=zeros(s+pnum,D);
    xxbest(1:pnum,:)=xbest;
    xxbest(pnum+1:end,:)=fljx;
   
    %ɸѡ���ӽ�
    flj=[];
    fljx=[];
    k=0;
    tol=1e-7;
    for i=1:pnum+s
        flag=0;%û�б�֧��
        %�жϸõ��Ƿ����
        for j=1:pnum+s 
            if j~=i
                if ((tttx(i)>tttx(j)))&&(rrrx(i)<rrrx(j))  %��һ�α�֧��
                    flag=1;
                    break;
                end
            end
        end

        %�ж����ޱ�֧��
        if flag==0
            k=k+1;
            flj(k,1)=tttx(i);flj(k,2)=rrrx(i);%��¼���ӽ�
            fljx(k,:)=xxbest(i,:);%���ӽ�λ��
        end
    end
    
    %ȥ���ظ�����
    repflag=0;   %�ظ���־
    k=1;         %��ͬ���ӽ�������
    flj2=[];     %�洢��ͬ���ӽ�
    fljx2=[];    %�洢��ͬ���ӽ�����λ��
    flj2(k,:)=flj(1,:);
    fljx2(k,:)=fljx(1,:);
    for j=2:size(flj,1)
        repflag=0;  %�ظ���־
        for i=1:size(flj2,1)
            result=(fljx(j,:)==fljx2(i,:));
            if length(find(result==1))==D
                repflag=1;%���ظ�
            end
        end
        %���Ӳ�ͬ���洢
        if repflag==0 
            k=k+1;
            flj2(k,:)=flj(j,:);
            fljx2(k,:)=fljx(j,:);
        end
        
    end
    
    %���ӽ����
    flj=flj2;
    fljx=fljx2;
end
[~,i] = max(flj(:,1)./(1-flj(:,2)));
timebest = flj(i,1);
%�ɴ�fljx�б�����������
end
