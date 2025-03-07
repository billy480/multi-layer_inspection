% 找到最小值及其线性索引
[minVal, linearIdx] = min(M(:));

% 将线性索引转换为三维坐标,注意，此处为相对坐标，optimized value需要加上相应的偏移
[x, y, z] = ind2sub(size(M), linearIdx);
x=x;
y=y;
z=z;
% 显示最小值和坐标
disp(['最小值: ', num2str(minVal)]);
disp(['坐标: (', num2str(x), ', ', num2str(y), ', ', num2str(z), ')']);
