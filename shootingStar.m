video = VideoReader('videos/trimmed/human7_1.mp4');
% video = VideoReader('videos/trimmed/jumping_bg.mp4');
% video = VideoReader('videos/trimmed/playground.mp4');
currAxes = axes;
frameMatrix = zeros(video.height, video.width, 3);
firstFrame = zeros(video.height, video.width, 3);
movingObjects = zeros(video.height, video.width, 3);

counter = 2;
weightage = 1;

if hasFrame(video)
    frameMatrix = readFrame(video);
    firstFrame = frameMatrix;
    while hasFrame(video)
        currentFrame = readFrame(video);
        currentMatrix = (double(frameMatrix) * weightage) + double(currentFrame);
        averageMatrix = currentMatrix / counter;
s
        movingObjects = abs(cast(currentFrame, 'double') - averageMatrix);
        %movingObjects = cast(currentFrame, 'double') - averageMatrix;

        %if(mod(counter, 5) == 0)
        %    figure;
        %    imshow(cast(movingObjects, 'uint8'));
        %end

        frameMatrix = averageMatrix;
        counter = counter + 1;
        weightage = weightage + 1;
    end
else
    disp('video is empty');
end

counter = 2;
threshold = 60;
video = VideoReader('videos/trimmed/human7_1.mp4');
% video = VideoReader('videos/trimmed/jumping_new.mp4');
% video = VideoReader('videos/trimmed/playground.mp4');

outputVideo = VideoWriter('human/human7_1_out_60.mp4', 'MPEG-4');
% outputVideo = VideoWriter('jumping/jumping_out_bg_50.mp4', 'MPEG-4');
% outputVideo = VideoWriter('playground/playground_40.mp4', 'MPEG-4');
outputVideo.FrameRate = video.FrameRate;
open(outputVideo)

if hasFrame(video)
    while hasFrame(video)
        currentFrame = double(readFrame(video));
        diff = abs(double(currentFrame) - averageMatrix);
        
        isPixel = sum(diff,3);
        isPixel(isPixel <= threshold) = 0;
        isPixel(isPixel > threshold) = 1;
        isPixel = repmat(isPixel, [1 1 3]);

        movingObjects = currentFrame .* isPixel ;
%         figure;
%         pic = imshow(uint8(movingObjects));

        % using frame 23 to 39 for swing_bg.mp4 %
%         if (counter >= 23 && counter <= 34)
            writeVideo(outputVideo, uint8(movingObjects));
%         end
        counter = counter + 1;
    end
else
    disp('video is empty');
end

close(outputVideo);