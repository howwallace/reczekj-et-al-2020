function plot3d(A)
    X = 1:length(A);
    Y = 1:length(A(1, :));
    Z = zeros(1, length(X));
    
    X
    Y

    for x_i = 1:length(A)
        Z = A(x_i, :);
        Z
        hold all;
        plot3(X, Y, Z);
        Z = zeros(length(A), length(A(1, :)));
    end
end