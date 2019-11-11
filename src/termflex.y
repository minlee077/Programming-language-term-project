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


%token INTEGER
%token FLOAT
%token epsilon
%token ID
%token int
%token float
%token Keyword
%token Operator
%token Delimiter


%%

program :				"mainprog" ID ';' declarations subprogram_declarations compound_statement
				;

declarations :			    	type identifier_list ';' declarations 
	     			|	epsilon
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

standard_type :			      	"int"
	      			|	"float"
				;

subprogram_declarations :		subprogram_declaration subprogram_declarations
		       		|	epsilon
				;

subprogram_declaration :	       	subprogram_head declarations compound_statement
				;

subprogram_head :			"function" ID arguments ':' standard_type ';'
	       			|	"procedure" ID arguments ';'
				;

arguments :				'(' parameter_list ')'
	 			|	epsilon
				;

parameter_list :			identifier_list ':' type
	     			|	identifier_list ':' type ';' parameter_list
				;


compound_statement :			"begin" statement_list "end"
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
				|	"return" expression
				|	"nop"
				;

if_statement :			     	"if" expression ':' statement '('"elif" expression ':' statement')''*' '['"else" ':' expression ']'
				;

while_statement :			"while" expression ':' statement '['"else" ':' statement']'
				;

for_statement :			      	"for" expression "in" expression ':' statement '['"else" ':' statement']'
				;

print_statement :			"print"
	       			|	"print" '(' expression ')'  // here
				;

variable :				ID
	 			|	ID '[' expression ']'
				;

procedure_statement :		    	ID '(' actual_parameter_expression ')'
				;

actual_parameter_expression :	    	expression_list
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

relop :				      	">"
			        |	">="
				|	"<"
				|	"<="
				|	"=="
				|	"!="
				|	"in"
				;

addop :					'+'
      				|	'-'
				;

multop :			       	'*'
       				|	'/'
				;


