#include <18F2550.h>
#fuses MCLR,NOPBADEN,NOWDT,XT
#use delay(clock=4M)

//definiciones en RAM
//#byte latb=0xF8A
#bit dec_en=0xF80.1
#bit unid_en=0xF80.0

#use fast_io(a)
#use fast_io(b)

#include <seg.c>
int disp[10]={0b00111111,0b00000110,0b01011011,0b01001111,0b01100110
              0b01101101,0b01111101,0b00000111,0b01111111,0b01101111
             };

void mostrar_cont(int c, short u_en){
   output_b(disp[c]);
   if(u_en==true){
      unid_en=1;
   }
   else{
      dec_en=1;
   }
   delay_ms(10);
   unid_en=0;
   dec_en=0;
   return;
}

void main(){
   set_tris_a(0xFC);   
   set_tris_b(0);
   dec_en=0;
   unid_en=0;
   //por siempre...
   while(true){
      int dec=0;      
      while(dec<10){
         int unid=0;
         while(unid<10){
            mostrar_cont(unid,true);
            unid++;
            mostrar_cont(dec,false);        
         }
         dec++;
      }
   }
   return;
}
