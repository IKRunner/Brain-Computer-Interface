function visualizeFeats(ecog, x, y, subj_trainfeatsHeat)
    %
    % visualizeFeats.m
    %
    % Instructions: Function that visualizes normalized feature correlations 
    %               matrix as heatmap. Must pass in ecog data from 
    %               raw_training_data.mat.
    %
    % Input:    ecog:       3x1 Raw ECoG data
    %           x:          nx1 cell array of feature names
    %           y:          nx1 cell array of feature names
    %           
    % Output:   None:       ...
    % 
%% Code here
close all
figure
plots = tiledlayout(3,1);

% Iterate through all three subjects
 for subj = 1:size(ecog,1)
    %%%%%%%%%%%%%%%%%%%%% Compute heatmap %%%%%%%%%%%%%%%%%%%%%%%%
    % Create feature correlation matrix for each subject
    nexttile
    heatmap(x, y, corr(zscore(subj_trainfeatsHeat{subj})), 'Colormap',redbluecmap);
    ylabel(['\bf Subject: ', num2str(subj)]);
 end
 % Format plot
 title(plots, '\bf Feature Heatmap');
 plots.TileSpacing = 'compact';
end

