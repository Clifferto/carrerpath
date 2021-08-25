//////////////////// Driver to drive 7seg-display ///////////////////////
////                                                                 ////
////        seg_setup(logic)                Config logic of disp    ////
////                                         1 = positive            ////
////                                         0 = negative            ////
////                                                                 ////
////        seg_put(value)                  Put value on disp       ////
////                                         according with the      ////
////                                         type of logic selected  ////
////                                                                 ////
/////////////////////////////////////////////////////////////////////////
////        (C) Copyright 2020,4040 Cliff                            ////
/////////////////////////////////////////////////////////////////////////
#include <18F2550.h>  
int disp[10]={0b00111111,0b00000110,0b01011011,0b01001111,0b01100110
              0b01101101,0b01111101,0b00000111,0b01111111,0b01101111};

short neg_logic;

void seg_setup(short logic){
   neg_logic=logic;
}

void seg_put(int num){
   if(num<0 || num>9){
      output_b(0); 
   }
   else{
      if(neg_logic==true){
         output_b(~disp[num]); 
      }
      else{
         output_b(disp[num]); 
      }
   }   
}
