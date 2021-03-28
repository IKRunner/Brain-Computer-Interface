function [out, mdl_name, pred] = mdlcrossVal(mdls,frac,ecog,dg,mdl_name)
    %
    % mdlcrossVal.m
    %
    % Instructions: Function that compares model predictions and plots
    %               comparisons between models. Must pass in ecog data from 
    %               raw_training_data.mat
    %
    % Input:    mdls:       nx1 cell array of models to cross-validate
    %           frac:       Partition fraction
    %           ecog:       3x1 Raw ECoG data
    %           dg:         3x1 Raw finger data
    %           mdl_name:   1xn cell array of char model names
    %           
    % Output:   out:        5x2xn matrix containing mean and std of
    %                       corrleation coefficients for each model across 
    %                       all subjects
    %           mdl_name:   nx1 cell array of models to cross-validate
    %           pred:       ...   
    % 
%% Cross Validate
% Container for k-fold cross-validation
% folds = num2cell(reshape(randperm(size(ecog{1},1)), size(ecog{1},1)/k, k), [1 k]);

% Load R matrices to workspace
load('Rmatrices_90','subj_trainRmat','subj_testRmat');
% Containter to store corr. coefficients for regression model
lin_corr = zeros(5,3,length(mdls));

% Container for predictions
pred = zeros(length(dg{1})-length(dg{1})*frac,5,3,length(mdls));

% Contianer to store output
out = zeros(5,2,numel(mdls));

% Iterate through all models
for mdl = 1:length(mdls)
    % Current model
    model = mdls{mdl};

     % Iterate through all three subjects
     for subj = 1:size(ecog,1)
        %%%%%%%%%%%%%%% Extract dataglove and ECoG data %%%%%%%%%%%%%%%
        % Finger data
        subj_dg_Train = dg{subj};
        subj_dg_Test = dg{subj};

        % Partition finger training data from k-1 fold
        subj_dg_Train = subj_dg_Train(1:length(subj_dg_Train)*frac,:);

        % Partition finger testing data from current fold
        subj_dg_Test = subj_dg_Test(length(subj_dg_Test)*frac+1:end,:);
        %%%%%%%%%%%%%%%%%%%%% Process features %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Downsample training finger data from R matrix, delete extra row 
        subj_dg_Train = downsample(subj_dg_Train, round(size(subj_dg_Train,...
        1)/size(subj_trainRmat{subj},1)));
        subj_dg_Train = subj_dg_Train(1:(end-1),:);
        %%%%%%%%%%% Angle predictions using linear regression %%%%%%%%%
        % Iterate through all fingers
        for fing = 1:5
            % Train model
            test_mdl = model(subj_trainRmat{subj}, subj_dg_Train(:,fing));

            % Predict using model
            ypred = predict(test_mdl, subj_testRmat{subj} );

            % Upsample predictions to match test data size
            ypred = resample(ypred, round(size(subj_dg_Test(:,fing))/size(ypred)),1);

            % Create vector of extrapolated points by mean of previous n points
            vect = repmat(mean(ypred(size(ypred,1)-(size(subj_dg_Test(:,fing),1)-...
            size(ypred,1))+1:end,:)), size(subj_dg_Test(:,fing),1)-size(ypred,1),1);

            % Update predictions and store
            pred(:,fing,subj,mdl) = [ypred; vect];

            % Correlation coefficient per finger per model
            lin_corr(fing,subj,mdl) = corr2(pred(:,fing,subj,mdl), subj_dg_Test(:,fing));
        end
     end
     % Save mean and std output
     out(:,1,mdl) = mean(lin_corr(:,:,mdl),2);
     out(:,2,mdl) = std(lin_corr(:,:,mdl),0,2);
end
%% Plot Output for Model Cross-Validation
close all
figure
for i = 1:length(mdl_name)
    e = errorbar(out(:,1,i), out(:,2,i), 'LineWidth',1);
    xticks(1:1:5);
    xlim([0 6])
    hold on;
    e.LineStyle = '--'; 
end
legend(mdl_name)
xlabel('\bf Fingers');
ylabel('\bf Correlation Coefficient');
title('\bf Model Performance Across all Subjects');
hold off;
end
