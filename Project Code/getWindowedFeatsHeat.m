function [all_feats]=getWindowedFeatsHeat(raw_data, fs, window_length, window_overlap, no_features)
    %
    % getWindowedFeats_release.m
    %
    % Instructions: Write a function which processes data through the steps
    %               of filtering, feature calculation, creation of R matrix
    %               and returns features.
    %
    %               Points will be awarded for completing each step
    %               appropriately (note that if one of the functions you call
    %               within this script returns a bad output you won't be double
    %               penalized)
    %
    %               Note that you will need to run the filter_data and
    %               get_features functions within this script. We also 
    %               recommend applying the create_R_matrix function here
    %               too.
    %
    % Inputs:   raw_data:       The raw data for all patients
    %           fs:             The raw sampling frequency
    %           window_length:  The length of window
    %           window_overlap: The overlap in window
    %
    % Output:   all_feats:      All calculated features
    %
%% Your code here (3 points)
% First, filter the raw data
new_data = filter_data(raw_data);

% Sliding window function (Modified for final project)
NumWins = @(xLen, fs, winLen, winDisp) ((xLen/fs)-winLen+winDisp)/(winDisp); 

% Compute number of windows and create feature vector
num_windows = round(NumWins(size(new_data,1), fs, window_length,...
window_length-window_overlap));

% Calculate feature descriptor of first window
winDisp = (window_length-window_overlap)*fs;
idx = 1:1:(window_length*fs);

% Initialize feature vector
all_feats = zeros(num_windows, no_features);

% Process feature for first window
all_feats(1,:) = get_featuresHeat(new_data(idx,:), fs);

% Upper/lower bound for each window
lower = 1 + winDisp;
upper = (window_length*fs) + winDisp;

% Iterate through remaining windows
for win = 2:num_windows
    % Compute feature descriptor of every window
    idx = lower:1:upper;
    all_feats(win,:) = get_featuresHeat(new_data(idx,:), fs);
    lower = lower + winDisp;
    upper = upper + winDisp;
end
end