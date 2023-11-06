%% F-measure
% close all
% clear all
% clc
figure('Color',[1 1 1]);
load('F_measure_glass04vs5_fix_gamma.mat')
AA=F_measure_glass04vs5_fix_gamma;
xa=[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
ya=[10 9 8 7 6 5 4 3 2 1];
[x,y]=meshgrid(xa,ya);
%mesh(x,y,AA,'LineWidth',3.0)
colormap hsv
bar3(AA)
set(gca,'XTickLabel',xa);
set(gca,'YTickLabel',ya);
xlabel('(\sigma)');
ylabel('-log10(\gamma)'); 
zlabel('F-measure')