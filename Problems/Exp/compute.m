function time = compute(group)
    for i=1:size(group,2)
       Dev = dev(group(i)); % ȡ���豸����
       Time = tim(group(i)); % ȡ��ʱ�����
       list = init(Dev);
       timev = timev + Scheduling(Dev,Time,4,list);
    end
    time = timev;
end