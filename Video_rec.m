
videoFile = 'butane_clip.mp4';
vid = VideoReader(videoFile);
firstFrame = readFrame(vid);

imshow(firstFrame);
title('DrawIntered');
hold on;

% Initialization
ROIs = {};  
while true
    h = drawrectangle();  
    if isempty(h); break; end 
    ROIs{end+1} = h;  
end
nROIs = length(ROIs);


fprintf('共选取了 %d 个区域\n', nROIs);

%% reset and drag grey intesnity
vid.CurrentTime = 0;
frameCount = floor(vid.Duration * vid.FrameRate);
grayValues = zeros(frameCount, nROIs);

% average 
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

% plot
figure;
plot(grayValues);
xlabel('Frame');
ylabel('Gray Level (Mean in ROI)');
legend(arrayfun(@(i)sprintf('ROI %d',i), 1:nROIs, 'UniformOutput', false));
title('灰度值随时间变化');

%save
save('gray_roi_values1.mat', 'grayValues');
