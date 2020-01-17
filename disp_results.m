%{
DIRECTORY:	https://github.com/howwallace/reczekj-et-al-2020.git
PROGRAM:	disp_results.m
AUTHOR:		Harper O. W. Wallace
DATE:		17 Jan 2020

DESCRIPTION:
This script formats output values (either from process_img.m or from remove_defects.m; cf. 
those files for further details and important notes) for ease of copy-and-paste to Microsoft
Excel for figure-creation and further analysis.

IMPORTANT NOTE:
disp_results.m references adj_ali_means or defects_removed, output values from process_img.m
and defects_removed.m, respectively, as the DATASET to be displayed. To ensure proper
functionality, be sure to run this script after running process_img.m or defects_removed.m,
and in the same MATLAB environment.
}%


DATASET = adj_ali_means; %defects_removed;
PRINT_FORMAT = 1;


if PRINT_FORMAT == 1
    for c = 1:NUM_CASES
        fprintf('%i\t%s\n', IMAGE_CASES(c), num2str(DATASET(c, :, :), '%f6\t'));
    end
    disp("ISOTROPIC:");
    for c = 1:NUM_CASES
        fprintf('%i\t%s\n', IMAGE_CASES(c), num2str(iso_means(c, :), '%f6\t'));
    end
else
    for region = 1:NUM_REGIONS
        for c = 1:NUM_CASES
            fprintf('%i\t%s\n', IMAGE_CASES(c), num2str(DATASET(c, region, :), '%f6\t'));
        end
        fprintf('\n');
    end
end

%{
ortho_adj_ali_means = zeros(NUM_CASES, NUM_REGIONS, NUM_SUB);
ortho_adj_ali_means(1:NUM_CASES/2, :, :) = DATASET(NUM_CASES/2 + 1:end, :, :);
ortho_adj_ali_means(NUM_CASES/2 + 1:end, :, :) = DATASET(1:NUM_CASES/2, :, :);

diffs = DATASET(:, :, :) - ortho_adj_ali_means(:, :, :);
%}

%{
for angle = 1:NUM_CASES
    region_aves = zeros(1, NUM_REGIONS); %mean2(adj_ali_means(1, :, :));
    ortho_region_aves = mean2(adj_ali_means(angle, :, :));
    for region = 1:NUM_REGIONS
        region_aves(1, region) = mean2(adj_ali_means(angle, region, :));
        ortho_region_aves(1, region) = mean2(ortho_adj_ali_means(angle, region, :));
    end
end
%}

%disp(iso_ave);

