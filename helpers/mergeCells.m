% Function mergeCellsWithTranslation
% Merges 2 video cells, while translating the overlay with given velocity
% Note: overlay's center is the point of reference for the function's parameters
% TODO: add some stochasticity to the translation for realism

% params overlay: overlay cells (must have same size as background)
% params background: background cells (same as above)
% params startX: x coordinate of overlay's start position (overlay's center point will be here in the bg)
% params startY: y coordinate of overlay's start position (see above)
% params destX: x coordinate of overlay's end position (see above)
% params destY: y coordinate of overlay's end position (see above)
function [merged] = mergeCellsWithTranslation(overlay, background, startX, startY, destX, destY)
    [~, numOverlayFrames] = size(overlay);
    [~, numBgFrames] = size(background);

    if (numBgFrames ~= numOverlayFrames)
        % overlay must be of equal length to base
        % we don't want to see disappearing overlays or backgrounds halfway through
        error('overlay does not have same number of frames as background.
         may lead to overlay disappearing or background disappearing...');
    end

    merged = cell(1, numBgFrames);

    % movement in the x direction per frame
    dX = (destX - startX)/(numBgFrames-1);
    % movement in the y direction per frame
    dY = (destY - startY)/(numBgFrames-1);
    centerX = startX;
    centerY = startY;
    for i = 1:numOverlayFrames
        bgFrame = background{i};
        overlayFrame = overlay{i}:

        [overlayHeight, overlayWidth, ~] = size(overlayFrame);
        % position of overlay's left edge in the bg
        xLeft = centerX - overlayWidth/2;
        % position of overlay's right edge in the bg
        xRight = centerX + overlayWidth/2;
        % position of overlay's top edge in bg
        yTop = centerY - overlayHeight/2;
        % position of overlay's bottom edge in bg
        yBottom = centerY + overlayHeight/2;

        % nudge overlay's position a bit to land whole pixels
        % if dX positive, ceil. else floor
        if (dX >= 0)
            xLeft = ceil(xLeft)
            xRight = ceil(xRight)
        else
            xLeft = floor(xLeft)
            xRight = floor(xRight)
        end

        if (dY >= 0)
            yTop = ceil(yTop)
            yBottom = ceil(yBottom)
        else
            yTop = floor(yTop)
            yBottom = floor(yBottom)
        end
        % shift for next iteration
        centerX = centerX + dX;
        centerY = centerY + dY;

        [Ny, Nx, Nz] = size(humany);
        dSize = Ny*Nx;
        % Get location of the black pixels in all channels (overlay's coordinates)
        notBlackR = overlayFrame(:,:,1) ~= 0;
        notBlackG = overlayFrame(:,:,2) ~= 0;
        notBlackB = overlayFrame(:,:,3) ~= 0;
        % get the actual black pixels (overlay's coordinates)
        notBlackPixels_Overlay = find(notBlackR & notBlackG & notBlackB);

        notBlackPixels_Bg =

        % paste overlay's not black pixels onto background

        humany(blackPixels) = background(blackPixels);
        humany(blackPixels + dSize) = background(blackPixels+dSize);
        humany(blackPixels + 2*dSize) = background(blackPixels+dSize*2);

        % override bg, may result in bugs later! be careful!
        bgFrame()

        merged{i} =
    end


end
