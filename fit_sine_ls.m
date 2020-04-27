%{
DIRECTORY:	https://github.com/howwallace/reczekj-et-al-2020.git
PROGRAM:	fit_sine_ls.m
AUTHOR:		Harper O. W. Wallace
DATE:		27 Apr 2020

DESCRIPTION:
This script uses average intensities through aligned regions, stored
inadj_ali_means or defects_removed (output values from process_img.m and
defects_removed.m, respectively) as the DATASET for least-squares sine
curve fitting over LPL angles specified in ALIGN_ANGLES.

It outputs amplitude, midline, phase-shift, and corresponding theta_w,fit.

IMPORTANT NOTE:
To ensure proper functionality, be sure to run this script after running
process_img.m or defects_removed.m, and in the same MATLAB environment.

REFERENCE:
# Händel, P. (2000). Evaluation of a standardized sine wave fit algorithm.
In Proceedings of the IEEE Nordic Signal Processing Symposium, Sweden.
%}


DATASET = adj_ali_means; %defects_removed; %iso_means; %

w = 2;

ALIGN_ANGLES = [0, 30, 45, 90] + 45; %IMAGE_CASES + 45; %IMAGE_CASES;

Ts = (pi / 180 * ALIGN_ANGLES).';
D = [cos(w * Ts), sin(w * Ts), ones(length(ALIGN_ANGLES),1)];
mult = inv(D.' * D) * D.';


Ys = zeros(1, NUM_REGIONS);
phis = zeros(1, NUM_REGIONS);
bs = zeros(1, NUM_REGIONS);
angles = zeros(1, NUM_REGIONS);

for i = 1:NUM_REGIONS
    
    prod = mult * DATASET((ALIGN_ANGLES - 45) / 5 + 1, i, :);  %DATASET(:, i, :);
    A = prod(1);
    B = prod(2);
    
    bs(i) = prod(3);
    
    Ys(i) = sqrt(A^2 + B^2);
    phis(i) = (180 / pi) * atan(B / A);

    if A < 0
        phis(i) = phis(i) + 180;
    end
    
    angles(i) = (270 - phis(i)) / 2;
end

fprintf('Y\t%s\n', num2str(Ys, '%f6\t'));
fprintf('phi\t%s\n', num2str(phis, '%f6\t'));
fprintf('b\t%s\n', num2str(bs, '%f6\t'));
fprintf('ANGLE\t%s\n', num2str(angles, '%f6\t'));

