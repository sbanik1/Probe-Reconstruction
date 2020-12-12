function [FunctionsPath,DataFolderPath] =   StartupPR
% =========================================================================
% Initializes settings and local paths
% Returns:
%   FunctionsPath: local path to directory containing all functions
%   DataFolderPath: local path to directory containing data
% =========================================================================
    restoredefaultpath;
    %% General Settings
    set(groot,'defaultAxesTickLabelInterpreter','latex');  
    set(groot,'defaultTextInterpreter','latex');
    set(groot,'defaultLegendInterpreter','latex');
    set(0,'DefaultFigureWindowStyle','docked');
    set(groot,'defaultAxesFontSize',15);
    set(groot,'defaultLegendFontSize',20);

    %% Computer Dependent Paths ===========================================
    FunctionsPath = '/Users/swarnav/Google Drive/Work/Projects/Probe Reconstruction/Probe-Reconstruction/Functions/';
    DataFolderPath = '/Users/swarnav/Google Drive/Work/Projects/Probe Reconstruction/Probe-Reconstruction/Test/';

end