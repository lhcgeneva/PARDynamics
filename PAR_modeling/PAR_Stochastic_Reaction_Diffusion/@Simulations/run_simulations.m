function [ Simulation_cell ] = run_simulations( Simu )
%run_simulations Runs simulations for all sets of parameters
%   Detailed explanation goes here
if height(Simu.param_table_full) < 8
    poolSize = height(Simu.param_table_full);
else
    poolSize = 8;
end

if isempty(gcp('nocreate'))
    parpool(poolSize);
else 
    tempPool = gcp;
    if tempPool.NumWorkers < poolSize
        delete(gcp('nocreate'));
        parpool(poolSize);
    end
end
pctRunOnAll javaaddpath('/Users/hubatsl/Desktop/P_lineage_analysis/GF_Algo/PAR_modeling/PAR_Stochastic_Reaction_Diffusion/3rdParty/ParforProgMon/')
ppm = ParforProgMon( 'Parallel Simu', height(Simu.param_table_full) );    
s_array = cell(height(Simu.param_table_full), 1);
parfor i = 1 : height(Simu.param_table_full);
    params = table2struct(Simu.param_table_full(i, 2:end));
    s_array{i} = PARsRDv1_0(['Simulation_', num2str(i)], Simu.simparams.numDom, ...
                            Simu.simparams.BoundaryC, Simu.simparams, params);
    ppm.increment();
end
Simulation_cell = reshape(s_array, height(Simu.param_table_summary), Simu.num_runs);
end

