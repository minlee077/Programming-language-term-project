%{

#include <stdio.h>
#include <string.h>

void yyerror(const char *str)
{
    fprintf(stderr, "error : %s\n", str);
}

int yywrap()
{
     return 1;
}

main()
{
    yyparse();
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
%token BEGIN 
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
%token EPSILON
%token ELIF

%%

program:        MAINPROG ID SEMI declarations subprogram_declarations compound_statement
       ;

declarations:       type identifier_list SEMI declarations 
            |       EPSILON
            ;
identifier_list:    ID
               |	ID COMMA identifier_list
               ;

type:       standard_type
    |       standard_type BOPEN num BCLOSE
    ;

num:        INTNUM
   |        FLOATNUM
   ;

standard_type:      INT
             |      FLOAT
             ;

subprogram_declarations:        subprogram_declaration subprogram_declarations
                       |        EPSILON
                       ;

subprogram_declaration:     subprogram_head declarations compound_statement
                      ;

subprogram_head:        FUNCTION ID arguments COLON standard_type SEMI
               |        PROCEDURE ID arguments SEMI
               ;

arguments:      POPEN parameter_list PCLOSE
         |      EPSILON
         ;

parameter_list:     identifier_list COLON type
              |     identifier_list COLON type SEMI parameter_list
              ;

compound_statement:     BEGIN statement_list END
                  ;

statement_list:     statement
              |     statement SEMI statement_list
              ;

statement:      variable ASSIGN expression
         |      print_statement
         |      procedure_statement
         |      compound_statement
         |      if_statement
         |      while_statement
         |  	for_statement
         |  	RETURN expression
         |  	NOP
         ;

/*else_statement:     ELSE COLON statement
*/

if_statement:       IF expression THEN COLON statement
            |       ELIF expression COLON statement
            |       IF expression THEN COLON statement ELSE statement
            ;


while_statement :	    WHILE expression COLON statement 
                |	    WHILE expression COLON statement ELSE statement
                ;

for_statement :     FOR expression IN expression COLON statement 
              |     FOR expression IN expression COLON statement ELSE statement
              ;

print_statement :       PRINT
                |       PRINT POPEN expression PCLOSE
                ;

variable :	ID
         |	ID BOPEN expression BCLOSE
         ;

procedure_statement :       ID POPEN actual_parameter_expression PCLOSE
                    ;

actual_parameter_expression :       EPSILON
                            |       expression_list
                            ;

expression_list :       expression
                |       expression COMMA expression_list
                ;

expression :        simple_expression
           |        simple_expression relop simple_expression  /* here*/
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
      /*|     IN*/
      ;

addop :     '+' /*sign*/
      |     '-'
      ;

multop :        '*'
       |        '/'
       ;
