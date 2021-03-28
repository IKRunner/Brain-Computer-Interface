%% (1) Final Project Part 2 (Ikenna Achilihu)
close all;
clc;

% Load raw ECoG data and ECoG test data
load('raw_training_data.mat', 'train_dg', 'train_ecog');
load('leaderboard_data.mat', 'leaderboard_ecog');
% Partiiton fraction for model validation
frac = 0.9;
% Sampling freqneucy
Fs = 1000;
% Window Length
win_len = 0.08;
% Window overlap
win_lap = 0.04;
% Number of windows
num_win = 3;
% Number of features
no_feats = 9;

%% Uncomment for Training Feature Heatmap Creation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% subj_trainfeatsHeat = trainfeatsHeat(train_ecog, frac, Fs, win_len, win_lap, no_feats);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Uncomment for Feature Heatmap Visualization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% xvalues = {'Variance','LLFn', 'bGamma','sDen','Haart'};
% yvalues = {'Variance','LLFn', 'bGamma','sDen','Haart'};
% visualizeFeats(train_ecog, xvalues, yvalues, subj_trainfeatsHeat);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% (2) Uncomment for R matrix Creation from Training Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[trainRmat, mean_trainF, std_trainF] = rMatTrain(train_ecog, frac, Fs, win_len, win_lap, num_win, no_feats);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% (3) Uncomment for R matrix Creation from Testing Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
testRmat = rMatTest(train_ecog, frac, Fs, win_len, win_lap, num_win, no_feats, mean_trainF, std_trainF);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% (4) Uncomment to Generate Principle Component Scores
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[princ_comp, sc_train, sc_test] = vis_pcafeats(trainRmat, testRmat);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% (5) Uncomment to Compute Predicitons with Optimal Linear Decoder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[predictions, dg_Test] = optlinDecode(leaderboard_ecog, train_dg, frac, sc_train, sc_test, princ_comp);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Lasso Test
% [predicitons, dg_Test] = testlassoMod(leaderboard_ecog, train_dg, frac, sc_train, sc_test, princ_comp);
%% (6) Uncomment to Determine Optimal Paramter for Smoothing Predictions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[opt_Len, opt_Len_fing] = optmovMean(predictions, dg_Test);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% (7) Uncomment to Smooth Predictions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
smooth_Pred = smoothPred(predictions, opt_Len);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% (8) Uncomment to Classify Finger Data as Action/non-action State
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
finger_description = classifyFinger(train_dg);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% (9) Uncomment to Smooth Finger Data States
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
smoothdg_descrip = smoothfingerStates(finger_description);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% (10) Uncomment to Generate Finger State Predictions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
log_pred = logfingModel(leaderboard_ecog, frac, sc_train, sc_test, smoothdg_descrip, princ_comp);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% (11) Uncomment to Determine Optimal Paramter for Smoothing Finger States
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
opt_lenLog = optmovMeanLog(log_pred, smooth_Pred, dg_Test);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% (12) Uncomment to Smooth Finger State Predictions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
smooth_logPred = smoothPred(log_pred, opt_lenLog);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%% (13) Uncomment to Final Compute Logistic-Weighted Predictions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
final_Pred = finalPred(smooth_logPred, smooth_Pred);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Confirm Prediction Estimates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test(:,1) = diag(corr(final_Pred{1}, dg_Test{1}));
test(:,2) = diag(corr(final_Pred{2}, dg_Test{2}));
test(:,3) = diag(corr(final_Pred{3}, dg_Test{3})); 
mean(mean(test))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Run Make Predictions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
predicted_dg = make_predictions(leaderboard_ecog);
save('predicted_dg.mat', 'predicted_dg');
toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Uncomment to Visualize Predictions against Finger Test Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% visualizePred(final_Pred, train_dg, frac);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Uncomment for Model Cross-Validation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Parameters for cross-validation
% lm = @(x,y) fitlm(x,y);
% svm = @(x,y) fitrsvm(x,y);
% steplm = @(x,y) stepwiselm(x,y,'PEnter',0.06);
% models = {lm};
% model_names = {'linear Model'};
% [coeff_val, model_names, ~] = mdlcrossVal(models, frac, train_ecog, train_dg, model_names);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

