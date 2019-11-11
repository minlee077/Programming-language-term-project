%{
#include <stdio.h>
#include "termflex.tab.h"
%}


%%

[\t]+




in 			return IN;
if 			return IF;
for			return FOR;
end 			return END;
nop 			return NOP;
then 			return THEN;
else 			return ELSE;
begin	 		return BEGIN;
while			return WHILE;
print	 		return PRINT;
return	 		return RETURN;
epsilon			return EPSILON;
mainprog 		return MAINPROG;
function 		return FUNCTION;
procedure		return PROCEDURE;
elif			return ELIF;


[a-zA-Z]		return LETTER;
[0-9]			return DIGIT;
[0-9]+			return INTEGER;
[0-9]+.[0-9]+		return FLOAT;
[a-zA-Z][a-zA-Z0-9]*	return ID

\+			return PLUS;
\-			return MINUS;
\*			return MULTI;
\/			return DIVISION;
\<\=			return SMALLERE;
\<			return SMALLER;
\>\=			return LARGERE;
\>			return LARGER;
\=\=			return SAME;
\!\=			return NOTSAME;
\!			return NOT;

";"			return SEMICOLON;
"."			return DOT;
","			return COMMA;
"="			return EQUAL;
"("			return PARENTHESIS_OPEN;
")"			return PARENTHESIS_CLOSE;
":"			return COLON;
"["			return BRACKET_OPEN;
"]"			return BRACKET_CLOSE;

[ \t]+ |
\n 			return WHITESPACE;

%%
