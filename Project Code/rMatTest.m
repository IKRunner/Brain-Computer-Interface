function subj_testRmat = rMatTest(train_ecog, frac, f, winlen, winlap, numwin, no_feats, mean_trainR, std_trainR)
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
    % Output:   subj_testRmat:      3x1 cell R matrix for testing data.
    % 
%% Code Here
% Container to store R matrices
subj_testRmat = cell(length(train_ecog),1);

%Iterate through all subjects
for subj = 1:size(train_ecog,1)
    %%%%%%%%%%%%%%%%% Extract dataglove and ECoG data %%%%%%%%%%%%%%%%%%%%%
    % ECoG and finger data
    subj_ecog = train_ecog{subj};  
    
    % Partition ECoG data
    if frac < 1
        ecog_Test = subj_ecog(length(subj_ecog)*frac+1:end,:);
    end
    % Dealing with leaderboard data
    if frac == 1
        ecog_Test = subj_ecog;
    end
    %%%%%%%%%%%%%%%%%%%%%%% Generate R matrices %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % R test matrix 
    subj_testFeats = getWindowedFeats(ecog_Test, f, winlen, winlap, no_feats);
    
    % Normalize test features by training features then compute R matrix
    for col = 1:size(subj_testFeats,2)
        subj_testFeats(:,col) = (subj_testFeats(:,col) - mean_trainR{subj}(col))/(std_trainR{subj}(col));
    end
    subj_testRmat{subj} = create_R_matrix(subj_testFeats, numwin);  
end
end