%%code for optimization by enumerating all possible integer values

% 定义优化变量
tau = optimizableVariable('tau', [5, 12], 'Type', 'integer');
Lp  = optimizableVariable('Lp',  [10, 20], 'Type', 'integer');
Lv = optimizableVariable('Lv', [0.6, 1.4], 'Type', 'real');

% 定义目标函数句柄
obj = @(x)obj_fun(x);  % 用上面定义的 obj_fun

% 运行贝叶斯优化
results = bayesopt(obj, [tau, Lp, Lv], ...
    'IsObjectiveDeterministic', true, ...
    'AcquisitionFunctionName', 'expected-improvement-plus', ...
    'MaxObjectiveEvaluations', 30);  % 可调，控制 BO 迭代次数

best_x = results.XAtMinObjective;
best_tau = best_x.tau;
best_Lp = best_x.Lp;
best_val = results.MinObjective;