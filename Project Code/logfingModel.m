function log_pred = logfingModel(leader, frac, train_R, test_R, f_descrip, pc)
    %
    % logfingModel.m
    %
    % Instructions: Function that generates logistic regression predictions
    % based on finger state data
    %
    % Input:    frac:           Partition fraction
    %           f_descrip:      3x1 cell of finger state data
    %           train_R:        3x1 cell matrix of principle component features
    %                           from training data
    %           test_R:         3x1 cell matrix of principle component features
    %                           from test data
    %           pc:             3x1 vector of principle components for each
    %                           subject
    %           leader:         3x1 cell matrix of leaderboard test data
    % Output:   log_pred:       3x1 cell matrix of logistic predictions
%% Code Here
% Container for finger test data
f_Test = cell(3,1);

% Container for predictions
log_pred = cell(3,1);

%Iterate through all subjects
for subj = 1:size(f_descrip,1)
    % Finger descriptions
    subj_f = f_descrip{subj};
    
    % Partition finger descriptions
    f_Train = subj_f(1:length(subj_f)*frac,:);
    
    % Dealing with partition of training data as test data
    if frac < 1
        f_Test{subj} = subj_f(length(subj_f)*frac+1:end,:);
    end
    % Dealing with leaderboard data as testing data
    if frac == 1
        f_Test{subj} = leader{subj};
    end
%%%%%%%%%%%%%%%%%%%%%%% Generate finger state model %%%%%%%%%%%%%%%%%%%%%%%
    % Downsample finger states, delete extra row 
    f_Train = downsample(f_Train, round(size(f_Train,1)/size(train_R{subj}(:,1:pc(subj)),1)));
    f_Train = f_Train(1:(end-1),:);
    
    for fing = 1:size(f_descrip{subj},2)
        %Train model on training data
        mdl = fitglm(train_R{subj}(:,1:pc(subj)), f_Train(:,fing));
        
        %Predict finger states
        prob = predict(mdl, test_R{subj}(:,1:pc(subj)));
        
        % Upsample finger state vector
        prob = resample(prob, round(size(f_Test{subj},1)/size(prob,1)),1);       
    
        % Create vector of extrapolated points by mean of previous n 
        vect = repmat(mean(prob(size(prob,1)-(size(f_Test{subj},1)-...
            size(prob,1))+1:end,:)), size(f_Test{subj},1)-size(prob,1),1);
       
        % Finalze finger state prediction vector and store
        log_pred{subj}(:,fing) = [prob; vect]; 
    end
end
