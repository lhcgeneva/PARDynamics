setenv ('SGE_PROJECT', '');
setenv ('SGE_CONTEXT', 'exclusive');
setenv ('SGE_OPT', 'h_rt=0:15:0,mem=2G');
c = parcluster ('legion_R2016a');
myJob = createCommunicatingJob (c, 'Type', 'SPMD');
myJob = createCommunicatingJob (c, 'Type', 'SPMD');
num_workers = 12;
myJob.AttachedFiles = {};
myJob.AttachedFiles = {'cluster.m'};
myJob.AttachedFiles = {'cluster.m'};
myJob.NumWorkersRange = [num_workers, num_workers];
task = createTask (myJob, @cluster, 0, {});
submit(myJob)