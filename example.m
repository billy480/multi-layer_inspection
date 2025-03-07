syms t z LjT jT T Lnor fd1 fs hZ Fd

% 定义被积函数
integrand = fd1*(LjT - jT)*fs*hZ*Fd; 

% 三重积分
result = int(int(int(integrand, LjT, 1, Lnor), z, t, jT), t, jT, jT + T);
disp(result);


grad_g = diff(result, T); % 计算梯度（导数）
disp(grad_g); % 显示梯度


% 转化为数值函数
g_num = matlabFunction(result); % 数值目标函数
grad_g_num = matlabFunction(grad_g); % 数值梯度

% Newton-Raphson 迭代
x0 = 5; % 初始猜测
tol = 1e-6; % 收敛阈值
max_iter = 100; % 最大迭代次数

for iter = 1:max_iter
    x_new = x0 - g_num(x0) / grad_g_num(x0); % 更新
    if abs(x_new - x0) < tol % 判断收敛
        fprintf('收敛到 x = %.6f, 经过 %d 次迭代\n', x_new, iter);
        break;
    end
    x0 = x_new; % 更新当前值
end

if iter == max_iter
    disp('未在最大迭代次数内收敛');
end