function visualizePred(pred, dg, frac)
    %
    % visualizePred.m
    %
    % Instructions: Function that plots finger predictions for each subject
    % overlayed with test data
    %
    % Input:    pred:       Finger predictions
    %           frac:       Partition fraction
    %           dg:         3x1 Raw finger data
    %           
    % Output:   None:       ...   
    % 
%% Code Here
close all

% Figure data
ax = zeros(size(dg{1},2),1);
fig = zeros(size(dg,1),1);

for subj = 1:size(dg,1)
    fig(subj) = figure;
    p = tiledlayout(size(dg{1},2),1);
    
    for fing = 1:size(dg{1},2)
        % Current finger test data
        subj_dg = dg{subj};
        dg_Test = subj_dg(length(subj_dg)*frac+1:end,:);
        
        ax(fing) = nexttile;
       
        % Plot data
        plot(pred{subj}(:,fing));
        hold on
        plot(dg_Test(:,fing));
        
        hold off
        ylabel(ax(fing), ['\bf Finger ', num2str(fing)]);
    end
    title(p,['\bf Subject', num2str(subj)]);
    xlabel('\bf Samples');
    p.TileSpacing = 'compact';
end


end
