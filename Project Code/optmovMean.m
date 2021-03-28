function [opt_winLen, opt_winLen_fing] = optmovMean(pred, dg_Test)
    %
    % optmovMean.m
    %
    % Instructions: Function that computes optimal window length for moving
    % average smoothing across all subjects
    %
    % Input:    pred:       Unfiltered predictions
    %           dg_Test:    3x1 cell test finger data
    %
    % Output:   opt_winLen:         Optimal window length
    %           opt_winLen_fing:    5x1 vector optimal window length per finger
%% Code here
% Container to store corrleation coefficients per finger per subject
lin_decCorr = zeros(size(dg_Test{1},2),size(dg_Test,1));
% Window size vector
windowsize = 100:1:4000;
% Container to store correlation coefficients
c = zeros(1,length(windowsize));
% Contianer to store smoothed predictions per finger per subject
mov_meanFing = zeros(length(windowsize),size(pred{1},2),size(dg_Test,1));
i = 0;
for k = 1:length(windowsize)
    i = i+1;
    for subj = 1:size(pred,1)
        % Extract correlation coefficients
        lin_decCorr(:,subj) = diag(corr(movmean(pred{subj}, windowsize(k)),...
        dg_Test{subj}));
        
        for fing = 1:size(pred{subj},2)
            % Extract corr. coeff. for all fingers/subjects
            mov_meanFing(i,fing,subj) = corr(movmean(pred{subj}(:,fing),...
            windowsize(k)), dg_Test{subj}(:,fing));
        end        
    end
    % Vector of correlation coefficients
	c(i) = mean(mean(lin_decCorr));
    % Mean correlation coefficients for all fingers across all window sizes
    c_fing = mean(mov_meanFing,3);
end
% Optimal window size
[~,idx] = max(c);
opt_winLen = windowsize(idx);
%% Plot output
close all
figure

plot(windowsize, c, 'LineWidth', 1);
hold on;
plot(opt_winLen,max(c), '-xr', 'LineWidth', 1, 'MarkerSize', 15);
hold off;

% Format plot
xlim([min(windowsize) max(windowsize)]);
xlabel('\bf Window Size');
ylabel('\bf Correlation Coefficient');
title('\bf Optimal Window Size for Moving Mean Smoothing (Linear)');
% legend([coeff win], 'Max correlation coefficient', 'Optimal window size')
%% Plot output
figure
p = tiledlayout(5,1);
opt_winLen_fing = zeros(5,1);
for fing = 1:5
    [~,idx] = max(c_fing(:,fing));
    opt_winLen_fing(fing) = windowsize(idx);

    nexttile
    plot(windowsize, c_fing(:,fing),'LineWidth', 1);
    xlim([min(windowsize) max(windowsize)]);
    ylabel(['\bf Finger ',num2str(fing)]);
    hold on;
    plot(opt_winLen_fing(fing), max(c_fing(:,fing)), '-xr', 'LineWidth', 1, 'MarkerSize', 15);
    hold off;
end
% Format plot
xlabel(p,'\bf Window Size');
ylabel(p,'\bf Correlation Coefficient');
title(p,'\bf Optimal Window Size for Moving Mean Smoothing - by Finger');

%Save optimal window length value
save('opt_winLen.mat', 'opt_winLen');
end