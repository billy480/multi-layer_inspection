function [C,T]=run(tau,Lf,Lv,Lp,d0,d1,d2)    
    % complexite O(N)    space~O(time step)
    % Parameter set
    mu1=0.4; %0.2 0.4 0.8
    sigma1=0.3; % 0.1 0.3 0.5
    mu2=1.3;% 2 2.7 3.4
    sigma2=0.5; %0.3 0.5 0.8
    beta=0.15;%0.15
    alpha=0;
    %Lf=150;
    %Lp=100;
    %Lv=2;
    
    % Operation cost
    cia=5;% degradation inspection 5 10 15 20 25   无Lv检测时为0
    cib=15;% defect inspection 5 10 15 20 25
    cf=5000; %2500 3000 3500 4000 4500 
    cp=400; %200 250 300 350 400 
  
    % Parameter no.1
    %tau=7;
    %d1=20; % delay time of velocity
    %d2=15; % delay time of defection
    
    
    % Creation of defect point
    Expectation_def=20; %偏移的正态分布
    sigma_def=5.1;
    %Z=fix(randn()*sigma_def+Expectation_def);% 生成正态分布型Z

    % 设定形状参数 k（Weibull 分布常见形状参数为 2 接近正态分布）
    k = 2;  
    lambda = Expectation_def / gamma(1 + 1/k); % 计算对应的尺度参数

    % 生成一个 Weibull 分布的随机数
    U = rand(); % 生成一个 (0,1) 之间的均匀随机数
    Z = fix(lambda * (-log(U))^(1/k)); % 通过逆变换法生成 Weibull 分布随机数
    %k=3.7;
    %lambda=16.2;
    %U=rand();
    %Z=fix(lambda * (-log(1 - U))^(1/k));


    T_inf=30; %达到缺陷状态最多运行时间
    
    % Generation of Wiener process
    step=0.1;
    [t_1,X_1]=wiener(mu1,sigma1,Z,Z/step);
    [t_2,X_2]=wiener(mu2,sigma2,T_inf,T_inf/step);
    X_2=X_1(end)+X_2;
    t_2=t_1(end)+t_2;
    
    t=[t_1 t_2];
    X=[X_1 X_2];
    % Visulization of the degradation process
    %plot(t,X)
    %xlabel("time")
    %ylabel("Degradation value")
    %title("Degradation process")
    %hold on
    
    % Determination of the characteristic time based on thresholds
    Tf=t(find(X>Lf,1)); % failure appear
    Tp=t(find(X>Lp,1)); % threshold appear
    Z; % Defect appear
    % visulization
    %pf=plot(Tf,Lf,'.','color','g','MarkerSize',30)
    %pp=plot(Tp,Lp,'.','color','b','MarkerSize',30)
    %pd=plot(Z,0,'.','color','r','MarkerSize',30)
    
    % determination of the degradation velocity based on inspection
    % 计算速率向量，将得到的新矩阵与Lv进行比较,精确版本&高效版本
    %!!!!需要根据tau来计算
    %tins=t(mod(t,tau)==0); % inspection time
    %Xins=X(1+tins/step); % perfect degradation inspection
    
    %暂时不需要了，因为我们可以模拟在每次检测的时候得到结果
    %scanning_length=1;
    %dX=[Xins 0]-[0 Xins]; % point 1-point 0 
    %dt=[tins 0]-[0 tins]; % represents the slope beteween this point and the point before
    %Vall=dX./dt;
    %Tv=tins(find(Vall>Lv,1)); % find Tv from the inspection interval
    %Xv=Xins(find(Vall>Lv,1));
    %visualization
    %scatter(tins,Xins)
    %pv=plot(Tv,Xv,'*','color','b','MarkerSize',30)
    %legend([pf,pp,pd,pv],'failure','replacement threshold','defect',"velocity threshold")
    %hold off;
    
    
    % Maintenance policy
    % Complexity O（N）
    i=0;
    T_max=max(t);
    C=0;
    T=0;
    f=0; %determine if Tmax is changed
    velocity=0;
    while (T<T_max)
        i=i+1;
        C=C+cia;
        if i>1
            velocity=(X((T+1)/step)-X((T-tau+1)/step))/tau;
        end
        T=T+tau;
        if T>=Tf %直接失败的惩罚
            T_max=Tf;
            C=C+cf;
            break 
        elseif velocity>Lv 
            if T<Z
                %disp("false");
            end
            T_max=T+d1;
            % delay time model (TBM)
            T=T_max;
            if T>=Tf
                C=C+cf;
            end   
            break
        elseif T>Tp
            T_max=T+d0;
            % delay time model (TBM)
            T=T_max;
            if T>=Tf
                C=C+cf;
            end 
            break
        end

        C=C+cib;
        if T>Z % FN
            b=rand(); %generate random number between 0 1
            if b>beta  %defect detected    这种方法有一个缺点在于，velocity没有超过，但是defect已经被检测到了。不过这点被Lp compense了
                T_max=T+d2;
                % delay time model (TBM)
                T=T_max;
                if T>=Tf
                    C=C+cf;
                end
                break
            end
        else     % FP 双重检验
            a=rand();
            if a<alpha && (velocity>Lv || T>20) %FP 速度小于阈值就可判断FP，而速度大于阈值确定进入defect。 velocity 有一个双向作用
                %但是，velocity前面已经判断过铁不会超过Lv，否则早就停了。这个代码和前面的代码发生条件相同。
                %是否可以设置在一定时间之前我们遵循这种规则用来排除FP，在一定时间之后遵循另一种规则排除FN
                %which means， T 在一定范围内，我们只采用阈值，在一定范围之后，我们采用多层检测。
                %或者完全不用这么搞，保留原来的公式，只添加FP的情况，若
                %或者直接双阈值，大于高阈值，直接延期，大于低阈值，考虑FP可能性
                %总结一下，若大于Lvh，确定FN；若小于Lvl,确定FP；若在二者中间，需要TypeB检查
                %难点，number of inspection?
                %两个选择，要么控制TYPE B inpection延迟T进行，要么整个高低阈值---》用来解决FP占大头的问题
                T_max=T+d2;
                % delay time model (TBM) 
                T=T_max;
                if T>=Tf
                    C=C+cf;
                end
                break
            end
        end

    end
    C=C+cp; %return 
    
    if T>=Tf % 排除冗余项
        C=C-cp;
    %elseif T>Tp
        %C=C-cp;
    end
    
end