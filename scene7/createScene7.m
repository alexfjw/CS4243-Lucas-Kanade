% creates scene 7 in sceneVideos directory
% horizontal flip human => bool,
% format for rotation degree follows rotateCells method
function [] = createScene7(humanVideoDirectory, horizontalFlipHuman, rotationDegree, outputDirectory)
    % load bg video cells
    bgVid = VideoReader('videos/background/antman2.mp4');
    bgCells = videoToCells(bgVid);
    [~, totalBgFrames] = size(bgCells);

    % convert human video to cells
    humanVid = VideoReader(humanVideoDirectory);
    humanCells = videoToCells(humanVid);

    % rotate human cells
    humanCells = rotateCells(humanCells, rotationDegree, true);

    if (horizontalFlipHuman)
        humanCells = horizontalFlipCells(humanCells);
    end

    % extend human vid
    humanCells = extendVideo(humanCells, totalBgFrames);
    videoCellsToMp4(humanCells, bgVid.Framerate, 'test_output/scene7test.mp4'); % test code
    % flip if needed

    % split human video into parts, by frames.
    % should have 8 parts
    totalQuicktimeFrames = 138;

    part1End = ceil(12/totalQuicktimeFrames * totalBgFrames);
    part2End = ceil(22/totalQuicktimeFrames * totalBgFrames);
    part3End = ceil(37/totalQuicktimeFrames * totalBgFrames);
    part4End = ceil(50/totalQuicktimeFrames * totalBgFrames);
    part5End = ceil(67/totalQuicktimeFrames * totalBgFrames);
    part6End = ceil(80/totalQuicktimeFrames * totalBgFrames);
    part7End = ceil(110/totalQuicktimeFrames * totalBgFrames);

    humanPart1 = humanCells(1:part1End);
    humanPart2 = humanCells(part1End+1:part2End);
    humanPart3 = humanCells(part2End+1:part3End);
    humanPart4 = humanCells(part3End+1:part4End);
    humanPart5 = humanCells(part4End+1:part5End);
    humanPart6 = humanCells(part5End+1:part6End);
    humanPart7 = humanCells(part6End+1:part7End);
    humanPart8 = humanCells(part7End+1:end);

    bgPart1 = bgCells(1:part1End);
    bgPart2 = bgCells(part1End+1:part2End);
    bgPart3 = bgCells(part2End+1:part3End);
    bgPart4 = bgCells(part3End+1:part4End);
    bgPart5 = bgCells(part4End+1:part5End);
    bgPart6 = bgCells(part5End+1:part6End);
    bgPart7 = bgCells(part6End+1:part7End);
    bgPart8 = bgCells(part7End+1:end);

    % do fadein for 1st parts
    humanPart1 = fadeCells(humanPart1, bgPart1, false);

    % do resize operation on parts requiring it
    % 1, enlarge by 1.2x
    % 3, enlarge by 3x
    % 5, shrink by 3x
    resize1 = 1.3;
    resize3 = 3;
    resize5 = 1/3;

    sizeNow = 1;
    sizeNow = sizeNow * resize1;
    humanPart1 = resizeOverTime(humanPart1, sizeNow);
    humanPart2 = resizeImmediately(humanPart2, sizeNow);
    sizeNow = sizeNow * resize3;
    humanPart3 = resizeOverTime(humanPart3, sizeNow);
    humanPart4 = resizeImmediately(humanPart4, sizeNow);
    sizeNow = sizeNow * resize5;
    humanPart5 = resizeOverTime(humanPart5, sizeNow);
    humanPart6 = resizeImmediately(humanPart6, sizeNow);
    humanPart7 = resizeImmediately(humanPart3, sizeNow);

    % cant test like this, since some cells dont have same sized matrices
    %videoCellsToMp4(humanPart1, bgVid.Framerate, 'test_output/1.mp4'); % test code
    %videoCellsToMp4(humanPart2, bgVid.Framerate, 'test_output/2.mp4'); % test code
    %videoCellsToMp4(humanPart3, bgVid.Framerate, 'test_output/3.mp4'); % test code
    %videoCellsToMp4(humanPart4, bgVid.Framerate, 'test_output/4.mp4'); % test code
    %videoCellsToMp4(humanPart5, bgVid.Framerate, 'test_output/5.mp4'); % test code
    %videoCellsToMp4(humanPart6, bgVid.Framerate, 'test_output/6.mp4'); % test code
    %videoCellsToMp4(humanPart7, bgVid.Framerate, 'test_output/7.mp4'); % test code

    % TODO: write fn for overlayWithTranslation

end
