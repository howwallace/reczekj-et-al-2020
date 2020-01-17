

DATASET = defects_removed; %adj_ali_means;


SHIFT = 0;
DIAG_SHIFT = -1;


if SHIFT ~= 0
    shifted = zeros(size(DATASET));
    shifted(:, 1) = DATASET(:, 1);
    if SHIFT > 0
        shifted(SHIFT:end, :) = DATASET(1:end - SHIFT - 1);
    else
        shifted(1:end - SHIFT - 1) = DATASET(SHIFT:end, :);
    end
end


if DIAG_SHIFT ~= 0
    shifted = zeros(size(DATASET));
    shifted(:, 1) = DATASET(:, 1);
    if DIAG_SHIFT > 0
        for c = 2:NUM_REGIONS
            shifted((c - 1)*DIAG_SHIFT + 1:end, c) = DATASET(1:end - (c - 1)*DIAG_SHIFT, c);
            shifted(1:(c - 1)*DIAG_SHIFT, c) = DATASET(end - (c - 1)*DIAG_SHIFT + 1:end, c);
        end
    elseif DIAG_SHIFT < 0
        for c = 2:NUM_REGIONS
            shifted(1:end - (c - 1)*abs(DIAG_SHIFT), c) = DATASET((c - 1)*abs(DIAG_SHIFT) + 1:end, c);
            shifted(end - (c - 1)*abs(DIAG_SHIFT) + 1:end, c) = DATASET(1:(c - 1)*abs(DIAG_SHIFT), c);
        end
    end
    DATASET = shifted;
end




%{
FOR 3-D ARRAYS
shifted = zeros(size(DATASET));
shifted(:, 1, :) = DATASET(:, 1, :);
if SHIFT > 0
    for c = 2:NUM_REGIONS
        shifted((c - 1)*SHIFT + 1:end, c, :) = DATASET(1:end - (c - 1)*SHIFT, c, :);
        shifted(1:(c - 1)*SHIFT, c, :) = DATASET(end - (c - 1)*SHIFT + 1:end, c, :);
    end
elseif SHIFT < 0
    for c = 2:NUM_REGIONS
        shifted(1:end - (c - 1)*abs(SHIFT), c, :) = DATASET((c - 1)*abs(SHIFT) + 1:end, c, :);
        shifted(end - (c - 1)*abs(SHIFT) + 1:end, c, :) = DATASET(1:(c - 1)*abs(SHIFT), c, :);
    end
end
%}
