//	Class pgm_image
//	This class draws a pgm (gray pix map)
//
//	The functions:
//		pgm_image(char* pgm_name_file,int width_file, int height_file)
//		set_pixel(int i_col, int i_row, double pix_value)
//		set_pixel_cyclic(int i_col, int i_row, double pix_value)
//		draw_image()
//		set_and_draw_pixel(int i_col, int i_row, double pix_value)
//		erase_raw_image()

#include <iostream>	//standard input and output library (includes cin, cout and cerr)
#include <fstream>	//These classes are used to manipulate files with streams 
			//(includes fstream, ofstream, ifstream)
#include <ctime> 	//contains time_t, tm, time(), localtime(), asctime()
#include <string>	//contains string (used to replace char * used in C)
using namespace std;
 
const int PGM_MAX_VAL=256; // Almost always equals 256 (# of gray steps)	

class pgm_image
{
 
 private:  //The following variables and functionscan only be accesed 
 	   //by the member functions
 
  string pgm_name;		// this string stores the name of the image
  int width, height;		// image dimensions
  int i_row,i_col;		// pixel coordinates
//unsigned char * raw_image;	// temporary array to store image
  char * raw_image;		// temporary array to store image
  fstream pgm_file;		// creation of the image file 
  
  string get_current_time_for_header()  
//	This (private) function gives the current time and date
//	printed in the header of the image
  {
  	time_t rawtime;
  	struct tm * timeinfo;
  	time(&rawtime);
  	timeinfo=localtime(&rawtime);
  	return asctime(timeinfo);
  }

  void store_all_empty()
//	This (private) function stores the maximal value allowed in
//	all the temporary array (i.e. all equal to white). 
  {
       	for(int i_height=0; i_height < height; i_height++)
       	{
       		for(int i_width=0; i_width < width; i_width++)
		{
			raw_image[i_width + width*i_height]=PGM_MAX_VAL-1;
  		}
	}
  }
       

 public:  //The following functions can be accesed from outside the class
  
// Constructor:
  
  pgm_image(string pgm_name_file,int width_file, int height_file)
//	This CONSTRUCTOR generates the tempory char array where
//	the pixel's values of the image will be stored.  
  {
	pgm_name=pgm_name_file;
	width=width_file; height=height_file;
//	raw_image=new unsigned char[width*height];
	raw_image=new char[width*height];
        store_all_empty();
  }

// Member functions:
    
  void set_pixel(int i_col, int i_row, double pix_value)
//	This function stores the pixel value in position i_col, i_row
//	pix_value should be in the interval [0,1) where:
//	0 = black and 1= white and intermediate values are gray.
//	If it exedes this interval a cut-off is applied    
  {
//  	raw_image[(height-i_row-1)*width+i_col]=int(floor(PGM_MAX_VAL*pix_value+0.5));
  	raw_image[(height-i_row-1)*width+i_col]=PGM_MAX_VAL-int(PGM_MAX_VAL*pix_value+0.5);
        pix_value=1-pix_value;
	if(PGM_MAX_VAL*pix_value>PGM_MAX_VAL-1)
	{
       	    raw_image[(height-i_row-1)*width+i_col]=PGM_MAX_VAL-1;
	}else
	{
	  if(PGM_MAX_VAL*pix_value<0)
	  {
	    raw_image[(height-i_row-1)*width+i_col]=0;
	  }
	}
//      pix_value=1-pix_value;
//  	raw_image[(height-i_row-1)*width+i_col]=int(PGM_MAX_VAL*pix_value+0.5);
//	if(PGM_MAX_VAL*pix_value>PGM_MAX_VAL-1)
//	{
//	   raw_image[(height-i_row-1)*width+i_col]=PGM_MAX_VAL-1;
//	}else
//	{
//	  if(PGM_MAX_VAL*pix_value<0)
//	  {
//	    raw_image[(height-i_row-1)*width+i_col]=0;
//	  }
//	}
  }
   
  void set_pixel_cyclic(int i_col, int i_row, double pix_value)
//	This function stores the pixel value in position i_col, i_row
//	pix_value should be in the interval [0,1) where:
//	0 = black and 1= white and intermediate values are gray.
//	Outisde this interval the value is folded; cosequently 
//	any value of pix_value is aplied
  {
  	raw_image[(height-i_row-1)*width+i_col]=PGM_MAX_VAL-int(pix_value);
//      pix_value=1-pix_value;
//  	raw_image[(height-i_row-1)*width+i_col]=int(PGM_MAX_VAL*pix_value);
  }
      
  void draw_image()
//	This function draws the image: it opens a file called pgm_name,
//	includes the pgm header in this file (with the date) and
//	writes the values stored in raw_image in the file. Fnally it
//	closes the image file.
  {
	pgm_file.open(pgm_name.c_str(),ios::out | ios::binary); //c_str() converts the string 
								//to const char* used by open
    // begin writing image header
	pgm_file << "P5" << endl;		//For raw ("P2" for ascii)
	pgm_file << "#Created on " << get_current_time_for_header(); 
	pgm_file << width << " " << height << endl;
	pgm_file << PGM_MAX_VAL-1 << endl;	//because it goes form 0 to PGM_MAX_VAL-1
    // end writing image header
	pgm_file.write(raw_image,width*height);	
        pgm_file.close();
  }
  
  void set_and_draw_pixel(int i_col, int i_row, double pix_value)
//	This function combines set_pixel with draw image. This function is
//	convenint to use in the cases where the drowing of each pixel is
//	very slow.  
  {
        pix_value=1-pix_value;
  	raw_image[(height-i_row-1)*width+i_col]=int(256*pix_value);
	if(pix_value>=1)
	{
       	    raw_image[(height-i_row-1)*width+i_col]=255;
	}else
	{
	  if(pix_value<0)
	  {
	    raw_image[(height-i_row-1)*width+i_col]=0;
	  }
	}
	draw_image();
  }
  
  void erase_raw_image()
//	This function erases frees the temporary vector raw_image.
//	This saves memory in the case that many figures are beeing oppened.
  {
	delete[] raw_image;
  }
  
  int get_width(){ return width; }
  
  int get_height(){return height;}
       

};
