%{
DIRECTORY:	https://github.com/howwallace/reczekj-et-al-2020.git
PROGRAM:	convert_data.m
AUTHOR:		Harper O. W. Wallace
DATE:		17 Jan 2020

DESCRIPTION:
This script converts transmittance values (either directly input on scale of 0 to 1, or
stored in aves, the output variable from convert_img.m) to alignment angles relative to
0-degrees LPL.

NOTE:
convert_data.m can be used with convert_img.m (cf. header for convert_img.m for further
details). To ensure proper functionality, be sure to run this script after running
convert_img.m, and in the same MATLAB environment.
}%


N = 8;  % BASE
POL = 0;
ROUND = 5;

M = [0, 0.5, 1.0; 0.5, 1.0, 0; 1.0, 0, 0.5];
%M = aves;	% if used in conjunction with convert_img.m

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

