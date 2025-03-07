function [t,W]=wiener(mu,sigma,T,N)    
    % 初始化数组
    W = zeros(1,N+1); % 维纳过程的离散化表示
    t = linspace(0,T,N+1); % 时间网格
    
    % 生成维纳过程
    W(1) = 0; % 初始值为0
    for i = 2:N+1
        W(i) = W(i-1) + T/N*mu + sqrt(T/N)* sigma*randn; % 使用欧拉-马斯特隆方法
    end
    
    % 绘制维纳过程
    %plot(t,W);
    %xlabel('时间');
    %ylabel('维纳过程');
    %title('维纳过程的模拟');
end