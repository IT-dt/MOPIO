function [out] = relation(a,b,num,t)

%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
out=0;
for i=1:num
    for j=i:num
        if j~=i
        out=b(a(t,i),a(t,j))+out;
        end
    end
end
end

