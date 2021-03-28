function subj_trainfeatsHeat = trainfeatsHeat(ecog,frac, f, winlen, winlap, no_feats)
    %
    % trainfeatsHeat.m
    %
    % Instructions: Function computes normalized M x no. feature matrix to be used 
    %               to compute heatmap for feature optimization. Saves
    %               output to file. Must pass in ecog data from 
    %               raw_training_data.mat
    %
    % Input:    frac:       Partition fraction
    %           ecog:       3x1 Raw ECoG data
    %           winlen:     Window length
    %           winlap:     Window overlap
    %           
    % Output:   subj_trainfeatsHeat:       3x1 cell array of features for
    %                                      each subject. Saved to path as 
    %                                      Heatmap_trainFeatures_frac.mat
    % 
%% Code Here
% Container to hold features
subj_trainfeatsHeat = cell(length(ecog),1);
 % Iterate through all three subjects
 for subj = 1:size(ecog,1)
    %%%%%%%%%%%%%%% Extract dataglove and ECoG data %%%%%%%%%%%%%%%
    % ECoG and finger data
    subj_ecog_Train = ecog{subj};
    
    % Partition ECoG training data according to frac
    subj_ecog_Train = subj_ecog_Train(1:length(subj_ecog_Train)*frac,:);
    %%%%%%%%%%%%%%%%%%%%% Extract features %%%%%%%%%%%%%%%%%%%%%%%%
     % Generate R training matrix 
    subj_trainfeatsHeat{subj} = zscore(getWindowedFeatsHeat(subj_ecog_Train, f, winlen, winlap, no_feats));
 end
 % Save output
 filename = 'Heatmap_trainFeatures';
 filename = [filename '_' num2str(frac*100)];
 save(filename,'subj_trainfeatsHeat');
end
