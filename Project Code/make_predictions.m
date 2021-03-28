function [predicted_dg] = make_predictions(test_ecog)

% INPUTS: test_ecog - 3 x 1 cell array containing ECoG for each subject, where test_ecog{i} 
% to the ECoG for subject i. Each cell element contains a N x M testing ECoG,
% where N is the number of samples and M is the number of EEG channels.

% OUTPUTS: predicted_dg - 3 x 1 cell array, where predicted_dg{i} contains the 
% data_glove prediction for subject i, which is an N x 5 matrix (for
% fingers 1:5)

% Run time: The script has to run less than 1 hour. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Code here
close all;
clc;

% Load optimal window length parameter for moving average smoothing
load('opt_winLen.mat', 'opt_winLen');
load('opt_lenLog.mat', 'opt_lenLog');
% Load raw ECoG data and ECoG test data
load('raw_training_data.mat', 'train_dg', 'train_ecog');
% Partiiton fraction for model validation
frac = 1;
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

% Generate training/testing features
[trainRmat, mean_trainF, std_trainF] = rMatTrain(train_ecog, frac, Fs, win_len, win_lap, num_win, no_feats);
testRmat = rMatTest(test_ecog, frac, Fs, win_len, win_lap, num_win, no_feats, mean_trainF, std_trainF);

% Use features to generate principle components
[princ_comp, sc_train, sc_test] = vis_pcafeats(trainRmat, testRmat);

% Generate linear predictions
[predictions, ~] = optlinDecode(test_ecog, train_dg, frac, sc_train, sc_test, princ_comp);

% Smooth linear predictions
smooth_Pred = smoothPred(predictions, opt_winLen);

% Classify finger state/non-state data
finger_description = classifyFinger(train_dg);

% Smooth finger data states
smoothdg_descrip = smoothfingerStates(finger_description);

% Generate finger state predictions
log_pred = logfingModel(test_ecog, frac, sc_train, sc_test, smoothdg_descrip, princ_comp);

% Smooth finger state predictions
smooth_logPred = smoothPred(log_pred, opt_lenLog);

% Generate final logistic-weighted predictions
predicted_dg = finalPred(smooth_logPred, smooth_Pred);
end