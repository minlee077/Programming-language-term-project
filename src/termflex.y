%{

#include <stdio.h>
#include <string.h>
extern int lineNumber;
extern int yylex();
extern FILE* yyin;
void yyerror(const char *str)
{
    fprintf(stderr, "error : %s\n", str);
}


%}


%token INTNUM
%token ID
%token INT
%token FLOAT
%token FLOATNUM
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
%token PLUS
%token MINUS
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

%right ELIF ELSE WHILE FOR COLON
%%

program:        MAINPROG ID SEMI declarations subprogram_declarations compound_statement
       ;

declarations:       type identifier_list SEMI declarations 
            |       %empty
            ;
identifier_list:    ID
               |	ID COMMA identifier_list
               ;

type:       standard_type
    |       standard_type BOPEN INTNUM BCLOSE
    ;

standard_type:      INT
             |      FLOAT
             ;

subprogram_declarations:        subprogram_declaration subprogram_declarations
                       |        %empty
                       ;

subprogram_declaration:     subprogram_head declarations compound_statement
                      ;

subprogram_head:        FUNCTION ID arguments COLON standard_type SEMI
               |        PROCEDURE ID arguments SEMI
               ;

arguments:      POPEN parameter_list PCLOSE
         |      %empty
         ;

parameter_list:     identifier_list COLON type
              |     identifier_list COLON type SEMI parameter_list
              ;

compound_statement:     START statement_list END
                  ;

statement_list:     statement
              |     statement SEMI statement_list
              ;

statement:      variable ASSIGN expression
         |      print_statement
         |      procedure_statement
         |      compound_statement
         |  	RETURN expression
         |      if_statement
		 |      while_statement 
         |      for_statement 
         |  	NOP
         ;

if_statement:       IF expression COLON statement elif_statement ELSE COLON statement
            |       IF expression COLON statement elif_statement 
            ;

elif_statement:    %empty
	          |    ELIF expression COLON statement elif_statement
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

variable :	ID
         |	ID BOPEN expression BCLOSE
         ;

procedure_statement :       ID POPEN actual_parameter_expression PCLOSE
                    ;

actual_parameter_expression :       %empty
                            |       expression_list
                            ;

expression_list :       expression
                |       expression COMMA expression_list
                ;

expression :        simple_expression
           |        simple_expression relop simple_expression  /* here*/
           ;
in_expression :    expression IN expression
              ;
simple_expression:      term
                 |      term addop simple_expression
                 ;

term :      factor
     |      factor multop term
     ;

factor :        INTNUM
       |        FLOATNUM
       |    	variable
       |    	procedure_statement
       |    	NOT factor
       |    	sign factor
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
