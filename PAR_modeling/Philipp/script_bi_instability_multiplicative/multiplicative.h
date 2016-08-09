#include <math.h>
#include "nr3.h"
#include <stdio.h>
#include <stdlib.h>

class par_polarity {

double 	konP, koffP;
double 	konA, koffA;

double 	kPA, psi;
double 	rhoP, rhoA;
	
double DP, DA;	
double L, k, n;	
	
double hss1_det1, hss1_det2, hss2_det1, hss2_det2;

public:
	int 	beta, alpha, poly_order;
	int	rr, rr_old, unstable, unstable_old;
	int	setup;
	
	double kAP, kAP_step, kAP_limit;

	void init(char**);
	void coeffs(VecComplex &);
	double real_roots(VecComplex &, double*, double*);
	void instability_2var (double* , double*);
	int factorial(int);
};


void par_polarity::init(char* argv[]) {
// Assign input parameters from command line

	alpha		= atoi(argv[1]);
	beta		= atoi(argv[2]);
	poly_order	= alpha * beta + 1;
	
	konP		= atof(argv[3]);
	koffP		= atof(argv[4]);

	konA		= atof(argv[5]);
	koffA		= atof(argv[6]);

	kPA		= atof(argv[7]);
	
	kAP		= atof(argv[8]);
	kAP_step	= atof(argv[9]);
	kAP_limit	= atof(argv[10]);
	
	rhoP		= atof(argv[11]);
	rhoA		= atof(argv[12]);
	
	DP		= atof(argv[13]);
	DA		= atof(argv[14]);	
	
	L		= atof(argv[15]);
	n		= atof(argv[16]);
	
// Surface to volume ratio
	psi		= atof(argv[17]);
	
// Position of the nth Fourier mode:	
	k		= n*2*3.141592653589793/L;
	
	rr_old		= 1;
	unstable_old	= 0;	

//	printf("system length = %f \n surface to volume = %f \n",L,psi);
}

void par_polarity::coeffs(VecComplex &a) {
// Compute coefficients of polynomial to be solved for the homogeneous steady state
if (beta == 0) {
	real(a[0])	= - konA * rhoA;
	real(a[1])	= psi*konA + koffA + kAP * pow(konP*rhoP/(psi*konP+koffP+kPA),alpha);

}
if (beta == 1) {

	real(a[0]) 	= - konA * rhoA * pow(psi*konP+koffP,alpha);
	real(a[1]) 	= ( (psi*konP+koffP) * (psi*konA+koffA) - konA * rhoA * alpha * kPA )  * pow(psi*konP+koffP,alpha-1) + kAP * pow(konP*rhoP,alpha) ;

	for (int gamma=2; gamma<=alpha; gamma++) {
		real(a[gamma]) 	= ( (psi*konP+koffP) * (psi*konA+koffA) * pow(kPA,gamma-1) * gamma / (alpha+1) * factorial(alpha+1) / (factorial(gamma) * factorial(alpha+1-gamma)) - konA * rhoA * factorial(alpha) / (factorial(gamma) * factorial(alpha-gamma)) * pow(kPA,gamma) ) * pow(psi*konP+koffP,alpha-gamma);
	}
	real(a[alpha+1]) = (psi*konA+koffA) * pow(kPA,alpha);
}
else	{
	real(a[0])	= - konA * rhoA * pow(psi*konP+koffP,alpha);
	real(a[1]) 	= (psi*konA+koffA) * pow(psi*konP+koffP,alpha) + kAP * pow(konP*rhoP,alpha);

	for (int gamma=1; gamma<=alpha; gamma++) {
		real(a[beta*gamma]) 	= - konA * rhoA * factorial(alpha) / (factorial(gamma) * factorial(alpha-gamma)) * pow(psi*konP+koffP,alpha-gamma) * pow(kPA,gamma);

		real(a[beta*gamma+1])	= (psi*konA+koffA) * factorial(alpha) / (factorial(gamma) * factorial(alpha-gamma)) * pow(psi*konP+koffP,alpha-gamma) * pow(kPA,gamma);
	}
}	

}


double par_polarity::real_roots(VecComplex &roots, double P[], double A[]) {
// identify the real roots and write to file
	rr	= 0;
	
	for (int j=0; j<=poly_order-1; j++ ) {
		if ( imag(roots[j])==0 ) {
			A[rr] 	= real(roots[j]);
			P[rr] 	= ( konP * rhoP ) / ( koffP + psi*konP + kPA * pow(A[rr],beta) );
			rr	= rr+1;
		}
	}
	
	FILE *steady_states;
	FILE *bistability;
	
	// --- compute steady-states, write bistability mode and steady-states to files ----------
	steady_states	= fopen ("steady_states","a+");
	bistability	= fopen ("bistability","a+");
	if ( rr==1 ) {	
		fprintf (steady_states,"%f \t %f \t %f \n",P[0]-A[0],0.,0.);
		fprintf (bistability,"%f \t %f \t %i \n",kPA,kAP,rr);
	}
	else {
		fprintf (bistability,"%f \t %f \t %i \n",kPA,kAP,rr);
		for (int j=0; j<rr; j++) {
			fprintf (steady_states,"%f \t",P[j]-A[j]);
		}	
		fprintf (steady_states,"\n");
	}
	fclose (bistability);
	fclose (steady_states);

	//bistability	= NULL;
}

void par_polarity::instability_2var (double P[], double A[]) {

FILE *ss10;
FILE *ss01;

ss10 = fopen ("ss10","a+");
ss01 = fopen ("ss01","a+");

if (rr == 1) {
	
	hss1_det1 = DP*DA*pow(k,4) + (DP*(koffA + kAP*pow(P[0],alpha)) + DA*(koffP + kPA*pow(A[0],beta)))*pow(k,2);
	hss1_det2 = (koffP + kPA*pow(A[0],beta))*(koffA + kAP*pow(P[0],alpha)) - beta*alpha*kPA*kAP*pow(P[0],alpha)*pow(A[0],beta);
	
	if ( hss1_det1 + hss1_det2 < 0 ) {
		fprintf (ss10,"%f \t %f \t %i \n",kPA,kAP,1);
		fprintf (ss01,"%f \t %f \t %i \n",kPA,kAP,1);

		unstable	= 1;
	}
	else {
		fprintf (ss10,"%f \t %f \t %i \n",kPA,kAP,0);
		fprintf (ss01,"%f \t %f \t %i \n",kPA,kAP,0);
		
		unstable	= 0;

	}
}
else {
	
	hss1_det1 = DP*DA*pow(k,4) + (DP*(koffA + kAP*pow(P[0],alpha)) + DA*(koffP + kPA*pow(A[0],beta)))*pow(k,2);
	hss1_det2 = (koffP + kPA*pow(A[0],beta))*(koffA + kAP*pow(P[0],alpha)) - beta*alpha*kPA*kAP*pow(P[0],alpha)*pow(A[0],beta);
	
	if ( hss1_det1 + hss1_det2 < 0 ) {
		fprintf (ss10,"%f \t %f \t %i \n",kPA,kAP,1);
		unstable	= 1;		
	}
	else { 
		fprintf (ss10,"%f \t %f \t %i \n",kPA,kAP,0);
		unstable	= 0;		
	}

	hss2_det1 = DP*DA*pow(k,4) + (DP*(koffA + kAP*pow(P[2],alpha)) + DA*(koffP + kPA*pow(A[2],beta)))*pow(k,2);
	hss2_det2 = (koffP + kPA*pow(A[2],beta))*(koffA + kAP*pow(P[2],alpha)) - beta*alpha*kPA*kAP*pow(P[2],alpha)*pow(A[2],beta);
	
	if ( hss2_det1 + hss2_det2 < 0 ) {
		fprintf (ss01,"%f \t %f \t %i \n",kPA,kAP,1);
		unstable	= 1;		
	}
	else { 
		fprintf (ss01,"%f \t %f \t %i \n",kPA,kAP,0);
		unstable	= 0;		
	}
}
fclose(ss10);
fclose(ss01);

/*	ss10		= NULL;
	ss01		= NULL; */
	
}


int par_polarity::factorial (int k) {

if (k == 0) {
	return 1;
}
else {
	int n;
	
	for(int j=1;j<=k;j++) {
		if(k == 1) { return 1; }
		else { n = k*factorial(k-1); }
	}
return n;
}
}




