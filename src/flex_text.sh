flex termflex.l
bison -d termflex.y
gcc lex.yy.c termflex.tab.c -o termflex -ll
./termflex
