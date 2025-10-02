%% Script: plot_thorium_flux_budget.m
% 
% Purpose:
%   This script reads model output from thorium_flux_model_output.nc 
%   and calculates global and basin-scale totals for dust deposition 
%   (Jdep) and sedimentary fluxes (Jsed). It then generates a bar chart 
%   comparing contributions from dust and sediments.
%
% Inputs:
%   thorium_flux_model_output.nc (NetCDF file) containing:
%     - M3d: Ocean mask (1=ocean, 0=land)
%     - MSKS.*: Basin masks (Atlantic, Pacific, Indian, Southern)
%     - Th232, Th230: Thorium isotope concentrations (pM)
%     - Jsed, Jdep: 2D fluxes (mmol/m²/yr)
%     - Jsed3D, Jdep3D: 3D fluxes (mmol/m³/yr)
%     - VOL: Grid-cell volume (m³)
%     - x, y, z: Grid coordinates
%
% Outputs:
%   - Printed totals of dust deposition and sedimentary fluxes (Mmol/yr) 
%     for each ocean basin and globally
%   - A bar chart comparing deposition vs. sedimentary sources

%% --- Housekeeping ---
close all;   % close all figures
clear all;   % clear workspace

%% --- Load NetCDF file ---
filename = 'thorium_flux_model_output.nc';

% Ocean mask (M3d=1 for ocean, 0 for land)
M3d = ncread(filename,'M3d');
iocn = find(M3d==1);   % ocean grid cells only

% Basin masks
MSKS.ATL   = ncread(filename,'MSKS.ATL');   % Atlantic
MSKS.PAC   = ncread(filename,'MSKS.PAC');   % Pacific
MSKS.IND   = ncread(filename,'MSKS.IND');   % Indian
MSKS.SOUTH = ncread(filename,'MSKS.SOUTH'); % Southern

% Thorium isotope concentrations (pM)
Th232 = ncread(filename,'Th232');
Th230 = ncread(filename,'Th230');

% Fluxes: Jsed = sedimentary flux, Jdep = dust deposition
% Units: mmol/m²/yr (2D), mmol/m³/yr (3D)
Jsed    = ncread(filename,'Jsed');
Jdep    = ncread(filename,'Jdep');
Jsed3D  = ncread(filename,'Jsed3D'); Jsed3D = Jsed3D(iocn); % ocean only
Jdep3D  = ncread(filename,'Jdep3D'); Jdep3D = Jdep3D(iocn);

% Grid coordinates
x = ncread(filename,'x');  % longitude
y = ncread(filename,'y');  % latitude
z = ncread(filename,'z');  % depth

% Grid-cell volume (m³), restricted to ocean
VOL = ncread(filename,'VOL'); 
VOL = VOL(iocn);

%% --- Dust deposition totals (Jdep) ---
% Global
Jdep_tot = Jdep3D' * VOL / 1e9;   % convert to Mmol/yr

% By basin
I = find(MSKS.SOUTH(iocn)==1); Jdep_tot_SOUTH = Jdep3D(I)' * VOL(I) / 1e9;
I = find(MSKS.ATL(iocn)==1);   Jdep_tot_ATL   = Jdep3D(I)' * VOL(I) / 1e9;
I = find(MSKS.PAC(iocn)==1);   Jdep_tot_PAC   = Jdep3D(I)' * VOL(I) / 1e9;
I = find(MSKS.IND(iocn)==1);   Jdep_tot_IND   = Jdep3D(I)' * VOL(I) / 1e9;

%% --- Sedimentary flux totals (Jsed) ---
% Global
Jsed_tot = Jsed3D' * VOL / 1e9;   % convert to Mmol/yr

% By basin
I = find(MSKS.SOUTH(iocn)==1); Jsed_tot_SOUTH = Jsed3D(I)' * VOL(I) / 1e9;
I = find(MSKS.ATL(iocn)==1);   Jsed_tot_ATL   = Jsed3D(I)' * VOL(I) / 1e9;
I = find(MSKS.PAC(iocn)==1);   Jsed_tot_PAC   = Jsed3D(I)' * VOL(I) / 1e9;
I = find(MSKS.IND(iocn)==1);   Jsed_tot_IND   = Jsed3D(I)' * VOL(I) / 1e9;

%% --- Visualization ---
% Set up figure
f1 = figure(1);
whitebg(f1,'w');
set(f1,'color','w','position',[100 100 1000 500]);

% Bar data: [dust, sediment]
y = [Jdep_tot_ATL,   Jsed_tot_ATL; 
     Jdep_tot_IND,   Jsed_tot_IND;
     Jdep_tot_PAC,   Jsed_tot_PAC;
     Jdep_tot_SOUTH, Jsed_tot_SOUTH;
     NaN,            NaN;            % spacer
     Jdep_tot,       Jsed_tot];      % global total

% Category labels
xCats = categorical({'Atlantic Ocean','Indian Ocean','Pacific Ocean',...
                     'Southern Ocean','','Global total'});

% Plot bar chart
hBar = bar(y);
hAx = gca;
set(hAx,'Fontsize',12);
hAx.XTickLabel = xCats;
hAx.XTickLabelRotation = 0;

% Colors
hBar(1).FaceColor = '#4DBEEE';  % dust
hBar(2).FaceColor = '#77AC30';  % sediment

% Y-axis
hAx.YTick = 0:1:6;
hAx.YGrid = 'on';

% Labels and legend
legend('Dust deposition','Sedimentary source','fontsize',14,'Location','NorthWest');
ylabel('Mmol/yr','fontsize',14);

%% --- End of script ---
