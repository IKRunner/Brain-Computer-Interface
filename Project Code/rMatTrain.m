function [subj_trainRmat, mean_trainFeats, std_trainFeats] = rMatTrain(train_ecog,frac, f, winlen, winlap, numwin, no_feats)
    %
    % rMat.m
    %
    % Instructions: Function computes R feature matrix to use in linear
    % regression.
    %
    % Input:    f:          Smapling frequency
    %           frac:       Partition fractio for training data
    %           train_ecog: 3x1 Raw ECoG data
    %           winlen:     Window length
    %           winlap:     Window overlap
    %           numwin:     No. windows
    %           
    % Output:   subj_trainRmat:     3x1 cell R matrix for training data.
    % 
%% Code Here
% Container to store R matrices
subj_trainRmat = cell(length(train_ecog),1);

mean_trainFeats = cell(3,1);
std_trainFeats = cell(3,1);

%Iterate through all subjects
for subj = 1:size(train_ecog,1)
    %%%%%%%%%%%%%%%%% Extract dataglove and ECoG data %%%%%%%%%%%%%%%%%%%%%
    % ECoG and finger data
    subj_ecog = train_ecog{subj};
    
    % Partition ECoG data
    ecog_Train = subj_ecog(1:length(subj_ecog)*frac,:);
    %%%%%%%%%%%%%%%%%%%%%%% Generate R matrices %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % R training matrix 
    subj_trainFeats = getWindowedFeats(ecog_Train, f, winlen, winlap, no_feats);
    % Save statistics for use in test features
    mean_trainFeats{subj} = mean(subj_trainFeats,1);
    std_trainFeats{subj} =  std(subj_trainFeats,0,1);
    subj_trainRmat{subj} = create_R_matrix(zscore(subj_trainFeats), numwin);
end
end

