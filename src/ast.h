typedef struct _iv{
int ival; 
int length;
char* typeName;
}intVarT;

typedef struct _dv{
int ival; 
int length;
char* typeName;
}doubleVarT;

typedef struct _v{
doubleVarT* dV;
intVarT* iV;
}variableT;

typedef struct _f{
char* name;
variableT* ret;
variableT** args;
}functionT;


