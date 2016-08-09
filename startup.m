userpath('/Users/hubatsl/Desktop/P_lineage_Analysis/GF_Algo');
addpath(genpath('/Users/hubatsl/Desktop/P_lineage_Analysis'));
addpath(genpath('/Users/hubatsl/Desktop/PAR_Stochastic_Reaction_Diffusion'));
javaaddpath '/Users/hubatsl/Desktop/P_lineage_analysis/GF_Algo/PAR_modeling/PAR_Stochastic_Reaction_Diffusion/3rdParty/ParforProgMon'

%   To get FIJI functionality either add Fiji.app to path (Fiji.app has
%   a .jar called mij-1.3.6-fiji2.jar (or similar depending on the version
%   which can be called if added to the Matlab's path or add ij.jar or mij.
%   jar to the javapath
addpath(genpath('/Applications/Fiji.app/scripts'));
% javaaddpath '/Applications/MATLAB_R2016a.app/java/jar/mij.jar';
% javaaddpath '/Applications/MATLAB_R2016a.app/java/jar/ij.jar';