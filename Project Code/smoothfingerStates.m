function dg_descrip = smoothfingerStates(dg_descrip)
    %
    % smoothfingerStates.m
    %
    % Instructions: Function that smoothes finger states accoring to a
    % moving window
    %
    % Input:    dg_descrip:         3x1 cell array of finger states
    %
    % Output:   dg_descrip: 3x1 cell array of smoothed finger states
%% Code Here
% Smoothing factor every 4 seconds
sm = 4000;
% Iterate through all subject and fingers
for subj = 1:size(dg_descrip,1)
    for fing = 1:size(dg_descrip{subj},2) 
        % Current vector
        vect = dg_descrip{subj}(:,fing);
        % Find all peaks
       [~, idx] = findpeaks(double(dg_descrip{subj}(:,fing)));
       % Index corresponding to first peak
       first = idx(1);
       for i = 1:length(idx) 
           % Have not reached last pulse train of ones
           if idx(i) > first+sm 
               % Last pulse train of ones    
               last = idx(i-1);
               % Current range
               range = first:1:last;
               vect(range) = 1;
               first = idx(i);
           end
           % Merge last pulse train of ones
           if idx(i) == idx(end)
               last = idx(i);
               range = first:1:last;
               vect(range) = 1;
           end
       end
       % Update finger vector
       dg_descrip{subj}(:,fing) = vect;
    end
end
end
