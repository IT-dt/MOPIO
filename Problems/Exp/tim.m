function Time = tim( group )
%TIM �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
load time.txt
Time = time((group-1)*6+1:group*6,:);
end

