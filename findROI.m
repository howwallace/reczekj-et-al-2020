%{
@20x scale, 622 pixels = 100µm
use 5µm x 5µm area ~ 31 pixels x 31 pixels
iso: 2048x50
%}

clear();

N = 4;
d = 180/N;

PATH = "/Users/harperwallace/Desktop/Image Analysis/Stability/";
SUFFIX = "A_day_1_0.jpg";

RGB0 = imread(convertStringsToChars(PATH + SUFFIX));
%RGB90 = imread(convertStringsToChars(PATH + "90" + SUFFIX));

%Igray0 = rgb2gray(RGB0);

X = 34;
Y = 34;

% Enlarge figure to full screen.
%set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

S = [0 0 X Y];  %the size of your ROI starts at point X1, Y1
ax1 = subplot(1, 1, 1);
imshow(RGB0);
h = imrect(ax1, S);
%addNewPositionCallback(h, @(p)title(mat2str(round([p(1,1) p(1,1)+X p(1,1)+X p(1,1)])) + ", " + mat2str(round([p(1,2) p(1,2) p(1,2)+Y p(1,2)+Y]))));
%addNewPositionCallback(h, @(p)disp(mat2str(round([p(1,1) p(1,1)+X p(1,1)+X p(1,1)])) + ", " + mat2str(round([p(1,2) p(1,2) p(1,2)+Y p(1,2)+Y]))));


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
