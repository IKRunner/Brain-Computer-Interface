function [pred, dg_Test] = optlinDecode(leader, train_dg, frac, subj_trainRmat, subj_testRmat, pc)
    %
    % optlinDecode.m
    %
    % Instructions: Function that computes feature predictions and
    % correlation coefficients using optimal linear decoder algorithm
    %
    % Input:    train_dg:   3x1 raw finger data
    %           frac:       Partition fraction
    %
    % Output:   pred:       Angle predictions
    %           dg_Test:    3x1 Cell finger test data
%% Code Here
% Container for finger test data
dg_Test = cell(3,1);
% Container for predictions
pred = cell(3,1);

%Iterate through all subjects
for subj = 1:size(train_dg,1)
    %%%%%%%%%%%%%%%%% Extract dataglove and ECoG data %%%%%%%%%%%%%%%%%%%%%
    % Finger data
    subj_dg = train_dg{subj};
    
    % Partition finger position
    dg_Train = subj_dg(1:length(subj_dg)*frac,:);
    
    % Dealing with partition of training data as test data
    if frac < 1
        dg_Test{subj} = subj_dg(length(subj_dg)*frac+1:end,:);
    end
    % Dealing with leaderboard data as testing data
    if frac == 1
        dg_Test{subj} = leader{subj};
    end
    %%%%%%%%%%% Angle predictions using optimal linear decoding %%%%%%%%%%%
    % Downsample training finger data, delete extra row 
    dg_Train = downsample(dg_Train, round(size(dg_Train,1)/size(subj_trainRmat{subj}(:,1:pc(subj)),1)));
    dg_Train = dg_Train(1:(end-1),:);
    
    % Calculate f matrix for 5 fingers using equation (1)
    f_Mat = mldivide(subj_trainRmat{subj}(:,1:pc(subj))'*subj_trainRmat{subj}(:,1:pc(subj)),(subj_trainRmat{subj}(:,1:pc(subj))'*dg_Train));
    
    % Generate finger predictions
    subj_pred = subj_testRmat{subj}(:,1:pc(subj))*f_Mat;
    
    % Upsample prediction vector
    subj_pred =  resample(subj_pred, round(size(dg_Test{subj},1)/size(subj_pred,1)),1);
    
    % Create vector of extrapolated points by mean of previous n samples 
    vect = repmat(mean(subj_pred(size(subj_pred,1)-(size(dg_Test{subj},1)-...
        size(subj_pred,1))+1:end,:)), size(dg_Test{subj},1)-size(subj_pred,1),1);
    
    % Finalze finger angle prediction vector and store
    pred{subj} = [subj_pred; vect];    
end
end