EXPR_LEXER	:= expr_lexer.cpp
EXPR_GRAMMAR	:= expr.cpp
EXPR_TOKENS	:= tokens.h
PRJ_TREE_SRC	:= expr_tree.cpp
PRJ_TREE_HDR	:= expr_tree.h
TARGET  := expr
SRCS    := ${PRJ_TREE_SRC} ${EXPR_GRAMMAR} ${EXPR_LEXER} main.cpp
OBJS    := ${SRCS:.cpp=.o} 

CCFLAGS = -g
LDFLAGS = 
LIBS    = 

.PHONY: all clean

all:: ${TARGET} 

${TARGET}: ${OBJS} 
	${CXX} ${LDFLAGS} -o $@ $^ ${LIBS} 

${OBJS}: %.o: %.cpp
	${CXX} ${CCFLAGS} -o $@ -c $<

${PRJ_TREE_SRC} ${PRJ_TREE_HDR}: expr.tc
	treecc -o ${PRJ_TREE_SRC} -h ${PRJ_TREE_HDR} $<

${EXPR_LEXER}: expr.l
	flex -o $@ $<

${EXPR_GRAMMAR} ${EXPR_TOKENS}: expr.y
	bison --defines=${EXPR_TOKENS} -r all -o ${EXPR_GRAMMAR} $<

clean:: 
	-rm -f *~ *.o ${PRJ_TREE_SRC} ${PRJ_TREE_HDR} ${TARGET} ${EXPR_LEXER} ${EXPR_GRAMMAR} ${EXPR_TOKENS} *.output

