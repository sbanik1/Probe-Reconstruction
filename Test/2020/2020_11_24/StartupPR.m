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
    set(0,'DefaultFigureWindowStyle','docked')

    %% Computer Dependent Paths ===========================================
    % Mac =================================================================
    if ismac==1
        mac = char(java.net.InetAddress.getLocalHost.getHostName);
        if strcmp('MacBook-Pro',mac(1:11))==1
            FunctionsPath = '/Users/swarnav/Google Drive/Work/Projects/Probe Reconstruction/Probe-Reconstruction/Functions/';
            DataFolderPath = '/Users/swarnav/Google Drive/Work/Projects/Probe Reconstruction/Probe-Reconstruction/Test/';
            set(groot,'defaultAxesFontSize',15);
            set(groot,'defaultLegendFontSize',20);
        else
            fprintf('StartUpPR: this mac is not in the file\n')
        end
    end

end