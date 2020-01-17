
list = [];

for x = 0:10:170
    for y = 0:10:170
        list = [list, strcat(int2str(x), ", ", int2str(y))];
    end
end


rand = list(randperm(length(list)));

for i = 1:6:length(list)
    disp(sprintf('%s\t', rand(i:i + 5)));
end