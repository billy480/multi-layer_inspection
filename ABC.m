%ABC
%goal minimization of f(tau,d1,d2)

%%%%%ARTIFICIAL BEE COLONY ALGORITHM%%%%

%Artificial Bee Colony Algorithm was developed by Dervis Karaboga in 2005 
%by simulating the foraging behaviour of bees.

%Copyright @2008 Erciyes University, Intelligent Systems Research Group, The Dept. of Computer Engineering

%Contact:
%Dervis Karaboga (karaboga@erciyes.edu.tr )
%Bahriye Basturk Akay (bahriye@erciyes.edu.tr)


clear all
close all
clc



% 设置 ABC 算法控制参数
% 三连点(省略号)...表示续行。
% 当一行内语句太长，可以使用三个点...表示续行，另起一行。
ABCOpts = struct( 'ColonySize',  3, ...            % 雇佣蜂数量+ 观察蜂数量 
    'MaxCycles', 2000,...                           % 终止算法的最大周期数
    'ErrGoal',     1e-2, ...                       % 错误目标，以便终止算法（在当前版本的代码中没有使用）。
    'Dim',       3 , ...                           % 目标函数的参数维度 dimention
    'Limit',   100, ...                             % 控制参数，以便放弃食物来源 
    'lb',  30, ...                                  % 待优化参数的下限
    'ub',  0, ...                                   % 待优化参数的上限
    'ObjFun' , 'rosenbrock', ...                    % 写出你想最小化的目标函数的名称
    'RunTime',3);                                   % 运行的次数



GlobalMins=zeros(ABCOpts.RunTime,ABCOpts.MaxCycles);% 运行次数以及终止最大周期数

for r=1:ABCOpts.RunTime                             % 外层循环——运行次数
    
    % 初始化种群
    Range = repmat((ABCOpts.ub-ABCOpts.lb),[ABCOpts.ColonySize ABCOpts.Dim]); % 初始化每一维度的范围
    Lower = repmat(ABCOpts.lb, [ABCOpts.ColonySize ABCOpts.Dim]);             % 初始化每一维度的下限
    Colony = rand(ABCOpts.ColonySize,ABCOpts.Dim) .* Range + Lower;           % 在每一维度的范围内，随机初始化种群

    Employed=Colony(1:(ABCOpts.ColonySize/2),:);                              % 前一半个体为雇佣蜂


    % 评估和计算适应度
    ObjEmp=feval(ABCOpts.ObjFun,Employed);                      % 计算函数值
    FitEmp=calculateFitness(ObjEmp);                            % 计算适应度

    % 设置雇佣蜂Bas的初始值为0，表示没有改进的次数为0
    Bas=zeros(1,(ABCOpts.ColonySize/2));            


    GlobalMin=ObjEmp(find(ObjEmp==min(ObjEmp),end));            % 雇佣蜂中的最优函数值
    GlobalParams=Employed(find(ObjEmp==min(ObjEmp),end),:);     % 雇佣蜂中的最优解

    Cycle=1;                                                    % 从 1 开始
    while ((Cycle <= ABCOpts.MaxCycles))                        % 开始进行迭代

        %%%%% 雇佣阶段
        Employed2=Employed;                                     % 新一代雇佣蜂
        for i=1:ABCOpts.ColonySize/2                            % 遍历雇佣蜂个体
            Param2Change=fix(rand*ABCOpts.Dim)+1;               % 选择更改的维度
            neighbour=fix(rand*(ABCOpts.ColonySize/2))+1;       % 选择更改的蜜蜂
                while(neighbour==i)                             % 保证需要更改的蜜蜂不和当前蜜蜂相同
                    neighbour=fix(rand*(ABCOpts.ColonySize/2))+1;
                end
            % 产生新的群体
            Employed2(i,Param2Change)=Employed(i,Param2Change)+(Employed(i,Param2Change)-Employed(neighbour,Param2Change))*(rand-0.5)*2;
            % 限制范围
            if (Employed2(i,Param2Change)<ABCOpts.lb)
                Employed2(i,Param2Change)=ABCOpts.lb;
            end
            if (Employed2(i,Param2Change)>ABCOpts.ub)
                Employed2(i,Param2Change)=ABCOpts.ub;
            end

        end   

        ObjEmp2=feval(ABCOpts.ObjFun,Employed2);                % 重新评估
        FitEmp2=calculateFitness(ObjEmp2);                      % 重新计算适应度
        % 进行贪婪选择
        [Employed, ObjEmp, FitEmp, Bas]=GreedySelection(Employed,Employed2,ObjEmp,ObjEmp2,FitEmp,FitEmp2,Bas,ABCOpts);

        % 根据适应度正则化为概率
        NormFit=FitEmp/sum(FitEmp);

        %%% 观察阶段
        Employed2=Employed;                                         % 将新老种群同步
        i=1;
        t=0;
        while(t<ABCOpts.ColonySize/2)                               % 进行观察
            if(rand<NormFit(i))                                     % 进行轮盘赌
                t=t+1;                                              % 记忆轮盘赌的次数
                Param2Change=fix(rand*ABCOpts.Dim)+1;               % 获取观察选择的维度
                neighbour=fix(rand*(ABCOpts.ColonySize/2))+1;       % 选择一个被观察的个体
                    while(neighbour==i)                             % 被观察个体不能与当前个体相同
                        neighbour=fix(rand*(ABCOpts.ColonySize/2))+1;
                    end
                Employed2(i,:)=Employed(i,:);                       % 由于上次的被观察，可能导致观察蜂和雇佣蜂不一致
                % 进行观察
                Employed2(i,Param2Change)=Employed(i,Param2Change)+(Employed(i,Param2Change)-Employed(neighbour,Param2Change))*(rand-0.5)*2;

                if (Employed2(i,Param2Change)<ABCOpts.lb)           % 如果超出下限
                    Employed2(i,Param2Change)=ABCOpts.lb;           % 置为下限
                end
                if (Employed2(i,Param2Change)>ABCOpts.ub)           % 如果超出上限
                    Employed2(i,Param2Change)=ABCOpts.ub;           % 置为上限
                end
            ObjEmp2=feval(ABCOpts.ObjFun,Employed2);                % 计算目标函数值
            FitEmp2=calculateFitness(ObjEmp2);                      % 计算适应度
            % 进行贪心选择
            [Employed, ObjEmp, FitEmp, Bas]=GreedySelection(Employed,Employed2,ObjEmp,ObjEmp2,FitEmp,FitEmp2,Bas,ABCOpts,i);
            end
            i=i+1;                                                  % i+1，下一个个体被观察
            if (i==(ABCOpts.ColonySize/2)+1)                        % 如果 i 超出索引
                i=1;                                                % 重新置为 1
            end   
        end


         %%% 记录最优个体
         CycleBestIndex=find(FitEmp==max(FitEmp));                  % 寻找最优个体，可能是多个
         CycleBestIndex=CycleBestIndex(end);                        % 选择最后一个，变为1个
         CycleBestParams=Employed(CycleBestIndex,:);                % 记录它的参数
         CycleMin=ObjEmp(CycleBestIndex);                           % 记录目标函数值

         if CycleMin<GlobalMin                                      % 记录全局最优个体，防止最优个体丢失
               GlobalMin=CycleMin;
               GlobalParams=CycleBestParams;
         end

         GlobalMins(r,Cycle)=GlobalMin;                             % 追踪每一次循环的最优个体

        %% 侦察阶段
        ind=find(Bas==max(Bas));                                    % 查找没有变优次数最多的个体
        ind=ind(end);                                               % 可能有很多个，选择最后一个
        if (Bas(ind)>ABCOpts.Limit)                                 % 判断是否大于限制
        Bas(ind)=0;                                                 % 重新开始计数
        Employed(ind,:)=(ABCOpts.ub-ABCOpts.lb)*(0.5-rand(1,ABCOpts.Dim))*2;% 进行侦察操作
        %message=strcat('burada',num2str(ind))
        end
        ObjEmp=feval(ABCOpts.ObjFun,Employed);                      % 重新评估种群
        FitEmp=calculateFitness(ObjEmp);                            % 计算适应值函数
        fprintf('Cycle=%d ObjVal=%g\n',Cycle,GlobalMin);        % 打印每个cycle的最优个体
        Cycle=Cycle+1;
    end % End of ABC
end %end of runs

semilogy(mean(GlobalMins))
title('Mean of Best function values');
xlabel('cycles');
ylabel('error');
fprintf('Mean =%g Std=%g\n',mean(GlobalMins(:,end)),std(GlobalMins(:,end)));


