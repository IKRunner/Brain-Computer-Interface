function [envelope_mag] = sEnvelop(data)
% Calculate magnitude of envelope of each channel in window
envelope_mag = zeros(1,size(data,2));
for col = 1:size(data,2)
    [up,~] = envelope(data(:,col));
    % Numerically integrate envelope
    envelope_mag(col) = trapz(up);
end
end

