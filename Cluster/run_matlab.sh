#!/bin/bash -l

# Batch script to run a multi-threaded Matlab job on Legion with the upgraded
# software stack under SGE.
#
# Based on openmp.sh by:
# Owain Kenway, Research Computing, 20/Sept/2010
# Updated for RHEL 7, Oct 2015

# 1. Force bash as the executing shell.
#$ -S /bin/bash

# 2. Request ten minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=0:10:0

# 3. Request 1 gigabyte of RAM.
#$ -l mem=1G

# 4. Select 12 threads (the most possible on Legion).
#$ -pe smp 12

# 5. Reserve one Matlab licence - this stops your job starting and failing when no
#    licences are available.
#$ -l matlab=1

# 6. The way Matlab threads work requires Matlab to not share nodes with other
# jobs.
#$ -ac exclusive

# 7. Set the name of the job.
#$ -N Matlab_job1

# 9. Set the working directory to somewhere in your scratch space.  This is
# a necessary step with the upgraded software stack as compute nodes cannot
# write to $HOME.
# Replace "<your_UCL_id>" with your UCL user ID :)
#$ -wd /home/<your_UCL_id>/Scratch/Matlab_output

# 10. Your work *must* be done in $TMPDIR 
cd $TMPDIR

# 11. Copy main Matlab input file and any additional files to TMPDIR

cp $infile .
Matlab_infile=`basename $infile`
for file in `echo $addinfiles | tr ':' ' '` 
do
  cp $file .
done

# 12. Run Matlab job

module load matlab/full/r2015b/8.6
module list
echo ""
echo "Running matlab -nosplash -nodisplay < $Matlab_infile ..."
echo ""
matlab -nosplash -nodesktop -nodisplay < $Matlab_infile

# 13. Preferably, tar-up (archive) all output files onto the shared scratch area
tar zcvf $HOME/Scratch/Matlab_examples/files_from_job_${JOB_ID}.tgz $TMPDIR

# Make sure you have given enough time for the copy to complete!