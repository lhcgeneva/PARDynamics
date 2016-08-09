using namespace std;

template <class T> class pdeint{

 int n;			// dimension of the pde
 int nn;		// number of neighbours to use for the estimation of 
			// the spatial derivative

 t2 f;			// where the derivatives go: dt*(r+d/dx2)	
 t2 x0;
 t2 xx;			// helping arrays for rk4

 double dt;		// timestep for one integration step
 double dx;		// the spatial step
 double dx2;		// square of the spatial step
 int l;			// number of points to calculate the system	
			// (l*dx = physical length)
public:

 T pde;			// the pde-template. it must have at least the
			// member functions: 
                        //  void T::derivs(t2&,t2&,int)
			//                           the lhs-of the pde
			//                           times dt
			//  void T::setdt(double)
			//			     for the timestep
			//  void T::setdx(double)
			//			     for the spatial
			//			     discretisation
			//  int T::getn() 
			// 			     the number of
			// 			     components of the
			// 			     pde
			//  int T::getnn()
			//                           the number of
			//                           neighbours being
			//                           used for estimation
			//                           of the spatial
			//                           derivative

 t2 x;		        // array for the values, elements can be
			// accessed with x(i,j) where i is the component
			// of the ode and j is the i-th point
			// indices i start from 0 and go to n-1
			// indices j start from nn and go to l+nn-1

 pdeint(){
  l = 128;
  setdx(0.1);
  setdt(0.002);
  allocate();
 }			// default constructor, l=128, dx=0.1, dt=0.002

 pdeint(int ll){
  l = ll;
  setdx(0.1);
  setdt(0.002);
  allocate();
 }			// constructor variable length, dx=0.1, dt=0.002

 pdeint(int ll, double dx, double dt){
  l = ll;
  setdx(dx);
  setdt(dt);
  allocate();
 }			// constructor variable length, dx and dt

private:

 void allocate(){
  n  = pde.getn();
  nn = pde.getnn();
  x = *(new t2(n,l+2*nn));
  x0= *(new t2(n,l+2*nn));
  xx= *(new t2(n,l+2*nn));
  f = *(new t2(n,l+2*nn));
 }
			// allocate the arrays, only used internally

public:

 int getl(){return l;}
 int getn(){return n;}
 int getnn(){return nn;}
			// get information about the system

 void setdt(double t){ dt=t;pde.setdt(t);}
 void setdx(double x){ dx = x; dx2 = x*x; pde.setdx(x);}

			// change the spatial and temporal
			// discretisation afterwards
private:

			// the following calculating functions are
			// private, because they will only be used
			// inside the intigerating routines

 void eval(t2& x, t2& f){
  for(int i=nn;i<nn+l;i++){ 
   pde.derivs(x,f,i);
  }
 }			// fills f with dt times the derivatives of the
			// pde at point x

 void up(t2& x, t2& f){
  int i,j;
  for(j=nn;j<nn+l;j++){
   for(i=0;i<n;i++){
    x(i,j) = x(i,j) + f(i,j);
   }
  }
 }			// x += f

 void up(t2& x, t2& y, t2& f){
  int i,j;
  for(j=nn;j<nn+l;j++){
   for(i=0;i<n;i++){
    x(i,j) = y(i,j) + f(i,j);
   }
  }
 }			// x = y + f 

 void up(t2& x, t2& f, double fact){
  int i,j;
  for(j=nn;j<nn+l;j++){
   for(i=0;i<n;i++){
    x(i,j) = x(i,j) + fact*f(i,j);
   }
  }
 }			// x += fact*f

 void up(t2& x, t2& y, t2& f, double fact){
  int i,j;
  for(j=nn;j<nn+l;j++){
   for(i=0;i<n;i++){
    x(i,j) = y(i,j) + fact*f(i,j);
   }
  }
 }			// x = y + fact*f
 
 void copy(t2& x, t2& y){
  int i,j;
  for(j=nn;j<nn+l;j++){
   for(i=0;i<n;i++){
    x(i,j) = y(i,j);
   }
  }
 }			// x = y
 
 void integrate_euler(){
  eval(x,f);
  up(x,f);
 }			// integrate euler, without bc's

public:
			// the three different boundary conditions with
			// runge kutta of 4th order
  
 void integrate_rk4_cyclic(){
  copy(x0,x);
  eval(x,f);
  up(xx,x0,f,1./6.);
  up(x,x0,f,1./2.);
  cyclic_bc();
  eval(x,f);
  up(xx,f,1./3.);
  up(x,x0,f,1./2.);
  cyclic_bc();
  eval(x,f);
  up(xx,f,1./3.);
  up(x,x0,f);
  cyclic_bc();
  eval(x,f);
  up(xx,f,1./6.);
  copy(x,xx);
  cyclic_bc();
 }

 void integrate_rk4_zero_flux(){
  copy(x0,x);
  eval(x,f);
  up(xx,x0,f,1./6.);
  up(x,x0,f,1./2.);
  zero_flux_bc();
  eval(x,f);
  up(xx,f,1./3.);
  up(x,x0,f,1./2.);
  zero_flux_bc();
  eval(x,f);
  up(xx,f,1./3.);
  up(x,x0,f);
  zero_flux_bc();
  eval(x,f);
  up(xx,f,1./6.);
  copy(x,xx);
  zero_flux_bc();
 }

 void integrate_rk4_bogdan(){
  copy(x0,x);
  eval(x,f);
  up(xx,x0,f,1./6.);
  up(x,x0,f,1./2.);
  bogdan_bc();
  eval(x,f);
  up(xx,f,1./3.);
  up(x,x0,f,1./2.);
  bogdan_bc();
  eval(x,f);
  up(xx,f,1./3.);
  up(x,x0,f);
  bogdan_bc();
  eval(x,f);
  up(xx,f,1./6.);
  copy(x,xx);
  bogdan_bc();
 }
				// the different boundary conditions

 void cyclic_bc(){
  static int i;
  static int j;
  for(i=0;i<n;i++){
   for(j=0;j<nn;j++){
    x(i,j)= x(i,l+j);
    x(i,l+nn+j)=x(i,nn+j);
   }
  }
 }				// cyclic

 void zero_flux_bc(){
  static int i;
  static int j;
  for(i=0;i<n;i++){
   for(j=0;j<nn;j++){
    x(i,nn-j-1)=x(i,nn+j);
    x(i,l+nn+j)=x(i,l+nn-1-j);
   }
  }
 }				// zero flux

 void bogdan_bc(){
  static int i;
  static int j;
  for(i=0;i<n;i++){
   for(j=0;j<nn;j++){
    x(i,nn-j-1)=x(i,nn+j);
    x(i,l+nn+j)=x(i,l+nn-2-j);	// like zero flux, but with "central
				// particle"
   }
  }
 }
 
 void integrate_euler_cyclic(){
  integrate_euler();
  cyclic_bc();
 }
			// integrate using euler and cyclic boundary
			// conditions for one timestep

 void integrate_euler_zero_flux(){
  integrate_euler();
  zero_flux_bc();
 }			// integrate using euler and zero flux boundary
			// conditions for one time step

// void integrate_euler_bogdan(){
//  integrate_euler();
//  zero_flux_bogdan();
// }
			// integrate using euler and bogdans special
			// zero flux with central particle
			// for one timestep

 ostream& profile(ostream& os){
  int i,j;
  os.precision(8);
  for(j=nn;j<l+nn;j++){
   os <<(j-nn)*dx;
   for(i=0;i<n;i++){
    os << " " << x(i,j);
   }
   os << endl;
  }
  return os;
 }

 ostream& out(ostream& os){
  int i,j;
  os.setf(ios::scientific,ios::floatfield);
  os.precision(16);
  for(i=0;i<n;i++){
   for(j=0;j<l+2*nn;j++){
    os << x(i,j) << " ";
    if(!((j+1)%3)){
     os << endl;
    }
   }
   os << endl;
  }
  os.precision(6);
//  os.setf(0,ios::floatfield);
  os.setf(ios::fmtflags(0),ios::floatfield);
  return os;
 }

 istream& in(istream& is){
  int i,j;
  for(i=0;i<n;i++){
   for(j=0;j<l+2*nn;j++){
    is >> x(i,j);
   }
  } 
  return is;
 }

 friend ostream& operator<< (ostream& os, pdeint& sys){
  return sys.out(os);
 }

 friend istream& operator>> (istream& os, pdeint& sys){
  return sys.in(os);
 }
  
};


