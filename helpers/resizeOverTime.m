% Resize video matrix cells over time

% params video: full video
% params endSize: fraction of the original size, eg. 0.3
% returns resizedResult: the resized video matrix cells
function [resizedResult] = resizeOverTime(videoCells, endSize)
    [~, numFrames] = size(videoCells);
    resizedResult = cell(1, numFrames);

    sizeStep = (1-endSize)/(numFrames-1);
    currentSize = 1;
    for i = 1 : numFrames
        frame = videoCells{i};
        resizedResult{i} = imresize(frame, currentSize);
        currentSize = currentSize - sizeStep;
    end
end
