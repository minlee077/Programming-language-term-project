%{
#include <stdio.h>
#include "termflex.tab.h"
int spaceCount = 1;
int sourceLineCount = 1;
int charLength = 0;
int lineNumber=0;

int yywrap(void)
{
    return 1;
}
/*Define*/
%}
LETTER          [a-zA-Z]
DIGIT          [0-9]
IDS    [a-zA-Z][a-zA-Z0-9]*
%%
in 			{return IN;}
if 			{return IF;}
for			{return FOR;}
end 			{printf("end1"); return END;}
nop 			{return NOP;}
then 			{return THEN;}
else 			{return ELSE;}
begin	 		{printf("start!"); return START;}
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
{DIGIT}+			{printf("num"); return INTNUM;}
{DIGIT}+.{DIGIT}+		{printf("float");return FLOATNUM;}
{IDS}   {printf("hello\n"); return ID;}

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
"["			{ return BOPEN;}
"]"			{return BCLOSE;}

\\          spaceCount++;
[ \t]+ 		spaceCount++;
\n 			lineNumber++;
%%

/*user subprogram*/
/*
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
		fprintf(stderr, "%p : %s\n", fp, filename);
	}
	printf("hello \n");
		

	yyin = fp; 

	yylex();  
	
	fclose(yyin);

        printf("hello \n");
	return 0 ;

}
*/
