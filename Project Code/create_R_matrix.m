function [R]=create_R_matrix(features, N_wind)
    %
    % get_features_release.m
    %
    % Instructions: Write a function to calculate R matrix.             
    %
    % Input:    features:   (samples x (channels*features))
    %           N_wind:     Number of windows to use
    %
    % Output:   R:          (samples x (N_wind*channels*features))
    % 
%% Your code here (5 points)
% Initialize R matrix
R = zeros(size(features,1), N_wind*size(features,2));

% Append first N-1 rows to top of feature matrix
features = [features(1:N_wind-1,:); features];

% Loop through feature matrix and construct R matrix
for i = 1:size(features,1)
    % Stop once reached end of feature matrix
    if i+(N_wind-1) > size(features,1)
        break;
    end
    R(i,:) = reshape(features(i:i+(N_wind-1),:).',1,[]);
end
% Add column of ones
R = [ones(size(R,1),1) R];
end