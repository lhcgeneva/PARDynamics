%%%%%Legend of abbreviations%%%%%%%%
% TC ... Temperature change

isParallel = 'on';
showGraph  = 'off';

%Pixel sizes in micrometer
pixelSize_SD60x2fold    = 0.124;
pixelSize_SD100x        = 0.155;
pixelSize_PR100x        = 0.158;
pixelSize_SD60x         = 0.255;
pixelSize_NateOldAndor  = 0.133; % Old Andor FRAPPA
pixelSize_NateAndor     = 0.129; % Andor 20101013
pixelSize_NateTony      = 0.202;

%%
%% DO NOT USE FOR ANALYSIS. NO STANDARDIZED IMAGING CONDITIONS 
%Repeat measurements to be sure they are correct, images only kept as examples!
%14_11_28 using Prairie, 14_12_03 using SD, error of about 2%, so data
%combined
IP2_NonMainStream_P0 = Experiment({'FIJI', 'Movies', 'IMA3', 'PAR2', 'P0', 'MIX', 'RT', '', 'NonMainStream'}, showGraph, isParallel, 0.156); %Mean between SD100x and PR100x, cause both data exist
WTDP2_NonMainStream_P1 = Experiment({'FIJI', 'Movies', 'WT_Dissection', 'PAR2', 'P1', 'MIX', 'RT', '', 'NonMainStream'}, showGraph, isParallel, pixelSize_SD60x2fold);
WTDP2_NonMainStream_Stills_P1 = Experiment({'FIJI', 'Stills', 'WT_Dissection', 'PAR2', 'P1', 'MIX', 'RT', '', 'NonMainStream'}, showGraph, 'off', pixelSize_SD60x2fold);
% PAR2 Dissection WT movies %CAREFUL, magnifications are not clear, no notes in labbook on objectives used!
WTDP2_P1 = Experiment({'FIJI', 'Movies', 'WT_Dissection', 'PAR2', 'P1', 'MIX', 'RT', '', ''}, showGraph, isParallel, pixelSize_SD60x2fold);
WTDP2_P2 = Experiment({'FIJI', 'Movies', 'WT_Dissection', 'PAR2', 'P2', 'MIX', 'RT', '', ''}, showGraph, isParallel, pixelSize_SD100x);
WTDP2_P3 = Experiment({'FIJI', 'Movies', 'WT_Dissection', 'PAR2', 'P3', 'MIX', 'RT', '', ''}, showGraph, isParallel, pixelSize_SD100x);

WTDP2_P1_NG0043_1_P2 = Experiment({'FIJI', 'Movies', 'WT_Dissection', 'PAR2', 'P1', 'NG0043', '20DEG', 'SP', 'ZStack'}, showGraph, isParallel, pixelSize_SD60x2fold);
WTDP2_P1_NG0043_2_P2 = Experiment({'FIJI', 'Movies', 'WT_Dissection', 'PAR2', 'P1', 'NG0043', '20DEG', 'SP', ''}, showGraph, isParallel, pixelSize_SD60x2fold);

% PAR2 Dissection WT stills
WTDP2_Stills_P1 = Experiment({'FIJI', 'Stills', 'WT_Dissection', 'PAR2', 'P1', 'MIX', 'RT', '', ''}, showGraph, 'off', pixelSize_SD60x2fold);
WTDP2_Stills_P2 = Experiment({'FIJI', 'Stills', 'WT_Dissection', 'PAR2', 'P2', 'MIX', 'RT', '', ''}, showGraph, 'off', pixelSize_SD100x);
WTDP2_Stills_P3 = Experiment({'FIJI', 'Stills', 'WT_Dissection', 'PAR2', 'P3', 'MIX', 'RT', '', ''}, showGraph, 'off', pixelSize_SD100x);
%% Nate's data, snapshots, for convenience put in movies (one dataset per movie)
WTP2_P0_R = Experiment({'FIJI', 'Movies', 'WT', 'PAR2', 'P0', 'TH411', 'RT', 'DD', 'NateSnapshotsR2G6_Cherry'}, 'off', isParallel, pixelSize_NateAndor);
WTP2_P0_G = Experiment({'FIJI', 'Movies', 'WT', 'PAR2', 'P0', 'NG0043', 'RT', 'DD', 'NateSnapshotsR6G2_GFP'}, 'off', isParallel, pixelSize_NateAndor);
%%
WTP2_P0_NatePAR_2THvsJS20101013_GSP2okrol2_3    = Experiment({'FIJI', 'Movies', 'WT', 'PAR2', 'P0', 'NG0059', 'RT', 'DD', 'NatePAR-2THvsJS20101013_GSP2okrol2-3'}, 'off', isParallel, pixelSize_NateTony);
WTP2_P0_NatePAR_2THvsJS20101013_GSP2okrol3_3    = Experiment({'FIJI', 'Movies', 'WT', 'PAR2', 'P0', 'NG0059', 'RT', 'DD', 'NatePAR-2THvsJS20101013_GSP2okrol3-3'}, 'off', isParallel, pixelSize_NateTony);
WTP2_P0_GP0_NatePAR_2THvsJS20101013_THP2ok      = Experiment({'FIJI', 'Movies', 'WT', 'PAR2', 'P0', 'TH413', 'RT', 'DD', 'NatePAR-2THvsJS20101013_THP2ok'}, 'off', isParallel, pixelSize_NateTony);
WTP2_P0_GP0_NatePAR_2_par_2RNAi                 = Experiment({'FIJI', 'Movies', 'PAR2RNAI', 'PAR2', 'P0', 'TH129', 'RT', 'DD', 'NatePAR-2(par-2RNAi)'}, 'off', isParallel, pixelSize_NateTony);
WTP2_P0_NatePAR_2_CAI_20110623_ok10c            = Experiment({'FIJI', 'Movies', 'CAI041', 'PAR2', 'P0', 'TH129', 'RT', 'DD', 'NatePAR-2(CAI 20110623)ok10c'}, 'off', isParallel, pixelSize_NateTony);
WTP2_P0_NatePAR_2_CAI_20110623_ok616a1          = Experiment({'FIJI', 'Movies', 'CAI026', 'PAR2', 'P0', 'TH414', 'RT', 'DD', 'NatePAR-2(CAI 20110623)ok616a1'}, 'off', isParallel, pixelSize_NateTony);%low PAR-2
WTP2_P0_NatePAR_2_CAI_20110623_ok618a8d         = Experiment({'FIJI', 'Movies', 'CAI06', 'PAR2', 'P0', 'TH415', 'RT', 'DD', 'NatePAR-2(CAI 20110623)ok618a8d'}, 'off', isParallel, pixelSize_NateTony);%high PAR-2
WTP2_P0_NatePAR_2_CAI_20110912_ok10c            = Experiment({'FIJI', 'Movies', 'CAI041', 'PAR2', 'P0', 'TH129', 'RT', 'DD', 'NatePAR-2(CAI 20110912)ok10c'}, 'off', isParallel, pixelSize_NateTony);
WTP2_P0_NatePAR_2_CAI_20110912_ok616a1          = Experiment({'FIJI', 'Movies', 'CAI026', 'PAR2', 'P0', 'TH414', 'RT', 'DD', 'NatePAR-2(CAI 20110912)ok616a1'}, 'off', isParallel, pixelSize_NateTony);
WTP2_P0_NatePAR_2_CAI_20110912_ok618a8d         = Experiment({'FIJI', 'Movies', 'CAI06', 'PAR2', 'P0', 'TH415', 'RT', 'DD', 'NatePAR-2(CAI 20110912)ok618a8d'}, 'off', isParallel, pixelSize_NateTony);

%% PAR2 WT
WTP2_P0_MaintenanceLongMovies_TH129_PH = Experiment({'FIJI', 'Movies', 'WT', 'PAR2', 'P0', 'TH129', 'RT', 'PH', 'MaintenanceLongMovies'}, 'off', isParallel, pixelSize_SD60x2fold);
WTP6_P0_TH411_VaryIntensityPrairie = Experiment({'FIJI', 'Movies', 'WT', 'PAR6', 'P0', 'TH411', 'RT', 'PH', 'MaintenancePrairieVaryIntensityPinhole60'}, 'on', isParallel, pixelSize_PR100x);
WTP2_P0_TH411_VaryIntensity = Experiment({'FIJI', 'Movies', 'WT', 'PAR2', 'P0', 'TH411', 'RT', 'SP', 'MaintenanceVaryIntensity'}, 'off', isParallel, pixelSize_SD60x2fold);
WTP6_P0_TH411_VaryIntensity = Experiment({'FIJI', 'Movies', 'WT', 'PAR6', 'P0', 'TH411', 'RT', 'SP', 'MaintenanceVaryIntensity'}, 'off', isParallel, pixelSize_SD60x2fold);
%%
WTP2_P0_Maintenance_TH129_PH = Experiment({'FIJI', 'Movies', 'WT', 'PAR2', 'P0', 'TH129', 'RT', 'PH', 'Maintenance'}, 'off', isParallel, pixelSize_SD60x2fold);
WTP2_P0_Maintenance_TH129_SP = Experiment({'FIJI', 'Movies', 'WT', 'PAR2', 'P0', 'TH129', 'RT', 'SP', 'Maintenance'}, 'off', isParallel, pixelSize_SD60x2fold);
WTP2_P0_Maintenance_NG43_PH = Experiment({'FIJI', 'Movies', 'WT', 'PAR2', 'P0', 'NG0043', 'RT', 'PH', 'Maintenance'}, 'off', isParallel, pixelSize_SD60x2fold);
WTP2_P0_Maintenance_NG43_SP = Experiment({'FIJI', 'Movies', 'WT', 'PAR2', 'P0', 'NG0043', 'RT', 'SP', 'Maintenance'}, 'off', isParallel, pixelSize_SD60x2fold);
WTP2_P0_Maintenance_NG18_PH = Experiment({'FIJI', 'Movies', 'WT', 'PAR2', 'P0', 'NG0018', 'RT', 'PH', 'Maintenance'}, 'off', isParallel, pixelSize_SD60x2fold);
WTP2_P0_Maintenance_NG18_SP = Experiment({'FIJI', 'Movies', 'WT', 'PAR2', 'P0', 'NG0018', 'RT', 'SP', 'Maintenance'}, 'off', isParallel, pixelSize_SD60x2fold);
%% 10
WTP2_P0_Maintenance_TH129_10DEG_PH = Experiment({'FIJI', 'Movies', 'WT', 'PAR2', 'P0', 'TH129', '10DEG', 'PH', 'Maintenance'}, 'off', isParallel, pixelSize_SD60x2fold);
WTP2_P0_Maintenance_TH129_10DEG_SP = Experiment({'FIJI', 'Movies', 'WT', 'PAR2', 'P0', 'TH129', '10DEG', 'SP', 'Maintenance'}, 'off', isParallel, pixelSize_SD60x2fold);
%% PAR2 IMA3
IP2_P0 = Experiment({'FIJI', 'Movies', 'IMA3', 'PAR2', 'P0', 'MIX', 'RT', '', ''}, showGraph, isParallel, pixelSize_SD60x2fold);
IP2_P1 = Experiment({'FIJI', 'Movies', 'IMA3', 'PAR2', 'P1', 'MIX', 'RT', '', ''}, showGraph, isParallel, pixelSize_SD60x2fold);
IP2_P2 = Experiment({'FIJI', 'Movies', 'IMA3', 'PAR2', 'P2', 'MIX', 'RT', '', ''}, showGraph, isParallel, pixelSize_SD60x2fold);
IP2_P3 = Experiment({'FIJI', 'Movies', 'IMA3', 'PAR2', 'P3', 'MIX', 'RT', '', ''}, showGraph, isParallel, pixelSize_SD60x2fold); %Doesn't really look polarized!
IP2_P0_TC = Experiment({'FIJI', 'Movies', 'IMA3', 'PAR2', 'P0', 'NG0043', 'TC', 'SP', 'TemperatureChange'}, showGraph, isParallel, pixelSize_SD60x2fold);
IP2_P0_NG43 = Experiment({'FIJI', 'Movies', 'IMA3', 'PAR2', 'P0', 'NG0043', '20DEG', 'SP', ''}, showGraph, isParallel, pixelSize_SD60x2fold);
%% PAR6 IMA3
IP6_P0_TC = Experiment({'FIJI', 'Movies', 'IMA3', 'PAR6', 'P0', 'NG0043', 'TC', 'SP', 'TemperatureChange'}, showGraph, isParallel, pixelSize_SD60x2fold);
%% PAR2 WT Stills
WTP2_Stills_P0 = Experiment({'FIJI', 'Stills', 'WT', 'PAR2', 'P0', 'MIX', 'RT', '', ''}, showGraph, 'off', pixelSize_PR100x);
WTP2_Stills_P1 = Experiment({'FIJI', 'Stills', 'WT', 'PAR2', 'P1', 'MIX', 'RT', '', ''}, showGraph, 'off', pixelSize_PR100x);
WTP2_Stills_P2 = Experiment({'FIJI', 'Stills', 'WT', 'PAR2', 'P2', 'MIX', 'RT', '', ''}, showGraph, 'off', pixelSize_PR100x);
WTP2_Stills_P3 = Experiment({'FIJI', 'Stills', 'WT', 'PAR2', 'P3', 'MIX', 'RT', '', ''}, showGraph, 'off', pixelSize_PR100x);
%% PAR2 IMA3 Stills
IP2_Stills_P0 = Experiment({'FIJI', 'Stills', 'IMA3', 'PAR2', 'P0', 'MIX', 'RT', '', ''}, showGraph, 'off', pixelSize_SD60x2fold);
IP2_Stills_P1 = Experiment({'FIJI', 'Stills', 'IMA3', 'PAR2', 'P1', 'MIX', 'RT', '', ''}, showGraph, 'off', pixelSize_SD60x2fold);
IP2_Stills_P2 = Experiment({'FIJI', 'Stills', 'IMA3', 'PAR2', 'P2', 'MIX', 'RT', '', ''}, showGraph, 'off', pixelSize_SD60x2fold);
IP2_Stills_P3 = Experiment({'FIJI', 'Stills', 'IMA3', 'PAR2', 'P3', 'MIX', 'RT', '', ''}, showGraph, 'off', pixelSize_SD60x2fold);
%% PAR2 BIG1 Movies
B1P2_Movies_P0_PH = Experiment({'FIJI', 'Movies', 'BIG1', 'PAR2', 'P0', 'NG0073', 'RT', 'PH', ''}, showGraph, isParallel, pixelSize_SD60x);
B1P2_Movies_P0_SP = Experiment({'FIJI', 'Movies', 'BIG1', 'PAR2', 'P0', 'NG0073', 'RT', 'SP', ''}, showGraph, isParallel, pixelSize_SD60x);
B1P2_Movies_P2_SP_GradientSharpening = Experiment({'FIJI', 'Movies', 'BIG1', 'PAR2', 'P2', 'NG0073', '20DEG', 'SP', 'GradientSharpening'}, showGraph, isParallel, pixelSize_SD60x2fold);
B1P2_Movies_P3_SP_GradientSharpening = Experiment({'FIJI', 'Movies', 'BIG1', 'PAR2', 'P3', 'NG0073', '20DEG', 'SP', 'GradientSharpening'}, showGraph, isParallel, pixelSize_SD60x2fold);
%% PAR6 BIG1 Movies
B1P6_Movies_P0 = Experiment({'FIJI', 'Movies', 'BIG1', 'PAR6', 'P0', 'NG0073', 'RT', 'SP', ''}, showGraph, isParallel, pixelSize_SD60x);
%% PAR2 BIG1 Stills
B1P2_Stills_P0_PH = Experiment({'FIJI', 'Stills', 'BIG1', 'PAR2', 'P0', 'NG0073', 'RT', 'PH', ''}, showGraph, 'off', pixelSize_SD60x);
B1P2_Stills_P1_PH = Experiment({'FIJI', 'Stills', 'BIG1', 'PAR2', 'P1', 'NG0073', 'RT', 'PH', ''}, showGraph, 'off', pixelSize_SD60x);
B1P2_Stills_P0_SP = Experiment({'FIJI', 'Stills', 'BIG1', 'PAR2', 'P0', 'NG0073', 'RT', 'SP', ''}, showGraph, 'off', pixelSize_SD60x);
B1P2_Stills_P1_SP = Experiment({'FIJI', 'Stills', 'BIG1', 'PAR2', 'P1', 'NG0073', 'RT', 'SP', ''}, showGraph, 'off', pixelSize_SD60x);
%% PAR6 WT Movies
WTP6_P0_Maintenance_NG43_PH = Experiment({'FIJI', 'Movies', 'WT', 'PAR6', 'P0', 'NG0043', 'RT', 'PH', 'Maintenance'}, 'off', isParallel, pixelSize_SD60x2fold);
WTP6_P0_Maintenance_NG43_SP = Experiment({'FIJI', 'Movies', 'WT', 'PAR6', 'P0', 'NG0043', 'RT', 'SP', 'Maintenance'}, 'off', isParallel, pixelSize_SD60x2fold);
%% PAR6 BIG1 Stills
B1P6_Stills_P0 = Experiment({'FIJI', 'Stills', 'BIG1', 'PAR6', 'P0', 'NG0073', 'RT', 'SP', ''}, showGraph, 'off', pixelSize_SD60x);
B1P6_Stills_P1 = Experiment({'FIJI', 'Stills', 'BIG1', 'PAR6', 'P1', 'NG0073', 'RT', 'SP', ''}, showGraph, 'off', pixelSize_SD60x);
%% PAR6 Dissections
WTDP6_P1_NG0043_1 = Experiment({'FIJI', 'Movies', 'WT_Dissection', 'PAR6', 'P1', 'NG0043', '20DEG', 'SP', 'ZStack'}, showGraph, isParallel, pixelSize_SD60x2fold);
WTDP6_P1_NG0043_2 = Experiment({'FIJI', 'Movies', 'WT_Dissection', 'PAR6', 'P1', 'NG0043', '20DEG', 'SP', ''}, showGraph, isParallel, pixelSize_SD60x2fold);