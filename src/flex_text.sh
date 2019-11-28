flex termflex.l
bison -d termflex.y
gcc lex.yy.c -o termflex -lfl
./termflex
