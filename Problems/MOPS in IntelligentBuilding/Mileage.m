function mileage=Mileage(n_EV)
%n_EV=100;
mu_d=3.2;sigma_d=0.88;
SOC_max=0.9;SOC_min=0.3;
eta_EV=20/100;  %ÿ��km�ĵ���20kWh
ca=50; %�����Ч����50kWh


%����ʻ�����
mileage=lognrnd(mu_d,sigma_d,1,n_EV);
mileage_max=((SOC_max-SOC_min)*ca)/eta_EV;
mileage_max=repmat(mileage_max,1,n_EV);
mileage=(mileage>mileage_max).*mileage_max+(mileage<=mileage_max).*mileage;