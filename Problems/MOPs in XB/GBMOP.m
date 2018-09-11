function varargout = GBMOP(Operation,Global,input)
% <problem> <Green Building MOP>
% Green Building Multi-objective optimization problem
% operator --- EAbinary ��xb��ע��������

%--------------------------------------------------------------------------
% ��ɫ������Ŀ���Ż�����.
%--------------------------------------------------------------------------

% Copyright (c) XB

persistent P W;

    switch Operation   %xb��ע:����������3��
        case 'init' %xb��ע:1����ʼ��
            Global.M        = 2; %xb��ע��18��08��09��2133��:����Ҫ��Ŀ�����
            Global.D        = 10; %xb��ע��18��08��09��2134��:����Ҫ�����������ά��
            Global.operator = @EAbinary; %xb��ע:����Ҫ��ָ���ݻ����̲��õ��ݻ��㷨������PSO��DE��EAbinary��EAreal�ȣ������OperatorsĿ¼�������������޸�Ϊ��Ⱥ����Ⱥ��
            
            [P,W] = Global.ParameterFile(sprintf('MOKP-M%d-D%d',Global.M,Global.D),randi([10,100],Global.M,Global.D),randi([10,100],Global.M,Global.D));
            
            PopDec    = randi([0,1],input,Global.D); %xb��ע��18��08��09��2254��:����Ҫ����ʼ������󣬽�������μ�����Ľ��͡�ע�⣬��Ⱥ�н����ĿN����ͨ���������á��˴����Ե���Global.N����GLOBAL����Ĭ������Ϊ100���л�ø�ֵ�����ά�ȴ�Global.M�����Դӽ���ͱ��������ø�ֵ����á�
            PopDec    = GBMOP('value',Global,PopDec);
            varargout = {PopDec}; %xb��ע��18��08��09��2303��:����Ҫ
        case 'value' %xb��ע��18��08��09��2233��:2��ʵ�ʼ�����̡���������input����Ӧ�ĸ���Ŀ�꺯��ֵ�������ء�ע�⣬inputÿһ�д���һ��������Ҳ��������Ľ⡣
            %xb��ע��18��08��09��2239��:���� 
%             input=[1,2;3,4;5,6] ���3*2���󣬰���3���⣬[1,2]��[3,4]��[5,6]��ÿ�����ά��Ϊ2
%             ��Ӧ�ģ�����2��Ŀ�꺯������PopObjΪ2*3����
%             PopObj=[11,22,33;44,55,66]����ʾ
%             ���ڽ�[1,2]����Ӧ����Ŀ��1����ֵΪ��11����Ӧ����Ŀ��2����ֵΪ��44
%             ���ڽ�[3,4]����Ӧ����Ŀ��1����ֵΪ��22����Ӧ����Ŀ��2����ֵΪ��55
%             ���ڽ�[5,6]����Ӧ����Ŀ��1����ֵΪ��33����Ӧ����Ŀ��2����ֵΪ��66
            X = input; %xb��ע��18��08��09��2304��:����Ҫ��ֻ��һ����ֵ����������ͨ��varargout = {X,PopObj,PopCon};����
            C = sum(W,2)/2;
            [~,rank] = sort(max(P./W));
            for i = 1 : size(X,1)
                while any(W*X(i,:)'>C)
                    k = find(X(i,rank),1);
                    X(i,rank(k)) = 0;
                end
            end
            
            PopObj = repmat(sum(P,2)',size(X,1),1) - X*P'; %xb��ע��18��08��09��2303��:����Ҫ������ʵ�ʼ��㷽ʽ�޸�
            
            PopCon = [];
            
            varargout = {X,PopObj,PopCon}; %xb��ע��18��08��09��2249��:����Ҫ
        case 'PF' %xb��ע��18��08��09��2234��:3����ʵPareto Front�����ö�Ŀ��������ʵPFδ֪�������������ã�������Ϊ�ο��㣬����IDG��
            RefPoint  = sum(P,2)';
            varargout = {RefPoint}; %xb��ע��18��08��09��2305��:����Ҫ���˴��Ĳο��㣬���ǿ������������úã����磬ͨ��������к󣬻�õĽ���PF�⼯�У�������н��ÿ��ά�ȣ����ÿ��ά�ȵ����ֵ���γ�һ���������ŵ������Ϊ�ο���
        case 'draw' %xb��ע��18��08��09��2306��:����Ҫ
            cla; Draw(input*P');
    end
end