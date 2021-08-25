#include <iostream>
#include <stdlib.h>
using namespace std;

void leer_datos (double[4][6]);
int buscar_depto (double[4][6]);
int buscar_piso (double[4][6]);

int main ()
{		
	double datos[4][6]={{1, 2, 20, 30.5, 22, 43.7}, {13, 2, 12, 20.3, 17, 12.1}, {7, 4, 98, 92.1, 45, 66.2}, {12, 4, 74, 73.5, 76, 87.3}};
	int clientes[4][2], cantidad_de_pisos;
	int depto, piso, cliente_1, cliente_2;
	
	//leer_datos(datos);
	
	//depto=buscar_depto(datos);	
	
	piso=buscar_piso(datos);

	
	/*cout << "\n\n";
	cout << "Cliente con mas llamadas locales: " << depto;
	*/cout << "Piso con mas minutos de llamadas interurbanas: " <<piso<<endl;
	/*cout << "\n\n";
	
	buscar_mejor_cliente_por_piso(datos, clientes, cantidad_de_pisos);
	
	guardar_resultados(clientes, cantidad_de_pisos);
	
	return 0;*/
}
void leer_datos (double datos)
{
}
int buscar_depto (double datos[4][6])
{
	int max=datos[0][2];
	int depto=0;
	
	for (int f=0; f<4; f++)
	{
		for(int c=2; c=2; c++)
		{
			if (datos[f][2]>max)
			{
				max=datos[f][2];
				depto=datos[f][0];
			}
		}
	}
	
	return depto;	
}
int buscar_piso (double datos[4][6])
{
	int piso=0, pisol, auxp; 
	double min=-1;	
	
	while (piso<51)
	{
		double aux=0;
		
		for (int f=0; f<4; f++)
		{			
		for (int c=1; c=1; c++)
			{
				if (datos[f][1]==piso)
				{
					aux+=datos[f][5];
					auxp=datos[f][1];
				}			
			}
		}
		if (min<aux)
		{
			min=aux;
			pisol=auxp;
		}
		piso++;	
	}
	return pisol;
}
int buscar_mejor_cliente_por_piso (double datos[4][6], int clientes [4][2], int& cantidad_de_pisos)
{
	int pisoac=0;
	double totalpiso;
	
	while (pisoac<51)
	{
		for (int f=0; f<4; f++)
		{
			for (int c=0; c=1; c++)
			{
				if (piso==datos[f][1])
				{
					totalpiso+=(datos[f][3]+datos[f][5]);
					
				}
			}
		}
		
		
	}
}
