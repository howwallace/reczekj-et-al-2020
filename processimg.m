
clear();

PATH = "/Users/harperwallace/Dropbox/Image Analysis/Grid Set 2_4/doubleisoBG100pow190000ums_doublePatt12Pow4500ums_4x_";
SUFFIX = "deg_color.jpg";
 
x_coords = [427, 512, 600, 688, 773, 856, 424, 512, 600, 685, 771, 856, 424, 512, 600, 685, 773, 859, 424, 512, 600, 683, 768, 856, 424, 512, 600, 683, 773, 859, 424, 509, 597, 685, 768, 856];
y_coords = [155, 155, 155, 155, 155, 157, 240, 243, 243, 243, 243, 243, 325, 325, 328, 328, 328, 328, 411, 413, 413, 413, 413, 416, 501, 499, 499, 501, 499, 501, 584, 587, 587, 587, 587, 589];

REGION_DIM = 34;


ISO_GAP = 8;
ISO_WIDTH = 8;

DISP_ROI = true;
USE_CELLS = false;
NUM_REGIONS = length(x_coords);
%REGION_DIM = 26;
INSET = 0;

USE_MAX_POOL = false;
SUB_REGION_DIM = 2;

IMAGE_CASES = [0:5:175]; %[0, 30, 45, 90]; %[0, 45, 90, 135]; %

%%%  INSERT REGIONS ABOVE  %%%


NUM_CASES = length(IMAGE_CASES); %36;     % number of angles
%d = 180/NUM_CASES;  % degree measure between angles

RGBs{NUM_CASES} = [];
Igrays{NUM_CASES} = [];
isos = [];
for r = 1:NUM_CASES
    img = imread(convertStringsToChars(PATH + int2str(IMAGE_CASES(r)) + SUFFIX));
    RGBs{r} = img;
    Igrays{r} = double(1/2*img(:, :, 1) + 1/2*img(:, :, 2)); %rgb2gray(img)); % 
end


Igray0 = Igrays{1};
Igray90 = Igrays{NUM_CASES/2 + 1};


if ~USE_MAX_POOL
    SUB_REGION_DIM = REGION_DIM - 2*INSET;
    NUM_SUB_X = 1;
    NUM_SUB = 1;
else
    NUM_SUB_X = (REGION_DIM - 2*INSET) / SUB_REGION_DIM;
end

if DISP_ROI
    set(gcf, 'Position', get(0, 'Screensize'));
    
    subplot(1, 3, 1);
    imshow(RGBs{1}, []);
    title('Original RGB Image', 'FontSize', 12);

    subplot(1, 3, 2);
    imshow(Igray0, []);
    title('0º Grayscale Image', 'FontSize', 12);

    subplot(1, 3, 3);
    imshow(Igray90, []);
    title('90º Grayscale Image', 'FontSize', 12);
end

isoBWs = cell(NUM_REGIONS);
alignedBWs = cell(NUM_REGIONS, NUM_SUB_X, NUM_SUB_X);

for r = 1:NUM_REGIONS
    if USE_CELLS
        x0 = REGION_DIM * x_coords(r);
        y0 = REGION_DIM * y_coords(r);
    else
        x0 = x_coords(r);
        y0 = y_coords(r);
    end
    
    iso_edge = ISO_GAP + ISO_WIDTH;
    iso_xs = [x0 - iso_edge, x0 + REGION_DIM + iso_edge, x0 + REGION_DIM + iso_edge, x0 - iso_edge, x0 - iso_edge, x0 - ISO_GAP, x0 - ISO_GAP, x0 + REGION_DIM + ISO_GAP, x0 + REGION_DIM + ISO_GAP, x0 - iso_edge];
    iso_ys = [y0 - iso_edge, y0 - iso_edge, y0 + REGION_DIM + iso_edge, y0 + REGION_DIM + iso_edge, y0 - ISO_GAP, y0 - ISO_GAP, y0 + REGION_DIM + ISO_GAP, y0 + REGION_DIM + ISO_GAP, y0 - ISO_GAP, y0 - ISO_GAP];
    [BW, xs, ys] = roipoly(Igray0, iso_xs, iso_ys);
    isoBWs{r} = BW;
    
    if DISP_ROI
        subplot(1, 3, 2);
        hold on;
        plot(xs, ys, 'b', 'LineWidth', 2);

        subplot(1, 3, 3);
        hold on;
        plot(xs, ys, 'b', 'LineWidth', 2);
    end
    
    for sub_x = 1:NUM_SUB_X
        for sub_y = 1:NUM_SUB_X
            x = x0 + INSET + (sub_x - 1) * SUB_REGION_DIM;
            y = y0 + INSET + (sub_y - 1) * SUB_REGION_DIM;

            [BW, xs, ys] = roipoly(Igray0, [x, x + SUB_REGION_DIM, x + SUB_REGION_DIM, x], [y, y, y + SUB_REGION_DIM, y + SUB_REGION_DIM]);

            alignedBWs{r, sub_x, sub_y} = BW;
            
            if DISP_ROI
                subplot(1, 3, 2);
                hold on;
                plot(xs, ys, 'r', 'LineWidth', 2);

                subplot(1, 3, 3);
                hold on;
                plot(xs, ys, 'r', 'LineWidth', 2);
            end
        end
    end
end

iso_means = zeros(NUM_CASES, NUM_REGIONS);
ali_means = zeros(NUM_CASES, NUM_REGIONS, NUM_SUB_X, NUM_SUB_X);
adj_ali_means = zeros(NUM_CASES, NUM_REGIONS, NUM_SUB_X, NUM_SUB_X);

for c = 1:NUM_CASES
    for region = 1:NUM_REGIONS
        for sub_x = 1:NUM_SUB_X
            for sub_y = 1:NUM_SUB_X
                ali_means(c, region, sub_x, sub_y) = mean2(Igrays{c}(alignedBWs{region, sub_x, sub_y}));
            end
        end
        iso_means(c, region) = mean2(Igrays{c}(isoBWs{region}));
        adj_ali_means(c, region, :, :) = ali_means(c, region, :, :) - iso_means(c, region);   % + iso_ave; CHANGED: later
    end
end

iso_ave = mean2(iso_means);
adj_ali_means = adj_ali_means + iso_ave;    % CORRECTED


