%{
#include <stdio.h>
#include "y.tab.h"
int spaceCount = 1;
int sourceLineCount = 1;
int charLength = 0;
extern int lineNumber; 

int yywarp(void)
{
    return 1;
}
/*Define*/
%}
%%
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
int             return INT;
float           return FLOAT;

[a-zA-Z]		return LETTER;
[0-9]			return DIGIT;
DIGIT+			return INTNUM;
INTNUM.INTNUM+	return FLOATNUM;
LETTER(LETTER|DIGIT)*   return ID

\+			return PLUS;
\-			return MINUS;
\*			return MULT;
\/			return DIVISION;
\<\=			return ESMALLER;
\<			return SMALLER;
\>\=			return ELARGER;
\>			return LARGER;
\=\=			return EQUAL;
\!\=			return NEQUAL;
\!			return NOT;

";"			return SEMI;
"."			return DOT;
","			return COMMA;
"="			return ASSIGN;
"("			return POPEN;
")"			return PCLOSE;
":"			return COLON;
"["			return BOPEN;
"]"			return BCLOSE;

Comment     ;
\\          spacecount++;
[ \t]+ 		spacecount++;
\n 			lineNumber++;
%%
/*user subprogram*/
