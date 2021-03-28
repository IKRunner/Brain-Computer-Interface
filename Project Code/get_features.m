function [features] = get_features(clean_data,fs)
    %
    % get_features.m
    %
    % Instructions: Write a function to calculate features.
    %               Please create 4 OR MORE different features for each channel.
    %               Some of these features can be of the same type (for example, 
    %               power in different frequency bands, etc) but you should
    %               have at least 2 different types of features as well
    %               (Such as frequency dependent, signal morphology, etc.)
    %               Feel free to use features you have seen before in this
    %               class, features that have been used in the literature
    %               for similar problems, or design your own!
    %
    % Input:    clean_data: (samples x channels)
    %           fs:         sampling frequency
    %           
    % Output:   features:   (1 x (channels*features))
    % 
%% Your code here (8 points)
% Line Length is function 'LLFn' below

% Signal Energy
% Energy = @(x) sum(x.^2);

% Signal Area
% Area = @(x) sum(abs(x));

% Signal Envelope is function 'sEnvelop' below

% Average bandpower at Beta and high Gamma range
bBeta1 = @(x) bandpower(x,fs,[5 15]);
bBeta2 = @(x) bandpower(x,fs,[20 25]);
bGamma1 = @(x) bandpower(x,fs,[75 115]);
bGamma2 = @(x) bandpower(x,fs,[125 160]);
bGamma3 = @(x) bandpower(x,fs,[160 175]);

% Average signal power
% pRMS = @(x) rms(x).^2;

% Average signal value
avgVal = @(x) mean(x);

% Relative power at high Gamma range
% RbP = @(x) bandpower(x,fs,[75 115])./rms(x).^2;

% Spike density is function 'sDen' below

% Haart wavelet
haart_ecog = @(x) haart(x);

% Feature vector
features = [var(clean_data) LLFn(clean_data) bGamma1(clean_data) bGamma2(clean_data) ...
    bGamma3(clean_data) bBeta1(clean_data) bBeta2(clean_data) avgVal(clean_data) ...
    mean(haart_ecog(clean_data))];

end