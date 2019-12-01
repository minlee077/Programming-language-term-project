typedef struct _dv{
double value; 
int length;
char* varName;
char* typeName;
}variableT;

typedef struct _f{
char* functionName;
variableT* ret;
variableT** args;
}functionT;
