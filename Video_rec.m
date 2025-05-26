
videoFile = 'butane_clip.mp4';
vid = VideoReader(videoFile);
firstFrame = readFrame(vid);

imshow(firstFrame);
title('DrawIntered');
hold on;

% --- 步骤 2：手动绘制多个矩形区域 ---
ROIs = {};  % 存储矩形对象
while true
    h = drawrectangle();  % 鼠标画矩形
    if isempty(h); break; end  % 按回车退出
    ROIs{end+1} = h;  % 保存
end
nROIs = length(ROIs);

% 显示数量
fprintf('共选取了 %d 个区域\n', nROIs);

% --- 步骤 3：重置视频并提取灰度值 ---
vid.CurrentTime = 0;
frameCount = floor(vid.Duration * vid.FrameRate);
grayValues = zeros(frameCount, nROIs);

% --- 步骤 4：逐帧提取每个区域的平均灰度 ---
f = 1;
while hasFrame(vid)
    frame = readFrame(vid);
    gray = rgb2gray(frame);

    for i = 1:nROIs
        roi = round(ROIs{i}.Position);  % [x, y, w, h]
        x1 = max(1, roi(1));
        y1 = max(1, roi(2));
        x2 = min(size(gray,2), x1 + roi(3) - 1);
        y2 = min(size(gray,1), y1 + roi(4) - 1);

        region = gray(y1:y2, x1:x2);
        grayValues(f,i) = mean(region(:));
    end
    f = f + 1;
end

% --- 步骤 5：绘图 ---
figure;
plot(grayValues);
xlabel('Frame');
ylabel('Gray Level (Mean in ROI)');
legend(arrayfun(@(i)sprintf('ROI %d',i), 1:nROIs, 'UniformOutput', false));
title('灰度值随时间变化');

% --- 可选保存 ---
save('gray_roi_values1.mat', 'grayValues');
