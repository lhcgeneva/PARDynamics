userpath('/Users/lhcge/Desktop/P_lineage_Analysis/PARDynamics/');
addpath(genpath('/Users/lhcge/Desktop/Code'));
addpath(genpath('/Users/lhcge/Desktop/PARmodelling'));
addpath(genpath('/Users/lhcge/Desktop/Analysed'));
rmpath(genpath('/Users/lhcge/Desktop/Code/.git'));
addpath(genpath('/Users/lhcge/Desktop/P_lineage_Analysis/PARDynamics/'));
addpath(genpath('/Users/lhcge/Desktop/P_lineage_Analysis/Figures/'));
rmpath(genpath('/Users/lhcge/Desktop/P_lineage_Analysis/PARDynamics/.git'));

%   To get FIJI functionality either add Fiji.app to path (Fiji.app has
%   a .jar called mij-1.3.6-fiji2.jar (or similar depending on the version
%   which can be called if added to the Matlab's path or add ij.jar or mij.
%   jar to the javapath
addpath(genpath('/Applications/Fiji.app/scripts/'));
% javaaddpath '/Applications/MATLAB_R2016a.app/java/jar/mij.jar';
% javaaddpath '/Applications/MATLAB_R2016a.app/java/jar/ij.jar';