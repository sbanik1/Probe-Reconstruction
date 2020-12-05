function [Functions,DataFolder] =   StartupPR
% =========================================================================
% Initializes settings and local paths
% Returns:
% gd: local path to ErNa's Google Drive folder
% 2020-12-03: Updated computer names
% =========================================================================
    restoredefaultpath;
    %% General Settings
    set(groot,'defaultAxesTickLabelInterpreter','latex');  
    set(groot,'defaultTextInterpreter','latex');
    set(groot,'defaultLegendInterpreter','latex');
    set(0,'DefaultFigureWindowStyle','docked')

    %% Computer Dependent Paths ===============================================
    % Windows =================================================================
    if ispc==1
        pc = getenv('computername');
        if strcmp('PC2',pc)==1
            Functions = 'C:\Users\ErNa\Google Drive\ErNa\';
        elseif strcmp('PC-ANALYSIS',pc)==1
            Functions = 'C:\Users\ernaj\Google Drive\ErNa\';
        elseif strcmp('SYSTEMADMINISTR',pc)==1
            Functions = 'C:\Users\ErNa\Google Drive (ernajqi@gmail.com)\ErNa\';
        else
            fprintf('StartUpPR: this PC is not in the file\n')
        end
    end

    % Mac =================================================================
    if ismac==1
        mac = char(java.net.InetAddress.getLocalHost.getHostName);
        if strcmp('MacBook-Pro',mac(1:11))==1
            Functions = '/Users/swarnav/Google Drive/Work/Projects/Probe Reconstruction/';
            DataFolder = '/Users/swarnav/Google Drive/Work/Projects/Probe Reconstruction/Data/';
            set(groot,'defaultAxesFontSize',15);
            set(groot,'defaultLegendFontSize',20);
        else
            fprintf('StartUpPR: this mac is not in the file\n')
        end
    end

end