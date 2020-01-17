%{
DIRECTORY:	https://github.com/howwallace/reczekj-et-al-2020.git
PROGRAM:	convert_img.m
AUTHOR:		Harper O. W. Wallace
DATE:		17 Jan 2020

DESCRIPTION:
This script converts a pixelated input image (with “pixel” dimension D) to a matrix of
average grayscale intensities (scale 0 to 1), stored in an output variable aves. It is
intended to be used in conjunction with convert_data.m, which takes the output variable aves
and converts it to a matrix of alignment angles relative to 0-degrees LPL to achieve
transmittance values corresponding to aves.
}%


PATH = “/etc./.../img.jpg”;

original = imread(convertStringsToChars(PATH));
gray = rgb2gray(original);

%imshow(img);
hold on;

WIDTH = size(gray,1);
HEIGHT = size(gray,2);

D = 32;
%{
for k = 1:D:WIDTH
    x = [1 HEIGHT];
    y = [k k];
    plot(x,y,'Color','b','LineStyle','-');
end

for k = 1:D:HEIGHT
    x = [k k];
    y = [1 WIDTH];
    plot(x,y,'Color','b','LineStyle','-');
end
%}
W = floor(WIDTH / D);
H = floor(HEIGHT / D);

aves = zeros(W, H);
for x = 1:W
    for y = 1:H
        [BW, xs, ys] = roipoly(gray, [D*(y - 1), D*(y - 1), D*y, D*y], [D*(x - 1), D*x, D*x, D*(x - 1)]);
        aves(x, y) = mean2(gray(BW)) / 255; %round(N * mean2(gray(BW)) / 255) / N;
    end
    fprintf('%s\n', num2str(aves(x, :), '%d\t'));
end

imshow(aves)


for x = 1:W
    for y = 1:H
        new_img(D*(x - 1) + 1:D*x + 1, D*(y - 1) + 1:D*y + 1) = aves(x, y);
    end
end

aves

%imshow(new_img);

%{
[BW, xs, ys] = roipoly(img, [0, 10, 10, 0], [0, 0, 10, 10]);

bounds = bwboundaries(BW);
xy = bounds{1};
x = xy(:, 2);
y = xy(:, 1);

hold on;
plot(x, y, 'r', 'LineWidth', 2);
%}
