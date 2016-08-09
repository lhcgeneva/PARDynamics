class t1{
 
 private:
 
  int a;
  double* vp;
  
  void init(const int i){
   a=i;
   vp = new double[a];
   for(int l=0;l<a;l++){
     vp[l]=0.;
    }
  }

 public:

  t1(){
   init(1);
  }

  t1(int i){
   init(i);
  }

  t1(t1& t){
   if(vp)delete vp;
   init(t.d1());
   for(int ii=0;ii<a;ii++){
     vp[ii]=t(ii);
    }
  }

  ~t1(){ delete vp;}

  int d1() const {return a;}
 
  double& operator() (int i) {return vp[i];}

  double* pointer(){return vp;}

};



