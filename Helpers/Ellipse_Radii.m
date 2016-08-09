P3 = [  94,92,93,95,99,92,97,96,100,91;
        71,72,75,73,70,69,69,69,72,67];
    
P2 = [  153,138,139,146,134;
        107,112,106,118,110];
        
P1 =  [ 199,216,202,199,212,219,219,193,203,202,195,211,209,238;
        150,99,107,128,121,131,104,111,108,125,123,124,122,126];
    
P0 = [  322,357,303,310,288,315,319,323,333,332,296;
        205,220,224,189,195,212,205,219,204,225,225];

P0LongAv    = mean(P0(1, :))/2*0.157;
P0ShortAv   = mean(P0(2, :))/2*0.157;
P1LongAv    = mean(P1(1, :))/2*0.157;
P1ShortAv   = mean(P1(2, :))/2*0.157;
P2LongAv    = mean(P2(1, :))/2*0.157;
P2ShortAv   = mean(P2(2, :))/2*0.157;
P3LongAv    = mean(P3(1, :))/2*0.157;
P3ShortAv   = mean(P3(2, :))/2*0.157;

P0_ratio_array = (P0(1, :)./P0(2, :));
P1_ratio_array = (P1(1, :)./P1(2, :));
P2_ratio_array = (P2(1, :)./P2(2, :));
P3_ratio_array = (P3(1, :)./P3(2, :));

P0_ratio = mean(P0_ratio_array);
P1_ratio = mean(P1_ratio_array);
P2_ratio = mean(P2_ratio_array);
P3_ratio = mean(P3_ratio_array);

P0_std = std(P0_ratio_array);
P1_std = std(P1_ratio_array);
P2_std = std(P2_ratio_array);
P3_std = std(P3_ratio_array);

m = (1/P0_ratio + 1/P1_ratio + 1/P2_ratio + 1/P3_ratio)/4