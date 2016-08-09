// --------------------------------------------------------------------------------
//		Bistability and linear instabilities in the two-variable PAR 
//		polarity model with multiplicative crosstalk
// --------------------------------------------------------------------------------

#include <math.h>
#include "nr3.h"
#include "laguerre.h"
#include "multiplicative.h"

using namespace std;

int main(int argc, char* argv[]) {

	//--------------------------------------------------------------------------	
	// Create object of type crosstalk and initialize
	//--------------------------------------------------------------------------	

	par_polarity system;
	
	system.init(argv);
	
	double P[system.poly_order];
	double A[system.poly_order];
	
	VecComplex_O roots( system.poly_order );
	VecComplex a( system.poly_order + 1 );
	
	//--------------------------------------------------------------------------	
	// Move along a cut of constant kPA in parameter space
	//--------------------------------------------------------------------------
	while (system.kAP < system.kAP_limit+system.kAP_step) {			
			
		//--------------------------------------------------------------------------		
		// compute coefficients for polynomial and call root solver
		//--------------------------------------------------------------------------
		system.coeffs(a);
		zroots(a,roots,true);

		//--------------------------------------------------------------------------		
		// identify the real roots, compute second steady-state concentration 
		// and write to file
		//--------------------------------------------------------------------------
		system.real_roots(roots,P,A);

		//--------------------------------------------------------------------------
		// Test the homogeneously stable steady-states for spatial instability and write to file
		//--------------------------------------------------------------------------
		system.instability_2var(P,A);

//		if ((system.unstable_old==1 && system.rr_old==1 && system.unstable==0 && system.rr==1) 
//			|| (system.unstable_old==1 && system.rr_old==3 && system.unstable==0 && system.rr==1)) {
//			break;
//		}
//		else {
//			system.rr_old			= system.rr;
//			system.unstable_old		= system.unstable;
//			system.kAP			= system.kAP + system.kAP_step;
//		}
		system.kAP				= system.kAP + system.kAP_step;
	}

			
	return 0;
}
