function clean_data = filter_data(raw_eeg)
    %
    % filter_data_release.m
    %
    % Instructions: Write a filter function to clean underlying data.
    %               The filter type and parameters are up to you.
    %               Points will be awarded for reasonable filter type,
    %               parameters, and correct application. Please note there 
    %               are many acceptable answers, but make sure you aren't 
    %               throwing out crucial data or adversely distorting the 
    %               underlying data!
    %
    % Input:    raw_eeg (samples x channels)
    %
    % Output:   clean_data (samples x channels)
    % 
%% Your code here (2 points) 
    %%%%%%%%%%%%%%% Filter parameters taken from Kubánek et. al %%%%%%%%%%%
    FIR = load('FIR.mat');
    
    %Filter data from all channels using zero-phase filtering
    clean_data = filtfilt(FIR.FIR,1,raw_eeg);
end