
THRESHOLD = 0.5;    % cells must fall below this portion of the max in variance to be flagged
DISP_ROI = true;


max_diffs = zeros(NUM_REGIONS, NUM_SUB_X, NUM_SUB_X);
defect_indices = cell(NUM_REGIONS);
defect_count = zeros(1, NUM_REGIONS);
defects_removed = zeros(NUM_CASES, NUM_REGIONS);

for region = 1:NUM_REGIONS
    for sub_x = 1:NUM_SUB_X
        for sub_y = 1:NUM_SUB_X
            means = adj_ali_means(:, region, sub_x, sub_y);     % max difference in intensity comparing LPLs
            max_diffs(region, sub_x, sub_y) = max(means) - min(means);
        end
    end
    
    max_region_diffs = max_diffs(region, :, :);
    [M, I] = max(max_region_diffs(:));
    
    quality_indices = find(max_diffs(region, :, :) > M*THRESHOLD);
    
    quality = adj_ali_means(:, region, quality_indices);
    
    defects_removed(:, region) = reshape(mean(quality, 3), [NUM_CASES, 1]);
    
    defect_indices{region} = find(max_diffs(region, :, :) < M*THRESHOLD);
    defect_count(region) = length(defect_indices{region});
    
end


if size(adj_ali_means(3)) == 1
    for c = 1:NUM_CASES
        fprintf('%i\t%s\n', IMAGE_CASES(c), num2str(defects_removed(c, :, :), '%f6\t'));
    end
    fprintf('DEFECTS\t%s\n', num2str(defect_count, '%d\t'));
    %{
    for region = 1:NUM_REGIONS
        disp(max(max_diffs(region, :)));
    end
    %}
else
    for sub = 1:NUM_SUB
        fprintf('%s\n', num2str(max_diffs(:, sub), '%f6\t'));
    end
end


if DISP_ROI
    set(gcf, 'Position', get(0, 'Screensize'));
    
    subplot(1, 3, 1);
    imshow(RGBs{1}, []);
    title('Original RGB Image', 'FontSize', 12);

    subplot(1, 3, 2);
    imshow(Igray0, []);
    title('0� Grayscale Image', 'FontSize', 12);

    subplot(1, 3, 3);
    imshow(Igray90, []);
    title('90� Grayscale Image', 'FontSize', 12);
    
    for region = 1:NUM_REGIONS
        if USE_CELLS
            x0 = REGION_DIM * x_coords(region);
            y0 = REGION_DIM * y_coords(region);
        else
            x0 = x_coords(region);
            y0 = y_coords(region);
        end

        % BLUE ISO BORDERS
        iso_edge = ISO_GAP + ISO_WIDTH;
        iso_xs = [x0 - iso_edge, x0 + REGION_DIM + iso_edge, x0 + REGION_DIM + iso_edge, x0 - iso_edge, x0 - iso_edge, x0 - ISO_GAP, x0 - ISO_GAP, x0 + REGION_DIM + ISO_GAP, x0 + REGION_DIM + ISO_GAP, x0 - iso_edge];
        iso_ys = [y0 - iso_edge, y0 - iso_edge, y0 + REGION_DIM + iso_edge, y0 + REGION_DIM + iso_edge, y0 - ISO_GAP, y0 - ISO_GAP, y0 + REGION_DIM + ISO_GAP, y0 + REGION_DIM + ISO_GAP, y0 - ISO_GAP, y0 - ISO_GAP];
        [~, xs, ys] = roipoly(Igray0, iso_xs, iso_ys);

        subplot(1, 3, 2);
        hold on;
        plot(xs, ys, 'b', 'LineWidth', 2);

        subplot(1, 3, 3);
        hold on;
        plot(xs, ys, 'b', 'LineWidth', 2);

        
        % RED REGION BORDER
        
        [BW, xs, ys] = roipoly(Igray0, [x0, x0 + REGION_DIM, x0 + REGION_DIM, x0], [y0, y0, y0 + REGION_DIM, y0 + REGION_DIM]);

        subplot(1, 3, 2);
        hold on;
        plot(xs, ys, 'r', 'LineWidth', 2);

        subplot(1, 3, 3);
        hold on;
        plot(xs, ys, 'r', 'LineWidth', 2);
        
        
        % GREEN DEFECT FLAGS
        max_region_diffs = max_diffs(region, :, :);
        [M, I] = max(max_region_diffs(:));

        for i = 1:length(defect_indices{region})
            [sub_x, sub_y] = ind2sub([NUM_SUB_X, NUM_SUB_X], defect_indices{region}(i));

            x = x0 + (sub_x - 1) * SUB_REGION_DIM;
            y = y0 + (sub_y - 1) * SUB_REGION_DIM;

            [BW, xs, ys] = roipoly(Igray0, [x, x + SUB_REGION_DIM, x + SUB_REGION_DIM, x], [y, y, y + SUB_REGION_DIM, y + SUB_REGION_DIM]);
            
            g = 1 - 0.4 * max_diffs(region, sub_x, sub_y) / (M*THRESHOLD);  % more-certain defects are brighter

            subplot(1, 3, 2);
            hold on;
            plot(xs, ys, 'Color', [0, g, 0], 'LineWidth', 2);

            subplot(1, 3, 3);
            hold on;
            plot(xs, ys, 'Color', [0, g, 0], 'LineWidth', 2);
        end
    end
end
