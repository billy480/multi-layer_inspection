%%code for optimization by enumerating all possible integer values

tau=5:1:10;%5:1:8; % 1:1:15
Lp=10:1:15;%15:1:20; % 10:1:25
Lv=0.4*1.5:0.1:0.4*3.5;%0.4*1.5:0.1:0.4*3.5;
%d1=0;
Lv=0;
M=zeros(length(tau),length(Lp),length(Lv));
for i =1:length(tau)
    for j=1:length(Lp)
        for z=1:length(Lv)
            M(i,j,z)=monte(tau(i),Lp(j),Lv(z));
        end
    end
end


% 坐标可视化
% 找到最小值及其线性索引
% 将线性索引转换为三维坐标,注意，此处为相对坐标，optimized value需要加上相应的偏移
[minVal, linearIdx] = min(M(:));
[x, y, z] = ind2sub(size(M), linearIdx);
opt_tau = tau(x);
opt_Lp = Lp(y);
opt_Lv = Lv(z);

disp(['最小值: ', num2str(minVal)]);
disp(['坐标: (', num2str(opt_tau), ', ', num2str(opt_Lp), ', ', num2str(opt_Lv), ')']);
f=msgbox("simulation is over");