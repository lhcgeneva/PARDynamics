# PARDynamics
## Image Analysis
Package to quantify membrane protein levels along cell perimeter.
### Segmentation
Segmentation: class assembling tools to segment cells.
Algorithm works roughly as follows:

1.  Get midpoint (at the moment by user input, could easily be automated by thresholding out the rough outline of the cell and finding its center of mass).
2.  Get intensity on ray starting from the midpoint of the cell to the border of the image.
3.  Find maximum or steepest gradient on each of the rays (which should correspond to its intersection with the membrane).
4.  Optionally: manually check and correct.

### 3D Reconstruction
Z3D: class that reconstructs 3D shape of a cell from given Segmentations.
### Gradient analysis
Class specific to PhD project: quantify gradient of polarized proteins near cell midzone.
## Modeling
Collection of modeling approaches, importantly:
### PAR_Stochastic_Reaction_Diffusion
Contains our own stochastic model, implements PAR reaction diffusion network as a stochastic simulation, based on propensity functions derived from the PDEs describing the system's evolution in time and space.

  - Uses Gillespie algorithm
  - For now reflecting boundary conditions, periodic on the way
  - Need to implement surface to volume conversion factor
  - Need to use the right particle counts
  
### Mathematica_deterministic
Contains some of the early Mathematica simulations of the system.

### Philipp
Part of Philipps parameter sweep.

