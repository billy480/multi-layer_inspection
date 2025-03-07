    % Creation of defect point
    Expectation_def=20; %偏移的正态分布
    sigma_def=5.1;
    %Z=fix(randn()*sigma_def+Expectation_def);% 生成正态分布型Z

    % 设定形状参数 k（Weibull 分布常见形状参数为 2 接近正态分布）
    k = 2;  
    lambda = Expectation_def / gamma(1 + 1/k) % 计算对应的尺度参数

    % 生成一个 Weibull 分布的随机数
    U = rand(); % 生成一个 (0,1) 之间的均匀随机数
    Z = fix(lambda * (-log(U))^(1/k)) % 通过逆变换法生成 Weibull 分布随机数