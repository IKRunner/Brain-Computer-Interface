function [peaks] = sDen(data)
% Calculate no. of peaks of each channel in window
peaks = zeros(1,size(data,2));
for col = 1:size(data,2)
    peaks(col) = length(findpeaks(data(:,col)));
end
end

