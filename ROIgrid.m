%{
@20x scale, 622 pixels = 100µm
use 5µm x 5µm area ~ 31 pixels x 31 pixels

iso:  2048x50
%}

clear();

N = 36;
d = 180/N;

path = "/Users/harperwallace/Desktop/Image Analysis/Hoke/2018-07-05/2B (aligned, 0.2mmps, 1.000A, 20x)/";
RGB0 = imread(convertStringsToChars(path + "0.jpg"));
RGB90 = imread(convertStringsToChars(path + "90.jpg"));

imshow((RGB0 - RGB90))
hold on

M = size(RGB0,1);
N = size(RGB0,2);

for k = 1:31:M
    x = [1 N];
    y = [k k];
    if mod(k, 310) == 1
        plot(x,y,'Color','b','LineStyle','-');
    else
        plot(x,y,'Color',[0.7 0.7 0.7],'LineStyle','-');
    end
end

for k = 1:31:N
    x = [k k];
    y = [1 M];
    if mod(k, 310) == 1
        plot(x,y,'Color','b','LineStyle','-');
    else
        plot(x,y,'Color',[0.7 0.7 0.7],'LineStyle','-');
    end
end

hold off
