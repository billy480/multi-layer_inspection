%%code for optimization by enumerating all possible integer values

tau=10:1:14;
Lp=9:1:14;
d1=0:1:15;
%d1=0;
M=zeros(length(tau),length(Lp),length(d1));
for i =1:length(tau)
    for j=1:length(Lp)
        for z=1:length(d1)
            M(i,j,z)=monte(tau(i),Lp(j),d1(z));
        end
    end
end


% 坐标可视化
% 找到最小值及其线性索引
[minVal, linearIdx] = min(M(:));

% 将线性索引转换为三维坐标,注意，此处为相对坐标，optimized value需要加上相应的偏移
[x, y, z] = ind2sub(size(M), linearIdx);
x=x+min(tau)-1;
y=y+min(Lp)-1;
z=z+min(d1)-1;
% 显示最小值和坐标
disp(['最小值: ', num2str(minVal)]);
disp(['坐标: (', num2str(x), ', ', num2str(y), ', ', num2str(z), ')']);
