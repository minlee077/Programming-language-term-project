%{
#include <stdio.h>
#include "ast.h"
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
in 			{printf("%s", yytext);return IN;}
if 			{printf("%s", yytext);return IF;}
for			{printf("%s", yytext);return FOR;}
end 			{printf("%s", yytext); return END;}
nop 			{printf("%s", yytext);return NOP;}
then 			{printf("%s", yytext);return THEN;}
else 			{printf("%s", yytext);return ELSE;}
begin	 		{printf("%s", yytext);return START;}
while			{printf("%s", yytext);return WHILE;}
print	 		{printf("%s", yytext); return PRINT;}
return	 		{printf("%s", yytext);return RETURN;}
mainprog 		{printf("%s", yytext);return MAINPROG;}
function 		{printf("%s", yytext);return FUNCTION;}
procedure		{printf("%s", yytext);return PROCEDURE;}
elif			{printf("%s", yytext);return ELIF;}
int             {yylval.str = strdup(yytext); printf("%s", yytext);return INT;}
float           {yylval.str = strdup(yytext); printf("%s", yytext);return FLOAT;}
{DIGIT}+			{ yylval.ival = atoi(yytext);printf("%s", yytext); return INTNUM;}
{DIGIT}+.{DIGIT}+       {yylval.dval=atof(yytext);printf("%s", yytext);return FLOATNUM;}
{IDS}   { yylval.str = strdup(yytext);printf("%s", yytext); return ID;}
"+"			{yylval.str=strdup(yytext);printf("%s", yytext);return PLUS;}
"-"			{yylval.str=strdup(yytext);printf("%s", yytext);return MINUS;}
"*"			{printf("%s ", yytext);return MULT;}
"/"			{printf("%s", yytext);return DIVISION;}
"<="			{printf("%s", yytext);return ESMALLER;}
"<"			{printf("%s", yytext);return SMALLER;}
">="			{printf("%s", yytext);return ELARGER;}
">"			{printf("%s", yytext);return LARGER;}
"=="			{printf("%s", yytext);return EQUAL;}
"!="			{printf("%s", yytext);return NEQUAL;}
"!"			{printf("%s", yytext);return NOT;}

";"			{printf("%s", yytext);return SEMI;}
"."			{printf("%s", yytext);return DOT;}
","			{printf("%s", yytext);return COMMA;}
"="			{printf("%s", yytext);return ASSIGN;}
"("			{printf("%s", yytext);return POPEN;}
")"			{printf("%s", yytext);return PCLOSE;}
":"			{printf("%s", yytext);return COLON;}
"["			{printf("%s", yytext); return BOPEN;}
"]"			{printf("%s", yytext);return BCLOSE;}

\\                      {spaceCount++; printf("%s", yytext);}
[ \t]+ 		        {spaceCount++; printf("%s",yytext); }
\n 			{lineNumber++;printf("%s", yytext); }
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
