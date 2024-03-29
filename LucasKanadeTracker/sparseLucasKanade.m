% Function sparseLucasKanade
% This function performs the hierachial Lucas Kanade algorithm on 2 images,
% without iterative warping
% Reference: robots.stanford.edu/cs223b04/algo_tracking.pdf
% Output: flow for i1

% params i1: image1, should be grayscale
% params i2: image2, should be grayscale
% params windowSize: size of window, suggested to be 5-15 by stanford docs
% returns flowX: final displacement of points in the X dimension from image1 to image2
% returns flowY: final displacement of points in the Y dimension from image1 to image2
function [flowX, flowY] = sparseLucasKanade(i1, i2, windowSize)
    % suggested by stanford docs
    pyramidLevels = 4;

    [py1, py2] = generatePyramids(i1, i2, pyramidLevels);

    % displacement of points in the X & Y dimensions
    % will be resized to i1's size by the end of algorithm
    flowX = zeros(size(py1{pyramidLevels}));
    flowY = zeros(size(py1{pyramidLevels}));

    for level = pyramidLevels:-1:1
        layerI1 = py1{level};
        layerI2 = py2{level};

        % project flowX & flowY on layerI2, with sublevel accuracy
        % as suggested by reference doc, use bilinear interpolation
        [layerHeight, layerWidth] = size(layerI2);
        % convenience fn to get a grid
        [X, Y] = meshgrid(1:layerWidth, 1:layerHeight);
        projectedI2 = interp2(layerI2, X+flowX, Y+flowY);
        % interp2 gives nan if sample point is out of the points provided
        % insert the original values there
        nanCoordinates = isnan(projectedI2);
        projectedI2(nanCoordinates) = layerI2(nanCoordinates);

        % optical flow for this layer
        [lFlowX, lFlowY] = opticalFlow(layerI1, projectedI2, windowSize, 0.1);
        flowX = flowX + lFlowX;
        flowY = flowY + lFlowY;

        % resize for next iteration
        if (level > 1)
            nextPyramidSize = size(py1{level-1});
            flowX = imresize(2.*flowX, nextPyramidSize, 'bilinear');
            flowY = imresize(2.*flowY, nextPyramidSize, 'bilinear');
        end
    end
end
