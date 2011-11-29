#include <cstdlib>
#include <cstdio>
#include <iostream>
#include <fstream>

#include <map>

using namespace std;

int yyparse();
extern FILE *yyin;

map<string, int> tabla;
map<string,int>::iterator iterador;

int main(int argc, char *argv[])
{
	if (argc > 0) {
		++argv, --argc; /* El primer argumento es el nombre del programa */
		//in.open(argv[0], ifstream::in|ifstream::binary);
		yyin = fopen(argv[0], "r");

		if (yyin == NULL) {
			cerr << "No se pudo abrir el archivo " << argv[0] << endl << endl;
			return 0;
		}
	}
	else {
		cerr << "Uso: " << argv[0] << " <archivo>" << endl << endl;
		return 0;
	}

	yyparse();

	return 0;
}
