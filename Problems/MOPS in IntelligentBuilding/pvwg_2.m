%matlab code for paper
%the objective function used in PICEAg
%
% clear;clc;
%original data of wind speed, solar irradiance and ambient temperature, and
%load profile data
function F=pvwg_2(P)
[hang,~]=size(P);

%% ev settings
n_EV=50;
mileage1 = Mileage(n_EV);
mileage2 = Mileage(n_EV);
T_arrive1=T_Arrive(n_EV);
T_arrive2=T_Arrive(n_EV);
T_peak=17*60;

Load_EV_hour_V2G_double=V2G_double(n_EV,T_peak,mileage1,mileage2,T_arrive1,T_arrive2);
ev_load=Load_EV_hour_V2G_double;
% Load_EV_hour_V2G_singl=V2G_singl(n_EV,mileage1);
% 
% ev_load=Load_EV_hour_V2G_singl;

load wind_pv_temp.txt;
load Load.txt;
%WG=wind_pv_temp(:,1);
WG=wind_pv_temp(4105:4128,1);
%S=wind_pv_temp(:,2);
S=wind_pv_temp(4105:4128,2);
%temp=wind_pv_temp(:,3);
temp=wind_pv_temp(4105:4128,3)+10;
lod=Load(4105:4128,1);
lod=[51.62 50.14 50.14 51.03 55.75 62.83 69.91 74.63 75.81 79.64...
    77.58 73.45 71.68 71.68 75.81 79.64 84.66 87.61 89.67 86.72...
    77.58 70.50 64.60 55.75].*30;
aircondition=[0,0,0,0,0,0,0,0,1098,0,1098,0,1098,0,1098,1098,0,1098,0,1098,0,1098,0,0];
tempIndoor=[26.7;25.8;24.8;23.9;25.2;26.5;27.8;28.9;23.1;28.7;24.5;30.1;26.8;32.6;28.3;26.9;32.2;27.1;30.7;25.2;28.7;23.2;26.8;27.2];
lod=lod+aircondition;
%���
price=[0.23 0.19 0.14 0.12 0.12 0.20 0.23 0.38 1.50 4.00 4.00 4.00...
        1.50 4.00 2.00 1.95 0.60 0.41 0.35 0.43 1.17 0.54 0.30 0.26]; 
%��������������
price_inter=[0.13 0.09 0.07 0.05 0.07 0.07 0.13 0.18 0.50 0.40 0.40 0.60...
        0.50 1.00 0.80 0.95 0.60 0.41 0.35 0.43 0.45 0.34 0.20 0.16]; 
%��ev�����óɱ�
C_ev=ev_load.*price';
for zz=1:24
    if C_ev(zz)>0
        C_ev(zz)=0;        
    end
    if C_ev(zz)<0
        C_ev(zz)=-C_ev(zz);
    end
end

for j=1:hang
lod=lod+P(j,5)*30;    
T=8760;                              %total time interval of one year
count=0;                             %����δ���㸺��
%% pv model, this model only consider the beam radiation
phi=41.65;    %���� latitude of zaragoza in Spain, N
lamda=1.02;     %solar ecliptic longitude of zaragoza in Spain, W
I=23.44;       %�������������
% belta=30;      %���Ż����� PV tilt angle
% Npv=5;           %���Ż����� number of PV modules
%belta=P(j,nvar);
belta=44.34487;
Npv=P(j,1);

NCOT=43;                                  %���ع����¶�
Ki=0.0038;                                %short-circuit current temperature coefficient  unit:A/C
Kv=0.067;                                 %������С��
                                  %open-circuit voltage  temperature coefficient  unit:V/C
Vocstc=21;
Iscstc=7.22;
% Vmax=17;
Vmax=9;

Imax=6.47;                                %�����110w
FF=Vmax*Imax/(Vocstc*Iscstc);             %fill factor
%delta:the longitude at the equator,̫����γ�ǣ��������������������֮��ļн�

%% the parameter of wind turbine�������
Vc=4;                                        %cut-in speed
Vr=14;                                       %rated wind speed
Vf=20;                                       %cut-off wind velocity
Cp=0.4;                                      %the limit of Cp is 0.593, that is Betz limit
rho=1.29;                                    %density of air  kg per m^3
r=2;                                         %radiur of wind turbine
alpha=0.14;                                  %wind speed power law efficient
Hr=10;                                       %reference height,unit:m
% Ht=25;                                       %the height of wind turbine ���Ż�����
% Nwg=2;                                       %���Ż��������������
%Ht=P(j,5);
% Ht=25;
Ht=18.86511;
Nwg=P(j,2);

Pwgr=10000;                                   %rated power 10 kw

Awg=pi*r^2;

%% battery parameter ��ز���
Cnb=100;                                   %nominal capacity of the battery, unit: Ah
% volt=12;                                  %volatage ,V
volt=3;     
% Vbus=48;
Vbus=12;
rtc=0.8;                                  %roundtrip efficiency in the charging process
rtd=1;                                    %roundtrip efficiency in the discharging process
% dod=0.8;
dod=0.8;
nbs=Vbus/volt;                            %number of batteries in series
% Nbat=3;                                   %number of battery bank  ���Ż�����
Nbat=P(j,3);
Cn1=Cnb*Nbat/nbs;                              %available capacity of the battery bank.    ����nbs,��Ҫ�������г���
 
%% diesel parameter

% Pndg=2000;                                  %diesel nominal capacity, unit:W
Pndg=200; 
afdg=0.08145;                              %�������ȼ�����Ĳ�����unit:l/kwh
bdg=0.246;                                 %�Ƕ������ȼ�����Ĳ���
% Ndg=2;                                      %���ͷ�������������Ż�����
Ndg=P(j,4);
inverter_dg=0.9;                            %��������������Ч��
Dp=Ndg*Pndg*inverter_dg;

ef=2.5;                                     %fuel emission factor kg/l

fa=5000;  %��Դ��ͨ��
U=0.8;    %��Դ����ϵ��
M=0.8;    %��Դά��ϵ��
A=100;    %�������
Eset=304; %����������׼ֵ
Tset=26;  %���������¶�

fuel_GS=zeros(1,24);
fuel_inter=zeros(1,24);
P_inter=zeros(1,24);
C_inter=zeros(1,24);
P_GS=zeros(1,24);
deltap=zeros(1,24);
p_in=zeros(1,24);
Se=zeros(1,24);
Ssto=zeros(1,24);
stab=zeros(1,24);
light=zeros(1,24);
lightComfort=zeros(1,24);
warmComfort=zeros(1,24);
%% power output
%for n=1:365
% for n=1:1
n=1;
    delta(n)=I*sin(2*pi*(284+n)/365);
    
    for t=0:23

        i=24*(n-1)+t+1;
        tao=2*pi*(12-t)/24;
        ele(i)=sin(phi*pi/180)*sin(delta(n)*pi/180)+cos(phi*pi/180)*cos(delta(n)*pi/180)*cos(tao);
         %��ֹ���ֹ�С�Ļ����������þ���
        if ele(i)<0.01
            ele(i)=0;
        end
        
        h(i)=asind(ele(i));                                        %����Զȱ�ʾ,̫���߶Ƚ�  elevation angle
        if h(i)<0||h(i)==0
            St(i)=0;
            Sp(i)=0;
        else
            St(i)=S(i)/ele(i);                                         %������б���ϵĲ���tilt
            Sp(i)=St(i)*sin((h(i)+belta)*pi/180);                               %��ֱ��б��Ĳ��֣���Ч���֣�pendicular
        end
       Tc(i)=temp(i)+(NCOT-20)*Sp(i)/800;
       Isc(i)=[Iscstc+Ki*(Tc(i)-25)]*Sp(i)/1000;
       Voc(i)=Vocstc-Kv*Tc(i);
       PV(i)=(Npv*Isc(i)*Voc(i)*FF);                                     %���ǹ������֮������������
       
       %% wind turbine
       V(i)=WG(i)*(Ht/Hr)^alpha;
       if V(i)<Vc
           Pwg(i)=0;
       elseif V(i)>Vc&&V(i)<Vr ||V(i)==Vc
           Pwg(i)=0.5*Cp*rho*Awg*V(i)^3;
       elseif V(i)>Vr&&V(i)<Vf||V(i)==Vr
           Pwg(i)=Pwgr;
       else V(i)>Vf||V(i)==Vf
           Pwg(i)=0;
       end
       PWG(i)=Nwg*Pwg(i);                                          %���Ƿ�����������������
           
     %% battery charging
     Cn(1)=Cn1;                                            %������ʼ����������
     deltat=1;                                             %ʱ����
     deltap(i)=PV(i)+PWG(i)-lod(i)-ev_load(i);

     if deltap(i)==0
         Cn(i+1)=Cn(i);
     elseif deltap(i)>0
         Cn(i+1)=Cn(i)+rtc*deltat*deltap(i)/Vbus;           %���
         if Cn(i+1)>Cn1
             Cn(i+1)=Cn1;
             P_inter(i)=-(deltap(i)-(Cn(i+1)-Cn(i))*deltat*Vbus);%��������� ���� ��ʾ����
             C_inter(i)=P_inter(i).*price_inter(i);%������������ķ���
         end
     else deltap(i)<0                                       %discharging
         Cn(i+1)=Cn(i)+rtd*deltat*deltap(i)/Vbus;
         if Cn(i+1)<Cn1*(1-dod)
             Cn(i+1)=Cn1*(1-dod);
             E(i)=abs((Cn(i)-Cn1*(1-dod))*deltat*Vbus+deltap(i));   %����ز������㸺�صĲ�ȡ����ֵ,���ɲ��ͷ�������磬�����ٴ����湺��
             if Ndg==0
                 fuel_GS(i)=0;
                 P_GS(i)=0;
                 p_in=E(i);
                 P_inter(i)=E(i);%���� ��ʾ���
                 C_inter(i)=P_inter(i).*price_inter(i);
                 fuel_inter(i)=P_inter(i).*(997*0.02+272*0.12);
                 count=count+1;
             else
%                  if E(i)<Dp
%                      fuel(i)=bdg*E(i)/1000;                                           %���ݹ����������ȼ������,deltat=1h,����ʡ��
%                  elseif E(i)==Dp
%                      fuel(i)=afdg*Dp/1000;                                         %������������ȼ������
%                  else E(i)>Dp
%                      fuel(i)=afdg*Dp/1000;
%                      count=count+1;                                               %����������LPSP
%                  end
                 
                  if  E(i)>Dp                                                        %����dufo�Ĺ�ʽ����ȼ������
                     fuel_GS(i)=afdg*Dp/100+bdg*Dp/100;
                     P_GS(i)=Dp;
                     count=count+1;                                                 %����������LPSP
                     E(i)=E(i)-Dp;
                     p_in=E(i);
                     P_inter(i)=E(i);
                     C_inter(i)=P_inter(i).*price_inter(i);
                     fuel_inter(i)=P_inter(i).*(0.997*0.02+0.272*0.12);

                 else
%                      fuel(i)=afdg*Dp/1000+bdg*E(i)/1000;
                     fuel_GS(i)=afdg*Dp/100+bdg*E(i)/100;
                     P_GS(i)=E(i);
                 end
             end
         end
     end
     if (PV(i)+PWG(i))<0.15*lod(i)
         Se(i)=1;
     else
         
         if P_inter(i)>0.15*lod(i)
             Se(i)=0;
         else
             Se(i)=1-(lod(i)+ev_load(i)-P_GS(i)+(Cn(i+1)-Cn(i))*Vbus-0.15*lod(i))./(PV(i)+PWG(i));
         end
         
%          if Se(i)>1
%              Se(i)=1;
%          end
     end
%      tem=ev_load(i);
     if ev_load(i)>0
         tem_ev=0;
     else
         tem_ev=-ev_load(i);
     end

     tem=(Cn(i)-Cn1*(1-dod))*deltat*Vbus+tem_ev;
     if tem<lod(i)*0.17
         Ssto(i)=tem/(lod(i)*0.17);
     else
         Ssto(i)=1;
     end
     
     stab(i)=0.8*Se(i)+0.2*Ssto(i);
     light(i)=(P(j,4)*fa*U*M)/A;
     lightComfort(i)=1-((light(i)-Eset)/Eset)^2;
     warmComfort(i)=1-((tempIndoor(i)-Tset)/Tset)^2;
       
%     end
 end

total_fuel_GS=sum(fuel_GS);                    %�ܵ�GSȼ������
emission=ef*total_fuel_GS;                 %GS������̼�ŷţ�kg,һ���Ż�Ŀ��
c_fuel_GS=emission*0.24;  %GS��Ⱦ����ɱ�

c_GS_sum=sum(P_GS)*0.24;%���鷢���

c_inter=sum(C_inter);%���������������

c_fuel_inter=sum(fuel_inter);%�����������Ⱦ�ķ���

c_fuel_total=c_fuel_GS+c_fuel_inter;%�ܵ���Ⱦ�������

% c_PV=Npv*20;
c_PV=Npv*10;
% c_WT=Nwg*10;
c_WT=Nwg*15;
c_BAT=Nbat*18;
c_GS=Ndg*30;
c_total=c_GS+c_GS_sum+c_PV+c_WT+c_BAT+sum(C_ev)+c_inter;%�ܵĳɱ�

p_total=sum(P_GS)+sum(PV)+sum(PWG)+sum(p_in);
y(j,1)=c_total;

% y(j,2)=c_fuel_total./p_total;
y(j,2)=1-(0.5*sum(lightComfort)+0.5*sum(warmComfort))/24;

y(j,3)=1-sum(stab)/24;

% total_fuel=sum(fuel);                           %�ܵ�ȼ������
% emission=ef*total_fuel;                          %������̼�ŷţ�kg,һ���Ż�Ŀ��
% y(j,1)=emission;                                %��һ��Ŀ��
% LPSP=count/T*100;                                   %loss of power supply probability, �ٷֱ�
% y(j,2)=LPSP;
% Tdg=size(find(fuel>0),2);                       %���ͷ��������ʱ�䣬h
% 
% %% cost of components
% Cappv=3000;                                   %Capital (acquisition) cost of PV, unit:$
% Capwg=3013;
% Captow=250;                                   %initial capital cost of wind turbine tower,unit:$/m
% Capbat=126;                                   %1032 dufo��
% Capdg=1514;
% OMpv=30;                                      %unit:$/year
% OMwg=50;
% OMtow=2.5;                                    %tower maintenance cost  $/m
% OMbat=1.26;                                 
% OMdg=0.17;                                    %unit: $/h ÿСʱ
% REPbat=126;                                   %replacement of battery 
% fuel_price=1.2;                               %ȼ�ϼ۸�
% i_n=0.0375;                                   %nominal interest rate
% inf=0.015;                                    %inflation rate
% Lifet=25;                                     %the component lifetime 
% Lbat=5;                                       %the battery lifetime     ��Ϊ5�����г���
% 
% 
% i_real=(i_n-inf)/(1+inf);                     %the annual real interest
% crf=i_real*(1+i_real)^Lifet/((1+i_real)^Lifet-1);                      %CRF-capital recovery factor
% sff=i_real/((1+i_real)^Lbat-1);                                        %SFF-sinking fund factor
% Cacap=Npv*Cappv*crf+Nwg*(Capwg+Captow*Ht)*crf+Nbat*Capbat*crf+Ndg*Capdg*crf;                      %����ʱ��ɱ�
% Carep=Nbat*REPbat*sff;                                                                %�滻�ɱ���ֻ���ǵ�����滻
% Camain=Npv*OMpv+Nwg*(OMwg+OMtow*Ht)+Nbat*OMbat+Ndg*OMdg*Tdg+total_fuel*fuel_price;                                     %maintenance cost
% ACS=Cacap+Carep+Camain;                                                              %�ܵ���ȳɱ�
% y(j,3)=ACS;

end
F=y;



