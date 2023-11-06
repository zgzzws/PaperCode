%% F-measure
% close all
% clear all
% clc
figure('Color',[1 1 1]);
load('F_measure_glass04vs5_fix_omega.mat')
AA=F_measure_glass04vs5_fix_omega;
xa=[10 9 8 7 6 5 4 3 2 1];
ya=[20 19 18 17 16 15 14 13 12 11 ];
[x,y]=meshgrid(xa,ya);
%mesh(x,y,AA,'LineWidth',3.0)
colormap hsv
bar3(AA)
set(gca,'XTickLabel',xa);
set(gca,'YTickLabel',ya);
xlabel('-log10(\lambda)');
ylabel('-log10(\gamma)'); 
zlabel('F-measure')


