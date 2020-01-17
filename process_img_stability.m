
clear();

%%%  INSERT REGIONS BELOW  %%%
PATH = "/Users/harperwallace/Desktop/Image Analysis/Stability/B_day_2_";
SUFFIX = ".jpg";

COORDS = [];
COORDS{1} = [[7.43661971830986 4.95774647887322 32.3474178403756 342.694835680751];
    [7.43661971830986 4.95774647887322 338.075117370892 32.8356807511738];
    [313.164319248826 4.95774647887322 32.3474178403757 341.868544600939];
    [7.43661971830977 314.816901408451 338.075117370892 32.0093896713616]];
COORDS{2} = [[87.2845528455284 52.2276422764227 177.804878048781 13.2520325203253];
    [53.3170731707317 87.2845528455284 12.5040650406504 174.943089430894];
    [286.552845528455 90.1463414634146 12.5040650406504 174.943089430894];
    [90.1463414634146 284.747967479675 177.804878048781 13.2520325203253]];
COORDS{3} = [[88.7719298245614 83.3684210526316 38.6315789473684 37.859649122807];
    [207.649122807018 81.8245614035088 54.8421052631579 39.4035087719298];
    [125.052631578947 206.877192982456 18.5614035087719 60.2456140350878];
    [209.19298245614 201.473684210526 18.5614035087719 60.2456140350878];
    [211.508771929825 239.298245614035 50.9824561403509 27.0526315789474];
    [92.6315789473684 240.070175438597 50.9824561403509 27.0526315789474]];
COORDS{4} = [[153.04347826087 92.5062801932367 46.2434782608695 163.236714975845];
    [97.2676328502415 130.597101449275 159.155555555555 31.9594202898551];
    [97.2676328502415 130.597101449275 26.5178743961352 61.887922705314];
    [229.905314009662 131.27729468599 26.5178743961352 61.887922705314]];

IMAGE_CASES = [0, 45, 90];

%%%  INSERT REGIONS ABOVE  %%%

NUM_REGIONS = length(COORDS);
NUM_SUB_REGIONS = [size(COORDS{1}, 1), size(COORDS{2}, 1), size(COORDS{3}, 1), size(COORDS{4}, 1)];
NUM_CASES = length(IMAGE_CASES);

INSET = 1.4;

set(gcf, 'Position', get(0, 'Screensize'));

RGBs{NUM_CASES} = [];
TOTAL_BWs{NUM_REGIONS} = [];

for i = 1:NUM_CASES
    
    RGBs{i} = imread(convertStringsToChars(PATH + int2str(IMAGE_CASES(i)) + SUFFIX));
    
    subplot(1, NUM_CASES, i);
    imshow(RGBs{i}, []);
    title(convertStringsToChars(IMAGE_CASES(i) + "º RGB Image"), 'FontSize', 12);
    hold on;
    
    red = RGBs{i}(:, :, 1);
    green = RGBs{i}(:, :, 2);
    blue = RGBs{i}(:, :, 3);
    
    for r = 1:NUM_REGIONS
        TOTAL_BWs{r} = 0;
        
        for sub = 1:NUM_SUB_REGIONS(r)
            
            origin = COORDS{r}(sub, 1:2);
            size = COORDS{r}(sub, 3:4);

            x_coords = [origin(1) + INSET, origin(1) + size(1) - 2*INSET, origin(1) + size(1) - 2*INSET, origin(1) + INSET];
            y_coords = [origin(2) + INSET, origin(2) + INSET, origin(2) + size(2) - 2*INSET, origin(2) + size(2) - 2*INSET];

            [BW, xs, ys] = roipoly(RGBs{i}, x_coords, y_coords);

            if (isempty(TOTAL_BWs{r}))
                TOTAL_BWs{r} = BW;
            else
                TOTAL_BWs{r} = TOTAL_BWs{r} | BW;
            end
        end
        
        region_mask = TOTAL_BWs{r};
        bounds = bwboundaries(region_mask);
        visboundaries(bounds);%, 'Color', colors(r));
        
        fprintf("%iº, R %i:\t%f\t%f\t%f\n", IMAGE_CASES(i), r, mean2(red(region_mask)), mean2(green(region_mask)), mean2(blue(region_mask)));
    end
end

%colors = ['g', 'r', 'b', 'y'];

