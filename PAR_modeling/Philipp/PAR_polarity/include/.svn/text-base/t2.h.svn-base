#include <limits>	// used for numeric_limits<double>::max()

#define MAX(a,b) ((a)<(b)?(b):(a))
#define MIN(a,b) ((a)>(b)?(b):(a))

class t2{

 private:

  int a,b;
  double** vpp;

  double max,min;
  
  void init(const int i,const int j){
   a=i;b=j;
   vpp = new double*[a];
   for(int k=0;k<a;k++){
    vpp[k]=new double[b];
    for(int l=0;l<b;l++){
     vpp[k][l]=0.;
    }
   }
   max=-get_max_double();
   min=get_max_double();
  }
  
  double get_max_double()
  {
  	return std::numeric_limits<double>::max();
  }
  
 public:

  t2(){
   init(1,1);
  }

  t2(int i, int j){
   init(i,j);
  }

  t2(t2& t){
   if(vpp)delete vpp;
   init(t.d1(),t.d2());
   for(int ii=0;ii<a;ii++){
    for(int jj=0;jj<b;jj++){
     vpp[ii][jj]=t(ii,jj);
    }
   }
  }

  ~t2(){ delete vpp;}

  int d1() const {return a;}
  int d2() const {return b;}
 
  double& operator() (int i, int j) {return vpp[i][j];}

  double* line(int i){return vpp[i];}

//  Ppm& pixmap(colorscale& cs){
//  int ii,jj;
//   for(ii=0;ii<a;ii++){
//    for(jj=0;jj<b;jj++){
//     max = MAX(max,vpp[ii][jj]);
//     min = MIN(min,vpp[ii][jj]);
//    }
//   }
//   Ppm* pm = new Ppm(a,b);
//   for(ii=0;ii<a;ii++){
//    for(jj=0;jj<b;jj++){
//     pm->draw_pixel(ii,jj,cs.get(256.*(vpp[ii][jj]-min)/(max-min)));
//    }
//   }
//   return *pm;
//  }

//  Ppm& pixmap(colorscale& cs, int nn){
//  int ii,jj;
//   for(ii=nn;ii<a-nn;ii++){
//    for(jj=nn;jj<b-nn;jj++){
//     max = MAX(max,vpp[ii][jj]);
//     min = MIN(min,vpp[ii][jj]);
//    }
//   }
//   Ppm* pm = new Ppm(a-2*nn+2,b-2*nn+2);

//   for(ii=0;ii<a-2*nn+2;ii++){
//    pm->draw_pixel(ii,0,wwhite);
//    pm->draw_pixel(ii,b-2*nn+1,wwhite);
//   }
//   for(jj=0;jj<b-2*nn+2;jj++){
//    pm->draw_pixel(0,jj,wwhite);
//    pm->draw_pixel(a-2*nn+1,jj,wwhite);
//   }
   
//   for(ii=nn;ii<a-nn;ii++){
//    for(jj=nn;jj<b-nn;jj++){
//     pm->draw_pixel(ii-nn+1,jj-nn+1,cs.get(256.*(vpp[ii][jj]-min)/(max-min)));
//    }
//   }
//   return *pm;
//  }

//  Ppm& pixmap(colorscale& cs, double mmin, double mmax, int nn){
//   int ii,jj;
//   Ppm* pm = new Ppm(a-2*nn+2,b-2*nn+2);
//   for(ii=0;ii<a-2*nn+2;ii++){
//    pm->draw_pixel(ii,0,wwhite);
//    pm->draw_pixel(ii,b-2*nn+1,wwhite);
//   }
//   for(jj=0;jj<b-2*nn+2;jj++){
//    pm->draw_pixel(0,jj,wwhite);
//    pm->draw_pixel(a-2*nn+1,jj,wwhite);
//   }
//   for(ii=nn;ii<a-nn;ii++){
//    for(jj=nn;jj<b-nn;jj++){
//     pm->draw_pixel(ii-nn+1,jj-nn+1,
//            cs.get(256.*(vpp[ii][jj]-mmin)/(mmax-mmin)));
//    }
//   }
//   return *pm;
//  }

//  Ppm& pixmap(colorscale& cs, double mmin, double mmax){
//   int ii,jj;
//   Ppm* pm = new Ppm(a,b);
//   for(ii=0;ii<a;ii++){
//    for(jj=0;jj<b;jj++){
//     pm->draw_pixel(ii,jj,cs.get(256.*(vpp[ii][jj]-mmin)/(mmax-mmin)));
//    }
//   }
//   return *pm;
//  }

  double getmin(){
   int ii,jj;
   for(ii=0;ii<a;ii++){
    for(jj=0;jj<b;jj++){
     min = MIN(min,vpp[ii][jj]);
    }
   }
   return min;
  }

  double getmax(){
   int ii,jj;
   for(ii=0;ii<a;ii++){
    for(jj=0;jj<b;jj++){
     max = MAX(max,vpp[ii][jj]);
    }
   }
   return max;
  }

};



