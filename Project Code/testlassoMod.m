function testlassoMod(leader, train_dg, frac, subj_trainRmat, subj_testRmat, pc)

% Container for finger test data
dg_Test = cell(3,1);

% Container for predictions
pred = cell(3,1);

lin_decCorr = zeros(5,3);

% Iterate through all alpha parameters
alpha = 0.01:0.1:1;
% Container to store correlation coefficients
c = zeros(1,length(alpha));
i = 0;
for k = 1:length(alpha)
    i = i+1;
    %%%%%%%%%%%%%%%%% Extract dataglove and ECoG data %%%%%%%%%%%%%%%%%%%%%
    %Iterate through all subjects
    for subj = 1:size(train_dg,1)
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
      %%%%%%%%%%%%%%%%%%%% Generate finger state model %%%%%%%%%%%%%%%%%%%% 
       % Downsample training finger data, delete extra row 
       dg_Train = downsample(dg_Train, round(size(dg_Train,1)/size(subj_trainRmat{subj}(:,1:pc(subj)),1)));
       dg_Train = dg_Train(1:(end-1),:);
       
       for fing = 1:size(train_dg{subj},2)
           %Train model on training data on current finger
           [B,FitInfo] = lasso(subj_trainRmat{subj}(:,1:pc(subj)),dg_Train(:,fing),'Alpha',alpha(k), 'CV',5);
           idxLambda1SE = FitInfo.Index1SE;
           coef = B(:,idxLambda1SE);
           coef0 = FitInfo.Intercept(idxLambda1SE);
            
            %Predict finger states
            yhat = subj_testRmat{subj}(:,1:pc(subj))*coef + coef0;
            
            % Upsample prediction vector
            yhat = resample(yhat, round(size(dg_Test{subj},1)/size(yhat,1)),1);
            
            % Create vector of extrapolated points by mean of previous n
            vect = repmat(mean(yhat(size(yhat,1)-(size(dg_Test{subj},1)-...
            size(yhat,1))+1:end,:)), size(dg_Test{subj},1)-size(yhat,1),1);
            
            % Finalze finger state prediction vector and store
            pred{subj}(:,fing) = [yhat; vect];
       end
       % Correlation values
       lin_decCorr(:,subj) = diag(corr(pred{subj}, dg_Test{subj})); 
       
    end
    % Vector of correlation coefficients
	c(i) = mean(mean(lin_decCorr));
end

% Optimal alpha 
[~,idx] = max(c);
opt_alpha = alpha(idx);

%% Plot output
close all
figure

plot(alpha, c, 'LineWidth', 1);
hold on;
plot(opt_alpha,max(c), '-xr', 'LineWidth', 1, 'MarkerSize', 15);
hold off;

% Format plot
xlim([min(alpha) max(alpha)]);
xlabel('\bf Alpha Parameter');
ylabel('\bf Correlation Coefficient');
title('\bf Optimal Alpha Size');

end
