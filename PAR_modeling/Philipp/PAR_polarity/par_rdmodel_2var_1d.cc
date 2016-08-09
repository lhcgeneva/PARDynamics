#include <iostream>	//standard input and output library (includes cin, cout and cerr)
#include <fstream>	//These classes are used to manipulate files with streams 
			//	(includes fstream, ofstream, ifstream)
#include <cstdlib>	//contains rand() abd srand()
#include <math.h>
#include <time.h> 	//contains time_t, tm, time(), localtime(), asctime()
#include <t1.h>
#include <t2.h>
#include <t3.h>
#include <pdeint.h>
#include <pgm-inverse.h>
#include "par_rdmodel_2var_1d.h"
using namespace std;

const double PI=3.14159265358979;

//Function prototypes (Global)
string get_current_time(); //This function returns the current time as a string

// ---------------------------------------------------------------------------
//		BEGIN MAIN 
// ---------------------------------------------------------------------------
int main(int argc, char* argv[])
{

  int n, nn;
  double sum_P=0,sum_A=0;

//-- Define input parameters -------------------------------------------------

// integration parameters:
  int l			= atoi(argv[1]);
  double dx 		= atof(argv[2]);
  double dt 		= atof(argv[3]);

  int innerloop 	= atoi(argv[4]);
  int middleloop 	= atoi(argv[5]);
  int outerloop 	= atoi(argv[6]);

// reaction and diffusion parameters:
  int alpha		= atoi(argv[7]);
  int beta		= atoi(argv[8]);

  double konP		= atof(argv[9]);
  double konA		= atof(argv[10]);

  double koffP		= atof(argv[11]);
  double koffA		= atof(argv[12]);

  double DP		= atof(argv[13]);
  double DA		= atof(argv[14]);

  double rhoP		= atof(argv[15]);
  double rhoA		= atof(argv[16]);

  double kPA		= atof(argv[17]);
  double kAP		= atof(argv[18]);
	
  double psi		= atof(argv[19]);

// output image parameters:
// 'c' creates Kymograph, 'n' suppresses this	
  char imagdef		= *argv[20];
  int pix		= atoi(argv[21]);
  double umin		= atof(argv[22]);
  double umax		= atof(argv[23]);

// flow parameters:
  double a		= atof(argv[24]);
  double b		= atof(argv[25]);
  double m		= atof(argv[26]);
  int time1		= atoi(argv[27]);
  int time2		= atoi(argv[28]);

// initial condition parameters:
// in function initcond !


//-- Function prototypes (they can be used only inside main{}) -------
//  int  initcond(t2& x,int l, int nn,double dx);		 //Initial condition prototype
  double root_a(double,double);                                //gives the u0 as a function of phi
  void  initcond(pdeint<rgleforced_1d>& system, char* argv[]);		 //Initial condition prototype
  void draw_pgm_line(pdeint<rgleforced_1d>& system, int i_out, pgm_image& image_x0, pgm_image& image_x1, int pix, double umax, double umin);
  void write_glob_extr(pdeint<rgleforced_1d>& system, ofstream& global_average, ofstream& extrema_x0);
  void write_profil_wavenumber(pdeint<rgleforced_1d>& system, ofstream& fs_per);//Profil with wavenumber prototype
	void write_profile_normalized(pdeint<rgleforced_1d>& system, ofstream& final_profile_normalized);
//  void write_profil_polar(pdeint<rgleforced_1d>& system, ofstream& fs_per);//Profil in polar coordinates prototype


//-- Create object system of type pdeint using constructor rglforced_1d	----
  pdeint<rgleforced_1d> system(l,dx,dt);

  n = system.pde.getn();
  nn= system.pde.getnn();

  system.setdx(dx);
  system.setdt(dt);

  system.pde.DP    = DP;
  system.pde.DA    = DA;
  system.pde.konP  = konP;
  system.pde.konA  = konA;
  system.pde.koffP = koffP;
  system.pde.koffA = koffA;
  system.pde.alpha = alpha;
  system.pde.beta  = beta;
  system.pde.rhoP  = rhoP;
  system.pde.rhoA  = rhoA;
  system.pde.kPA   = kPA;
  system.pde.kAP   = kAP;
  system.pde.psi   = psi;
	
  system.pde.a     = a;
  system.pde.b	   = b;
  system.pde.m     = m;
  system.pde.time1 = time1;
  system.pde.time2 = time2;

//-- Check for non-zero magnitude of flow -----------------------------------
  if(a!=0){
	// compute spatial and temporal flow arrays for efficiency,
	// needs to free dynamically allocated memory later
	system.pde.flow_init(l, innerloop*outerloop*middleloop);
}

//-- Chose initial condition: -----------------------------------------------
	initcond(system, argv);
	
	
//-- Chose boundary condition: ----------------------------------------------
	system.cyclic_bc();
	//  system.zero_flux_bc();
	
	
//-- Initilization of output files: -----------------------------------------
	ofstream global_average("global-mean");
	global_average << "# " << get_current_time();
	
	ofstream extrema_x0("extrema_1d");
	extrema_x0 << "# " << get_current_time();
	
	ofstream final_profile_normalized("final_profile_normalized");
	final_profile_normalized << "# " << get_current_time();
	
	fstream p;
//	ofstream p("final-profil");
	
	ofstream os5("final-state");
	//  fstream os5; os5.open("final-state",ios::out);
	//  os5 << system;
	

//-- Output information about the simulation: -------------------------------
	cout<< get_current_time();
	printf("total steps: %i \n",innerloop*middleloop*outerloop);
	printf("total time: %f \n",dt*innerloop*middleloop*outerloop);
	
	
	switch(imagdef)
	{
		case 'n':
//		Integration loops WITHOUT Kymograph output
			
			for(int i_out=0;i_out<outerloop;i_out++) {

				for(int i_mid=0;i_mid<middleloop;i_mid++) {

					for(int i_inn=0;i_inn<innerloop;i_inn++) {
						
						sum_P=0,sum_A=0;
						for(int k = nn; k<l+nn ; k++){
							sum_P += system.x(0,k);
							sum_A += system.x(1,k);
						}
						system.pde.med_P=sum_P/l;
						system.pde.med_A=sum_A/l;
						system.integrate_rk4_cyclic();
//						system.integrate_euler_cyclic();
//						system.integrate_euler_zero_flux();
						system.pde.steps++;
					}
//				write_glob_extr(system,global_average, extrema_x0);
					
				}
				write_glob_extr(system,global_average, extrema_x0);
			}
			
			break;
		  
		case 'c':
//		Integration loops WITH Kymograph output	
//		custom image definition: values for pix, umin, umax have already been set above
			pgm_image image_x0("img_x0.pgm",l/pix,outerloop);
			image_x0.draw_image();
			pgm_image image_x1("img_x1.pgm",l/pix,outerloop);
			image_x1.draw_image();
			
			for(int i_out=0;i_out<outerloop;i_out++) {

				for(int i_mid=0;i_mid<middleloop;i_mid++) {

					for(int i_inn=0;i_inn<innerloop;i_inn++) {
						
						sum_P=0,sum_A=0;
						for(int k = nn; k<l+nn ; k++){
							sum_P += system.x(0,k);
							sum_A += system.x(1,k);
						}
						system.pde.med_P=sum_P/l;
						system.pde.med_A=sum_A/l;
						system.integrate_rk4_cyclic();
//						system.integrate_euler_cyclic();
//						system.integrate_euler_zero_flux();
						system.pde.steps++;
					}
//					write_glob_extr(system,global_average, extrema_x0);
					
				}
				write_glob_extr(system,global_average, extrema_x0);
				draw_pgm_line(system,i_out,image_x0,image_x1,pix,umax,umin);
			}
			
			image_x0.draw_image();
			image_x0.erase_raw_image();
			image_x1.draw_image();
			image_x1.erase_raw_image();
			
			break;
	}

  
//-- Output final profiles and states ---------------------------------------
	p.open("final-profile", ios::out);
	system.profile(p);

	write_profile_normalized(system, final_profile_normalized);
  
	system.out(os5);  
	cout << endl; 
 
//-- Free dynamically allocated memory of the flow if necessary -------------	
// 	system.pde.flow_delete();

	
	return 0;
}
// ---------------------------------------------------------------------------
//		END MAIN
// ---------------------------------------------------------------------------


double root_a(double gamma,double nu)
{
 double func(double,double,double);            //Prototype: this calculates the root of u
 double prec=0.000000001;
 double val1,val2,val3;
 double vz1,vz2,vz3;
 vz1=0.00;
 vz2=2.00;
 val1 = func(gamma,nu,vz1);
 val2 = func(gamma,nu,vz2);
 while(fabs(val1-val2)>prec){
  vz3 = (vz1+vz2)/2.;
  val3 = func(gamma,nu,vz3);
  if((val1*val3)<=0){
   vz2=vz3;
   val2 = val3;
  }
  else {
   vz1=vz3;
   val1=val3;
  }
 }
 return vz3;
}

double func(double gamma,double nu, double R)
{
  return (R*R-1)*(R*R-1)*R*R+nu*nu*R*R-gamma*gamma;
}

void initcond(pdeint<rgleforced_1d>& system, char* argv[])  // Initial Condition
{
  srand(time(0));   // to set up the seed of the random numer generator rand()
  double noise_0,noise_1,noise_2,noise_3;
  
  int l			= system.getl();
  int nn		= system.getnn();
  double dx		= system.pde.getdx();
  char initialcond	= *argv[29];

  if(initialcond == 'p'){ 
	printf("SELECTED IC: stripes initial condition \n");
        double offset,ampli,kinit,attenp;
        cout << "offset,amplitude, kinit, attenuation (>=0 & <=1)?" << endl;
        cin >> offset >> ampli >> kinit >> attenp;
        for(int i=nn;i<l+nn;i++){
       	        noise_0=double(rand())/RAND_MAX;	//gives a random number between 0 & 1 (both inclusive)
//     	        noise=static_cast<double>(rand())/RAND_MAX;
 	        system.x(0,i)=offset+ampli*(sin(dx*kinit*(i-nn))+attenp*(noise_0-0.5));
  	}
  } else
  if(initialcond == 'f') {
	printf("SELECTED IC: initial-system initial condition \n");
        ifstream initstate("initial-state");
        initstate >> system;
	double steps_init = atof(argv[30]);
	  
  } else
  if(initialcond == 'r'){
	printf("SELECTED IC: random initial conditions");
        double P	= atof(argv[30]);
	double A	= atof(argv[31]);
	double atten	= atof(argv[32]);
	  
         for(int i=nn;i<l+nn;i++){
       	        noise_0=double(rand())/RAND_MAX;
 	        system.x(0,i)=P+atten*(noise_0-0.5);
       	        noise_0=double(rand())/RAND_MAX;
 	        system.x(1,i)=A+atten*(noise_0-0.5);
         }
  } else
  if(initialcond == 't'){
	printf("SELECTED IC: front initial conditions");
        double atten;
        cout << "amplitude of the initial front?" << endl;
        cin >> atten; 
        for(int i=0;i<atten+nn;i++){
//         for(int i=0;i<l/2+nn;i++){
 	        system.x(0,i)=-0.09075;
// 	        system.x(1,i)=0.98171;
         }
         for(int i=int(atten)+nn;i<l+nn;i++){
//         for(int i=l/2+nn;i<l+nn;i++){
 	        system.x(0,i)=-0.22198;
// 	        system.x(1,i)=0.93754-((i-atten-nn)*0.001);
         }
  } else
  if(initialcond == 'u'){
	printf("SELECTED IC: pulse initial conditions");
	int pulse_start	= atoi(argv[30]);
	int pulse_end 		= atoi(argv[31]);
        double P1	= atof(argv[32]);
        double P2	= atof(argv[33]);
        double A1	= atof(argv[34]);
        double A2	= atof(argv[35]);

        for(int i=nn;i<pulse_start+nn;i++) {
 	        system.x(0,i)=P2;
 	        system.x(1,i)=A2;
        }
        for(int i=pulse_start+nn;i<pulse_end+nn;i++) {
 	        system.x(0,i)=P1;
 	        system.x(1,i)=A1;
        }
        for(int i=pulse_end+nn;i<l+nn;i++) {
 	        system.x(0,i)=P2;
 	        system.x(1,i)=A2;
        }
  } else
  if(initialcond == 'o'){
	printf("SELECTED IC: front initial conditions");
	int front_start=l/4, front_end=l/2;
        double differ;
      	double noise;
	double amp_noise=0.01;
        for(int i=nn;i<front_start+nn;i++) {
                noise=double(rand())/RAND_MAX;
 	        system.x(0,i)=-1+amp_noise*(noise-0.5);
//                noise=double(rand())/RAND_MAX;
// 	        system.x(1,i)=0+amp_noise*(noise-0.5);
         }
         for(int i=front_start+nn;i<front_end+nn;i++) {
                noise=double(rand())/RAND_MAX;
 	        system.x(0,i)=1+amp_noise*(noise-0.5);
//                noise=double(rand())/RAND_MAX;
// 	        system.x(1,i)=0+amp_noise*(noise-0.5);
         }
         for(int i=front_end+nn;i<l+nn;i++) {
                system.x(0,i)=-system.x(0,(i-front_end-nn+1));
// 	        system.x(1,i)=-system.x(1,(i-front_end-nn+1));
         }
  } else
  if(initialcond == 'l'){
	printf("SELECTED IC: L front initial conditions");
	int front_start=l/2;
        double differ;
       	double noise;
	double amp_noise=0.001;
//	double amp_noise=0.01;
        for(int i=nn;i<front_start+nn;i++) {
                noise=double(rand())/RAND_MAX;
 	        system.x(0,i)=1.0261+amp_noise*(noise-0.5);
        }
// 	system.x(0,front_start+nn)=0;
// 	system.x(1,front_start+nn)=0;
 	system.x(0,front_start+nn)=0.26767;
// 	system.x(1,front_start+nn)=0.88243;
        for(int i=front_start+1+nn;i<l+nn;i++) {
                noise=double(rand())/RAND_MAX;
                system.x(0,i)=-1.0261+amp_noise*(noise-0.5);
        }
  }
  fstream init_profil; init_profil.open("initial-profil-used", ios::out);
  init_profil << "# " << get_current_time();
  system.profile(init_profil);
  fstream initstate_used; 
  initstate_used.open("initial-state-used", ios::out);
  initstate_used << system;
  return;
}
//------------------------------------------------------------------------------

void draw_pgm_line(pdeint<rgleforced_1d>& system, int i_out, pgm_image& image_x0, pgm_image& image_x1, int pix, double umax, double umin)
{
  int l=system.getl();
  int nn=system.getnn();
  double dx=system.pde.getdx();
  double dt=system.pde.getdt();
  for(int k_draw=0;k_draw<l/pix;k_draw++)
  {
      image_x0.set_pixel (k_draw  ,i_out,(system.x(0,k_draw*pix+nn)-umin)/(umax-umin));
      image_x1.set_pixel (k_draw  ,i_out,(system.x(1,k_draw*pix+nn)-umin)/(umax-umin));
  }
  image_x0.draw_image();
  image_x1.draw_image();

  return;
}
//------------------------------------------------------------------------------

void write_glob_extr(pdeint<rgleforced_1d>& system, ofstream& global_average, ofstream& extrema_x0)
{                                                                              
  const double BIG=999999;
  int l=system.getl();
  int nn=system.getnn();
  double dx=system.pde.getdx();
  double dt=system.pde.getdt();
  
  double x0_global_sum=0;     			// Reset values of global_sum 
  double x0_max = -BIG; 			// max of x(0) field	
  double x0_min =  BIG;				// and    min of x(0) field
  double x1_global_sum=0;     			// Reset values of global_sum 
  double x1_max = -BIG; 			// max of x(0) field	
  double x1_min =  BIG;				// and    min of x(0) field
  for(int k_extrema=nn;k_extrema<nn+l;k_extrema++)
  {
      x0_global_sum = x0_global_sum  + system.x(0,k_extrema);
      x0_max = MAX(x0_max,system.x(0,k_extrema));
      x0_min = MIN(x0_min,system.x(0,k_extrema));
      x1_global_sum = x1_global_sum  + system.x(1,k_extrema);
      x1_max = MAX(x1_max,system.x(1,k_extrema));
      x1_min = MIN(x1_min,system.x(1,k_extrema));
  }
  global_average << dt * system.pde.steps << "	" << x0_global_sum/l  
					  << "	" << x1_global_sum/l  << endl;
  extrema_x0     << dt * system.pde.steps << "	" << x0_max << "	" << x0_min 
					  << "	" << x1_max << "	" << x1_min << endl;

  return;
}


//------------------------------------------------------------------------------

void write_profile_normalized(pdeint<rgleforced_1d>& system, ofstream& final_profile_normalized)
{                                                                              
	const double BIG=999999;
	int l=system.getl();
	int nn=system.getnn();
	double dx=system.pde.getdx();
	double dt=system.pde.getdt();
	
	double x0_global_sum=0;     		// Reset values of global_sum 
	double x0_max = -BIG;				// max of x(0) field	

	double x1_global_sum=0;     		// Reset values of global_sum 
	double x1_max = -BIG;				// max of x(0) field	

	for(int k=nn;k<nn+l;k++)
	{
		x0_max = MAX(x0_max,system.x(0,k));

		x1_max = MAX(x1_max,system.x(1,k));
	}
//	printf("x0_max = %f, x1_max = %f \n",x0_max,x1_max);
	for(int k=nn;k<nn+l;k++) {
		final_profile_normalized <<(k-nn)*dx;
		final_profile_normalized << " " << system.x(0,k)/x0_max << " " << system.x(1,k)/x1_max;
		final_profile_normalized << endl;
	}
	return;
}

//------------------------------------------------------------------------------

void write_profil_wavenumber(pdeint<rgleforced_1d>& system, ofstream& fs_per)
{
  int l=system.getl();
  int nn=system.getnn();
  double dx=system.pde.getdx();
  
  double crossing_neg_previous=0;
  double crossing_neg_present=0;   
  double threshold=0.000000001;
  
  fs_per << "# " << get_current_time() <<endl;
  fs_per << "# x_crossing_neg_begin	wavenumber(2*PI/distance)	x_crossing_neg_end	period(distance)" << endl;
  for(int k_zero=nn;k_zero<nn+l;k_zero++)
  {
      if(system.x(0,k_zero)>0 && system.x(0,k_zero+1)<0 
                              &&  system.x(0,k_zero)-system.x(0,k_zero+1)>threshold*dx)
      {
        crossing_neg_present=dx*((k_zero-nn)+( system.x(0,k_zero)/( system.x(0,k_zero)-system.x(0,k_zero+1))));
   	if(crossing_neg_previous>0)
	{
		fs_per << crossing_neg_previous << "		"
		       << 2*PI/(crossing_neg_present-crossing_neg_previous) << "		" 
		       << crossing_neg_present-crossing_neg_previous << "		" 
		       << crossing_neg_present << endl;
	}
	crossing_neg_previous=crossing_neg_present;
      }
   }
   return;
}


string get_current_time()
{
  time_t rawtime;
  struct tm * timeinfo;
  time(&rawtime);
  timeinfo=localtime(&rawtime);
  return asctime(timeinfo);
}
//------------------------------------------------------------------------------
