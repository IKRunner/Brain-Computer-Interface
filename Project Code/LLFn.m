function [line_length] = LLFn(data)
% Calculate line length of each channel in window
line_length = zeros(1,size(data,2));
for col = 1:size(data,2)
    x = data(:,col);
    line_length(col) = sum(abs(x(2:end)-x(1:end-1)));
end

