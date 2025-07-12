% 选择 d0 = 0，即 z = 1 的切片
[dX, dY] = meshgrid(Lp,tau);
figure;
s=mesh(dX, dY, M(:, :, 5)); % 选择 d0=0 的数据
s.FaceColor = 'flat';
s.EdgeColor='black';
s.LineWidth=1;
xlabel('Lp(dB)');
ylabel('τ(week)');
zlabel('cost rate');
colorbar; % 添加颜色条


% 确保 meshplot 目录存在
output_folder = 'meshplot';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% 保存图像
output_file = fullfile(output_folder, 'meshplot_policy_C.png');
saveas(gcf, output_file);  % 保存为 PNG 图片

disp(['Mesh plot saved to: ', output_file]);