%% An RBC model with asset price, irreversibility, and endogenous labor supply
% 2023.09.25
% Hanbaek Lee (hanbaeklee1@gmail.com)
% When you use the code, please cite the paper 
% "A Dynamically Consistent Global Nonlinear Solution 
% Method in the Sequence Space and Applications."
%=========================    
% this file is to check the monotonicity of value/policy function's
% along with the endogenous state in equilibrium.
%=========================    
%=========================    
% housekeeping
%=========================
% clc;
% clear variables;
% close all; 
% fnPath = './functions';
% addpath(fnPath);

%=========================
%load ss
%=========================
ss = load('../solutions/rbcassetirrendolabor_ss.mat');
globalSol = load('../solutions/rbcassetirrendolabor_bc.mat');
load('../solutions/rbcassetirrendolabor_bc.mat');

%=========================
%backward solution
%=========================
iA = vSimPath;
vA  = vGridA(iA);
vw  = (((1-pAalpha)*vA).^(1/pAalpha).*vK.*pEeta^pFrisch.*vC.^(pRiskAversion*pFrisch)).^(1/(1/pAalpha+pFrisch));
vr  = vA.^(1/pAalpha).*((1-pAalpha)./vw).^((1-pAalpha)/(pAalpha)) + (1-pDdelta)*(1-vLambda);
RHS = (1./vC).^(pRiskAversion).*(vr);

%%

vKsample = vK(BURNIN+1:requiredTime-BURNIN);
RHSsample = RHS(BURNIN+1:requiredTime-BURNIN);
vsimpathSample = vSimPath(BURNIN+1:requiredTime-BURNIN);

for iAlocation = 1:pNumGridA
tempK = vKsample(vsimpathSample==iAlocation);
tempRHS = RHSsample(vsimpathSample==iAlocation);
subplot(2,4,iAlocation);
scatter(tempK,tempRHS);
xlabel("K","FontSize",15);
ylabel("RHS of Euler","FontSize",15);
temptitle = append('A',num2str(iAlocation));
title(temptitle);
end
set(gcf, 'PaperPosition', [0 0 18 10]); %Position plot at left hand corner with width a and height b.
set(gcf, 'PaperSize', [18 10]); %Set the paper to have width a and height b.Grid off;
location = ['../figures/monotonicity.pdf'];
saveas(gcf, location);