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
%token MULTI 
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
%token EQUAL 
%token COMMA 
%token POPEN 
%token PCLOSE 
%token BOPEN 
%token BCLOSE 
%token FOR
%token EPSILON
%token ELIF

%%

program :    				MAINPROG ID SEMI declarations subprogram_declarations compound_statement
				;

declarations :				type identifier_list ';' declarations 
	     	     		|	EPSILON
				;
identifier_list : 			ID
			       	|	ID ',' identifier_list
				;

type		:	      		standard_type
           			|	standard_type '[' num ']'
				;

num :					INTEGER
    				|	FLOAT
				;

standard_type :			      	int
	      	      			|	float
				;

subprogram_declarations :		subprogram_declaration subprogram_declarations
					       		|	EPSILON
				;

subprogram_declaration :	       	subprogram_head declarations compound_statement
		       				;

subprogram_head :			FUNCTION ID arguments ':' standard_type ';'
			       			|	PROCEDURE ID arguments ';'
				;

arguments :				'(' parameter_list ')'
	  	 			|	EPSILON
				;

parameter_list :			identifier_list ':' type
	       	     			|	identifier_list ':' type ';' parameter_list
				;


compound_statement :			BEGIN statement_list END
		   		   		;

statement_list :		        statement
	       	      			|	statement ';' statement_list
				;

statement :			 	variable '=' expression
	  	 			|	print_statement
				|  	procedure_statement
				|	compound_statement
				|	if_statement
				|	while_statement
				|	for_statement
				|	RETURN expression
				|	NOP
				;

else_statement :                        ELSE ':' statement

if_statement :			     	IF statement ':' statement
	     			|	if_statement else_statement
				|	if_statement ELIF statement ':' statement
	     				;

while_statement :			WHILE statement ':' statement 
				|	while_statement else_statement
					;

for_statement :			      	FOR statement IN expression ':' statement 
	      			|	for_statement else_statement
	      				;

print_statement :			PRINT
			       			|	PRINT '(' expression ')'  // here
				;

variable :				ID
	 	 			|	ID '[' expression ']'
				;

procedure_statement :		    	ID '(' actual_parameter_expression ')'
		    				;

actual_parameter_expression :	    	EPSILON
			    			    	|	expression_list
				;

expression_list :			expression
						|	expression ',' expression_list
				;

expression :			   	simple_expression
	   	   			|	simple_expression relop simple_expression  // here
				;

simple_expression :		  	term
		  		  		|	term addop simple_expression
				;

term :				     	factor
          				|	factor multop term
				;

factor :			      	INTEGER
              				|	FLOAT
				|	variable
				|	procedure_statement
				|	'!' factor
				|	sign factor
				;

sign :				      	'+'
          				|	'-'
				;

relop :				      	LARGERE
      			        |	LARGER
				|	SMALLERE
				|	SMALLER
				|	SAME
				|	NOTSAME
				|	IN
				;

addop :					'+'
            				|	'-'
				;

multop :			       	'*'
              				|	'/'
				;
