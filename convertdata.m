

N = 8;  % BASE
POL = 0;
ROUND = 5;

M = aves;

intensity_adj = 2 * M - 1

ALIGN_PLUS = 180 / pi * mod(POL + 1/2 * acos(intensity_adj) - pi / 2, pi);
ALIGN_MINUS = 180 / pi * mod(POL - 1/2 * acos(intensity_adj) - pi / 2, pi);

%{
OUTPUT INTENSITIES
1/2 * (cos(pi / 180 * (POL - ALIGN_PLUS)) + 1);
%}

for x = 1:size(ALIGN_PLUS,1)
    fprintf('%s\n', num2str(ROUND * round(ALIGN_PLUS(x, :) / ROUND), '%d\t'));
end


INTENSITIES = 1/2 * (cos(pi / 180 * 2 * (POL - ALIGN_MINUS) + pi) + 1);

%subplot(1, 2, 2);
imshow(INTENSITIES);

