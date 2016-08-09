#include <limits>	// used for numeric_limits<double>::max()

#define MAX(a,b) ((a)<(b)?(b):(a))
#define MIN(a,b) ((a)>(b)?(b):(a))

class t3{

 private:

  int a,b,c;
  double*** vppp;

  double max,min;
  
  void init(const int i,const int j,const int k){
   a=i;b=j;c=k;
   vppp = new double**[a];
   for(int l=0;l<a;l++){
     vppp[l]=new double*[b];
     for(int m=0;m<b;m++){
       vppp[l][m]=new double[c];
          for(int n=0;n<c;n++){
             vppp[l][m][n]=0.;
          }
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

  t3(){
   init(1,1,1);
  }
  
  t3(int i, int j, int k){
   init(i,j,k);
  }

//  t3(int i, int j, int k){
//   int l,m;
//   a=i;b=j;c=k;
//   vppp = new double**[a];
//   for(l=0;l<a;l++){
//    vppp[l]=new double*[b];
//    for(m=0;m<b;m++){
//     vppp[l][m]=new double[c];
//    }
//   }
//   max = -HUGE;
//   min = HUGE;
//  }

  t3(t3& t){
   if(vppp)delete vppp;
   init(t.d1(),t.d2(),t.d3());
   for(int ii=0;ii<a;ii++){
    for(int jj=0;jj<b;jj++){
     for(int kk=0;kk<c;kk++){
       vppp[ii][jj][kk]=t(ii,jj,kk);
     }
    }
   }
  }

  ~t3(){ delete vppp;}

  int d1() const {return a;}
  int d2() const {return b;}
  int d3() const {return c;}

  double& operator() (int i, int j, int k){ return vppp[i][j][k];}

//  Ppm& pixmap(colorscale& cs, int kk){
//   int ii,jj;
//   max = -HUGE;
//   min = HUGE;
//   for(ii=0;ii<b;ii++){
//    for(jj=0;jj<c;jj++){
//     max = MAX(max,vppp[kk][ii][jj]);
//     min = MIN(min,vppp[kk][ii][jj]);
//    }
//   }
//   Ppm* pm = new Ppm(b,c);
//   for(ii=0;ii<a;ii++){
//    for(jj=0;jj<b;jj++){
//     pm->draw_pixel(ii,jj,cs.get(256.*(vppp[kk][ii][jj]-min)/(max-min)));
//    }
//   }
//   return *pm;
//  }

//  Ppm& pixmap(colorscale& cs, int kk, double mmin, double mmax){
//   int ii,jj;
//   Ppm* pm = new Ppm(b,c);
//   for(ii=0;ii<b;ii++){
//    for(jj=0;jj<c;jj++){
//     pm->draw_pixel(ii,jj,cs.get(256.*(vppp[kk][ii][jj]-mmin)/(mmax-mmin)));
//    }
//   }
//   return *pm;
//  }

  t2& slice(int kk){
   int ii,jj;
   t2* m = new t2(b,c);
   for(ii=0;ii<b;ii++){
    for(jj=0;jj<c;jj++){
     (*m)(ii,jj)=vppp[kk][ii][jj];
    }
   }
   return (*m);
  }

  double getmin(int kk){
   int ii,jj;
   for(ii=0;ii<b;ii++){
    for(jj=0;jj<c;jj++){
     min = MIN(min,vppp[kk][ii][jj]);
    }
   }
   return min;
  }

  double getmax(int kk){
   int ii,jj;
   for(ii=0;ii<b;ii++){
    for(jj=0;jj<c;jj++){
     max = MAX(max,vppp[kk][ii][jj]);
    }
   }
   return max;
  }

  
};



