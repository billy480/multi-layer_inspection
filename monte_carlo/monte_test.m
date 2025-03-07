
%% monte carlo simulation
Csum=0;
Tsum=0;
Niter=10000;
for i=1:Niter
    %% Parameter no.1
    tau=7;
    d0=1;% delay time of threshold
    d1=1; % delay time of velocity
    d2=1; % delay time of defection
    Lp=100;
    
    % Para threshold
    Lf=38;
    Lv=0.1; % velocity maintenance negligeable when inf
    [C,T]=run(tau,Lf,Lv,Lp,d0,d1,d2); % comlpexity ~O(N) total~O(N*Niter)
    Csum=C+Csum;
    Tsum=T+Tsum;
end

% 确实可以更早预测到defect的发生，但是对T/C无太多影响？！！！需要更改一些参数和定义！！！
% 尝试1：d1和d2延迟时间时啥都不干，只failure的发生负责 i.e. C+=cf  
% 结果1：拥有velocity策略的CperT确实减小了不少 
% 猜测优势在于，我们可以更早预测到defect，从而延长了d的时间（TBM 
% 但是，现在只是初步计算，真正的两个策略还需要从ABC中得出，有可能出现相反结果（risky

E_C=Csum/Niter;
E_T=Tsum/Niter;
E_CperT=Csum/Tsum