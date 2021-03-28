function [comp, s_train, s_test] = vis_pcafeats(train_R,test_R)
    %
    % vis_pcafeats.m
    %
    % Instructions: Function that computes optimal principle compenents and
    % features cast in principle component space.
    %
    % Input:    train_R:    3x1 cell R-matrix training features
    %           test_R:     3x1 cell R-matrix test features
    %
    % Output:   s_train:    3x1 cell matrix of principle component features
    %                       from training data
    %           s_test:     3x1 cell matrix of principle component features
    %                       from test data
    %           comp:       3x1 vector of principle component scores per
    %                       subject
%% Code Here
% Contianers for training/testing scores
s_train = cell(3,1);
s_test = cell(3,1);
% Cutt-off for variance explained
var_exp = 99;
% Principle component values
comp = zeros(size(train_R,1),1);

% close all
% figure
% p1 = tiledlayout(1,3);

for subj = 1:size(train_R,1)
%     nexttile;
    % Compute pca statistics on features for every subject
    [coeff, s_train{subj}, ~, ~, exp_train, mu] = pca(train_R{subj});
%     plot(cumsum(exp_train)*0.01,  'LineWidth', 1); 
    
    % Clean up variance explained
    exp_train = round(cumsum(exp_train));
    
    % Extract index (Important principle compnent) 
    mask = 1:length(exp_train);
    idx = mask(exp_train == var_exp);
    comp(subj,1) = idx(1);
    
    % Line of most variance
%     hold on;
%     yline(99*0.01,  'LineWidth', 1);
    
    % Construct scores for testing features
    s_test{subj} = (test_R{subj} - repmat(mu,size(test_R{subj},1),1))/coeff';
end
% Format plot
% xlabel(p1,'\bf Principle Component');
% ylabel(p1,'\bf Cummulative Variance Explained');
% title(p1, '\bf Components Needed to Explain Variance (Train)');
end