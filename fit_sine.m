%{
DIRECTORY:	https://github.com/howwallace/reczekj-et-al-2020.git
PROGRAM:	fit_sine.m
AUTHOR:		Harper O. W. Wallace
DATE:		17 Jan 2020

DESCRIPTION:
This script uses average intensities through aligned regions, stored in
adj_ali_means or defects_removed (output values from process_img.m and
defects_removed.m, respectively) as the DATASET for three-point spline of
transmittances at LPL angles specified in ALIGN_ANGLES.

It outputs amplitude, midline, phase-shift, and corresponding theta_w,fit.

IMPORTANT NOTE:
To ensure proper functionality, be sure to run this script after running
process_img.m or defects_removed.m, and in the same MATLAB environment.
%}


DATASET = adj_ali_means; %defects_removed; %


inds = [0, 45, 90]/5 + 1;

T1 = pi / 180 * IMAGE_CASES(inds(1));
T2 = pi / 180 * IMAGE_CASES(inds(2));
T3 = pi / 180 * IMAGE_CASES(inds(3));

w = 2;
det = sin(w*T1)*(cos(w*T2) - cos(w*T3)) - cos(w*T1)*(sin(w*T2) - sin(w*T3)) + sin(w*(T2 - T3));
inv = 1/det * [ cos(w*T2) - cos(w*T3), cos(w*T3) - cos(w*T1), cos(w*T1) - cos(w*T2); sin(w*T3) - sin(w*T2), sin(w*T1) - sin(w*T3), sin(w*T2) - sin(w*T1); sin(w*(T2 - T3)), sin(w*(T3 - T1)), sin(w*(T1 - T2)) ];

Ys = zeros(1, NUM_REGIONS);
phis = zeros(1, NUM_REGIONS);
bs = zeros(1, NUM_REGIONS);
angles = zeros(1, NUM_REGIONS);

for i = 1:NUM_REGIONS

    prod = inv * DATASET(inds, i, :);
    A = prod(1);
    B = prod(2);
    
    bs(i) = prod(3);
    
    Ys(i) = sqrt(A^2 + B^2);
    phis(i) = (180 / pi) * atan(B / A);

    if A < 0
        phis(i) = phis(i) + 180;
    end
    
    angles(i) = 180 - (phis(i) + 90) / 2;
end

fprintf('Y\t%s\n', num2str(Ys, '%f6\t'));
fprintf('phi\t%s\n', num2str(phis, '%f6\t'));
fprintf('b\t%s\n', num2str(bs, '%f6\t'));
fprintf('ANGLE\t%s\n', num2str(angles, '%f6\t'));

