// --------------------------------------------------------------------
//	PAR polarity model in 2 variables with multiplicative cross talk
// --------------------------------------------------------------------


const int DIM=2;		//Number of variables
const int NN=1;			//Number of extra sites needed for the derivatives


class rgleforced_1d
{

 private:

  double dx, dx2;
  double dt;
  double dtddx, dtddx2;
  double P, A;

 public:
  double rhoP,rhoA,DP,DA,konP,konA,koffP,koffA,kPA,kAP,alpha,beta,psi;
  int steps;
  double med_P, med_A;
  double a,b,m;
  int time1,time2;
  double* flowx;
  double* flowx_der;
  double* flowt;

void flow_init(int l, int total_steps) {
  flowx 	= new double [l];	// spatial and temporal arrays for the flow
  flowx_der	= new double [l];	// dynamically allocated
  flowt		= new double [total_steps];

  for (int j=0;j<l;j++) {
	flowx[j]	= a*(dx*j-60)*exp(-b*pow(dx*j-60,2));
	flowx_der[j] 	= a*exp(-b*pow(dx*j-60,2)) - 2*a*b*pow(dx*j-60,2)*exp(-b*pow(dx*j-60,2));
  }

  for (int j=0;j<total_steps;j++) {
	flowt[j] = (1/(exp(2*m*(j-time2))+1) - 1/(exp(2*m*(j-time1))+1));
  }
}

void flow_delete() {		// free memory and delete
	delete [] flowx;
	delete [] flowx_der;
	delete [] flowt;

	flowx = NULL;		// delete pointers
	flowx_der = NULL;
	flowt = NULL;
}


//  double mu,ome,eps;
  

// --------- Constructor ----------------------------------------------------------------------------
  rgleforced_1d()
  { 
    DP=DA=1,konP=konA=1,koffP=koffA=1,kPA=kAP=1;
    dx=0.1;dx2=0.01; dt=1; dtddx2=1;
    alpha=beta=2;
    steps=0;
    a=1;b=1;m=1;time1=1;time2=1;
	psi=1;
  }

	
// --------- Functions ------------------------------------------------------------------------------
  void derivs(t2& x, t2& f, int i)
  { 
	P=x(0,i);
	A=x(1,i);

	  if(a!=0){
		  f(0,i) =  dt*( konP*(rhoP-psi*med_P) -koffP*P -kPA*P * pow(A,beta) )
					+ dtddx2 * DP * ( x(0,i-1)+x(0,i+1)-2*x(0,i) )
					+ dtddx  * flowx[i] * flowt[steps]  * (x(0,i+1)-x(0,i-1))/2
					+ dt*( P* flowx_der[i] * flowt[steps] );
		  f(1,i) =  dt*( konA*(rhoA-psi*med_A) -koffA*A -kAP*A * pow(P,alpha ) )
					+ dtddx2 * DA * ( x(1,i-1)+x(1,i+1)-2*x(1,i) )
					+ dtddx  * flowx[i] * flowt[steps]  * (x(1,i+1)-x(1,i-1))/2
					+ dt*( A* flowx_der[i] * flowt[steps] );
	  }
	  else{
		  f(0,i) =  dt*( konP*(rhoP-psi*med_P) -koffP*P -kPA*P * pow(A,beta) )
					+ dtddx2 * DP * ( x(0,i-1)+x(0,i+1)-2*x(0,i) );
		  f(1,i) =  dt*( konA*(rhoA-psi*med_A) -koffA*A -kAP*A * pow(P,alpha ) )
					+ dtddx2 * DA * ( x(1,i-1)+x(1,i+1)-2*x(1,i) );
	  }
  }

  void setdx(double x){dx=x;dx2=x*x;}
  void setdt(double t){dt=t; dtddx=dt/dx; dtddx2=dt/dx2;}

  int    getn() {return DIM;}
  int    getnn(){return NN;}
  double getdx(){return dx;}
  double getdt(){return dt;}

};



