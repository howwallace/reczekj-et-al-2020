%{
DIRECTORY:	https://github.com/howwallace/reczekj-et-al-2020.git
PROGRAM:	find_region_of_interest.m
AUTHOR:		Harper O. W. Wallace
DATE:		17 Jan 2020

DESCRIPTION:
This script allows for streamlined region selection within LPL images using a draggable tool.
ROI coordinates obtained using this tool are used in process_img.m.
}%


clear();

N = 4;
d = 180/N;

PATH = Ò/etc./...Ó;
SUFFIX = ".jpg";

RGB0 = imread(convertStringsToChars(PATH + SUFFIX));
%RGB90 = imread(convertStringsToChars(PATH + "90" + SUFFIX));

%Igray0 = rgb2gray(RGB0);

% ROI dimensions
X = 34;
Y = 34;

% Enlarge figure to full screen.
%set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

S = [0 0 X Y];  %the size of your ROI starts at point X1, Y1
ax1 = subplot(1, 1, 1);
imshow(RGB0);
h = imrect(ax1, S);

% position callback possible to allow title-setting or printout of ROI coordinates
%addNewPositionCallback(h, @(p)title(mat2str(round([p(1,1) p(1,1)+X p(1,1)+X p(1,1)])) + ", " + mat2str(round([p(1,2) p(1,2) p(1,2)+Y p(1,2)+Y]))));
%addNewPositionCallback(h, @(p)disp(mat2str(round([p(1,1) p(1,1)+X p(1,1)+X p(1,1)])) + ", " + mat2str(round([p(1,2) p(1,2) p(1,2)+Y p(1,2)+Y]))));


% comparable to above, but for LPL image at 90 degrees
%{
ax2 = subplot(1, 2, 2);
imshow(RGB90);
hold on;
red_roi = plot(ax2, [0, X, X, 0], [0, 0, Y, Y], 'r', 'LineWidth', 2);
addNewPositionCallback(h, @(p)set(red_roi, 'xdata', round([p(1,1) p(1,1)+X p(1,1)+X p(1,1) p(1,1)]), 'ydata', round([p(1,2) p(1,2) p(1,2)+Y p(1,2)+Y p(1,2)])));

fcn = makeConstrainToRectFcn('imrect',get(gca,'XLim'),get(gca,'YLim'));
setPositionConstraintFcn(h,fcn)
position = wait(h);
%}
