%{
#include <stdio.h>
#include "termflex.tab.h"
int spaceCount = 1;
int sourceLineCount = 1;
int charLength = 0;
int lineNumber;

int yywrap(void)
{
    return 1;
}
/*Define*/
%}
LETTER          [a-zA-Z]
DIGIT          [0-9]
%%
in 			{return IN;}
if 			{return IF;}
for			{return FOR;}
end 			{return END;}
nop 			{return NOP;}
then 			{return THEN;}
else 			{return ELSE;}
begin	 		{return START;}
while			{return WHILE;}
print	 		{return PRINT;}
return	 		{return RETURN;}
epsilon			{return EPSILON;}
mainprog 		{return MAINPROG;}
function 		{return FUNCTION;}
procedure		{return PROCEDURE;}
elif			{return ELIF;}
int             {return INT;}
float           {return FLOAT;}
DIGIT+			{return INTNUM;}
INTNUM.INTNUM+		{return FLOATNUM;}
LETTER(LETTER|DIGIT)*   {printf("ID"); return ID;}

\+			{return PLUS;}
\-			{return MINUS;}
\*			{return MULT;}
\/			{return DIVISION;}
\<\=			{return ESMALLER;}
\<			{return SMALLER;}
\>\=			{return ELARGER;}
\>			{return LARGER;}
\=\=			{return EQUAL;}
\!\=			{return NEQUAL;}
\!			{return NOT;}

";"			{return SEMI;}
"."			{return DOT;}
","			{return COMMA;}
"="			{return ASSIGN;}
"("			{return POPEN;}
")"			{return PCLOSE;}
":"			{return COLON;}
"["			{printf("["); return BOPEN;}
"]"			{return BCLOSE;}

Comment     ;
\\          spaceCount++;
[ \t]+ 		spaceCount++;
\n 			lineNumber++;
%%

/*user subprogram*/
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
	} else {
		fprintf(stderr, "%p : %s", fp, filename);
		return 0;
	}
		
	printf("hello");

	yyin = fp; 

	yylex();  
	
	printf("hello");
	
	return 0 ;
	

}

