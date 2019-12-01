%{

#include <stdio.h>
#include <string.h>
#include "ast.h"
extern int lineNumber;
extern int yylex();

#define MAXIMUM 100
#define ERROR -1 

// to trac current index
int currentIndex = 0;
// id array to manage ids.
char* ids[MAXIMUM];
// id range array to manage arrays
int range[MAXIMUM];
// store id's type
char* idType[MAXIMUM];
// count number of declare to set type on every ids
int numOfDeclare = 0;

// assign id. 
int assign(char* name){
    if(currentIndex >= MAXIMUM || currentIndex < 0){
        return 0;
    }
    ids[currentIndex++] = name;
    numOfDeclare++;
    return 1;
}

// need to figure out the value size is integer.
int assignArraySize(const int index ,const int size){
    if(size < 0){
        return 0;
    }
    range[index] = size;
    return 1;
}
int setIdType(char * type){
    if(numOfDeclare == 0){
        return 0;
    }

    int i;
    for(i = 0; i < numOfDeclare;i++){
        // because it is LR parser. Store reversely.
        idType[currentIndex - 1 - i] = type;
    }
    numOfDeclare = 0;
    return 1;
}


// by the id value, get the index.
int getIdIndex(const char *name){
    int i;
    for(i = 0; i < currentIndex;i++){
        if(!(strcmp(ids[i], name))){
            return i;
        }
    }
    return ERROR;
}

// be access point, check if that it is out of range.
int isIdRangeOk(int idNum,int accessNum){
    if(range[idNum] > accessNum){
        return 0;
    } 
    return 1;
}

//free array by replacing with last value.
// if there is no last value, then just ignore value with moving currentIndex forward. 
int freeId(const char* name){
    int id = getIdIndex(name);
    if(id != ERROR && currentIndex > 1){
        ids[id] = ids[currentIndex];
        range[id] = range[currentIndex];
        currentIndex--;
        return 1;
    } else if(currentIndex == 1){
        currentIndex--;
        return 1;
    }
    return 0;
}

extern FILE* yyin;
void yyerror(const char *str)
{
    fprintf(stderr, "error : %s at %d line \n", str,lineNumber);
}

%}

%union {

char* str;
int ival; 
double dval;

variableT variable;
functionT function;
}



%token <ival>INTNUM
%token <str> ID
%token <str> INT
%token <str> FLOAT
%token <dval>FLOATNUM
%token MAINPROG
%token FUNCTION 
%token PROCEDURE
%token START
%token END
%token IF
%token THEN 
%token ELSE 
%token NOP 
%token WHILE 
%token RETURN 
%token PRINT 
%token IN 
%token <str>PLUS
%token <str>MINUS
%token MULT 
%token DIVISION 
%token ESMALLER 
%token SMALLER 
%token ELARGER 
%token LARGER
%token EQUAL
%token NEQUAL 
%token NOT
%token SEMI 
%token COLON 
%token DOT 
%token ASSIGN
%token COMMA 
%token POPEN 
%token PCLOSE 
%token BOPEN 
%token BCLOSE 
%token FOR
%token ELIF

%right ELIF ELSE WHILE FOR IF COLON

%type <variable> variable
%type <dval> factor procedure_statement term simple_expression expression
%type <str> sign
%type <str> type
%type <str> standard_type
%%

program:        MAINPROG ID SEMI declarations subprogram_declarations compound_statement
       ;

/* decleared with comma are not processed*/
declarations:       declaration declarations
            |       %empty
            ;

declaration:    type identifier_list SEMI{   setIdType($1);}
           ;

identifier_list:
               ID
                    {
                       if(getIdIndex($1)==ERROR){
                           if(currentIndex < MAXIMUM){
                               assign($1);
                           }else{
                               yyerror("too many ids");
                           }
                       }else{
                           yyerror("already declared"); 
                       }
                   }
               |   ID COMMA identifier_list{ 
                       if(getIdIndex($1)==ERROR){
                           if(currentIndex < MAXIMUM){
                               assign($1);
                           }else{
                               yyerror("too many ids");
                           }
                       }else{

                           yyerror("already declared");
                       }
                   }
               ;
type:       standard_type {$$ = $1;}
    |       standard_type BOPEN INTNUM BCLOSE{$$ = $1;}
    ;

standard_type:      INT {$$ = $1;}
             |      FLOAT{$$=$1;}
             ;

subprogram_declarations:        subprogram_declaration subprogram_declarations
                       |        %empty
                       ;

subprogram_declaration:     subprogram_head declarations compound_statement
                      ;

subprogram_head:        FUNCTION ID arguments COLON standard_type SEMI {assign($2);setIdType("function");}
               |        PROCEDURE ID arguments SEMI {assign($2);setIdType("procedure");}
               ;

arguments:      POPEN parameter_list PCLOSE
         |      %empty
         ;

parameter_list:     parameter
              |     parameter parameter_list
              ;

parameter: identifier_list COLON type
         ;

compound_statement:     START statement_list END
                  ;

statement_list:     statement SEMI
              |     statement SEMI statement_list
              ;

statement:      variable ASSIGN expression {
	            /*
	            char* type;
                    if((int)$3 == $3)
                        type="int";
                    else
                        type="float";
                    
                    if(type != idType[getIdIndex($1.varName)]){
                        yyerror("wrong type. Assgin error");
                    }
                   */
                } 
         |      print_statement
         |      procedure_statement
         |      compound_statement
         |  	RETURN expression
         |      if_statement
		 |      while_statement 
         |      for_statement 
         |  	NOP
         ;

if_statement:       IF expression COLON statement ELIF elif_statement ELSE COLON statement
            |       IF expression COLON statement ELIF elif_statement
            |       IF expression COLON statement ELSE COLON statement
            |       IF expression COLON statement
            ;

elif_statement:    expression COLON statement 
              |    expression COLON statement ELIF elif_statement
              ;

while_statement  :    WHILE expression COLON statement ELSE COLON statement 
                 |    WHILE expression COLON statement
                 ;

for_statement :     FOR in_expression COLON statement ELSE COLON statement
              |     FOR in_expression COLON statement
              ;

print_statement :       PRINT
                |       PRINT POPEN expression PCLOSE
                ;

variable :	ID  {
                char tmpstr[100]; 
                if (getIdIndex($1)==ERROR){
                                    strcpy(tmpstr,"variable undefined:");
                                    strcat(tmpstr,$1);
                                    yyerror(tmpstr);
                }
                $$.varName = $1;}
         |	ID BOPEN expression BCLOSE {
                                        //printf("tests");
                                        char tmpstr[100];
                                        if(getIdIndex($1)==ERROR){
                                            strcpy(tmpstr,"variable undefined:");
                                            strcat(tmpstr,$1);
                                            yyerror($1);
                                        }
                                               if((int)($3)!=$3)
                                                yyerror("array index error parameter not integer");
                                        }
         ;

procedure_statement :       ID POPEN actual_parameter_expression PCLOSE {$$ = 1;}
                    ;

actual_parameter_expression :       %empty
                            |       expression_list
                            ;

expression_list :       expression
                |       expression COMMA expression_list
                ;

expression :        simple_expression {$$ = $1;}
           |        simple_expression relop simple_expression  {$$ = $1;}
           ;
in_expression :    expression IN expression
              ;
simple_expression:      term {$$ = $1;}
                 |      term addop simple_expression {$$ = $1 + $3;}
                 ;
/*처리필요 */
term :      factor {$$ = $1;}
     |      factor multop term {$$ = $1 * $3;}
     ;

factor :        INTNUM { $$=$1;}
       |        FLOATNUM {$$=$1;}
       |    	variable {$$=$1.value;}
       |    	procedure_statement {$$ = 0;}
       |    	NOT factor { $$ = !$2;}
       |    	sign factor { 
                              if(strcmp($1,"+"))
                                $$ = $2;
                              else
                                $$ = -$2;
                            }
       ;

sign:       PLUS
    |       MINUS
    ;

relop :     ELARGER
      |     LARGER
      |     ESMALLER
      |     SMALLER
      | 	EQUAL
      | 	NEQUAL
      ;

addop :     PLUS /*sign*/
      |     MINUS
      ;

multop :        MULT
       |        DIVISION
      ;

%%

int main()
{

	FILE *fp; 
	char filename[50]; 
	
	printf("Enter the filename: \n"); 
	scanf("%s",filename); 

	fp = fopen(filename,"r"); 

	if(!fp)
	{
		fprintf(stderr,"could not open file %s\n",filename);
		return 0;
	}

	yyin = fp; 
	do{
		yyparse();
	}while(!feof(yyin));
	
	return 0 ;
}
