#!/bin/sh
#
# Makefile for FF v 1.0
#


####### FLAGS

TYPE	= 
ADDONS	= 

CC      = gcc

C_STANDARD=c99

CFLAGS	= -DLINUX -Werror=implicit-function-declaration -fmax-errors=1 -O6 -Wall -w -g -std=$(C_STANDARD) $(TYPE) $(ADDONS) 
# -g -pg

LIBS    = -lm

FLEX_FLAGS =

BISON_FLAGS =


####### Files

PDDL_PARSER_SRC	= \
	lex-fct_pddl.c \
	lex-ops_pddl.c \
	scan-fct_pddl.c \
	scan-ops_pddl.c \
	scan-probname.c \
	

PDDL_PARSER_OBJ = \
	lex-fct_pddl.o \
	lex-ops_pddl.o \
	scan-fct_pddl.o \
	scan-ops_pddl.o \



SOURCES 	= \
	main.c \
	memory.c \
	output.c \
	parse.c \
	inst_pre.c \
	inst_easy.c \
	inst_hard.c \
	inst_final.c \
	orderings.c \
	relax.c \
	search.c \
	times.c \
	random.c

OBJECTS 	= $(SOURCES:.c=.o)

####### Implicit rules

.SUFFIXES:

.SUFFIXES: .c .o

.c.o:
	@echo "Compiling file $<" 
	$(CC) -c $(CFLAGS) $<



####### Build rules


ff: $(OBJECTS) $(PDDL_PARSER_OBJ)
	$(CC) -o ff $(OBJECTS) $(PDDL_PARSER_OBJ) $(CFLAGS) $(LIBS)

# pddl syntax
lex-fct_pddl.c: lex-fct_pddl.l 
	flex --nounistd --header-file="lex-fct_pddl.h" --prefix=fct_pddl --outfile="lex-fct_pddl.c" $(FLEX_FLAGS) lex-fct_pddl.l

lex-ops_pddl.c: lex-ops_pddl.l
	flex --nounistd --header-file="lex-ops_pddl.h" --prefix=ops_pddl --outfile="lex-ops_pddl.c" $(FLEX_FLAGS) lex-ops_pddl.l

scan-fct_pddl.c: scan-fct_pddl.y
	bison --defines="scan-fct_pddl.h" --name-prefix="fct_pddl" --file-prefix="scan-fct_pddl" --output="scan-fct_pddl.c" $(BISON_FLAGS) scan-fct_pddl.y

scan-ops_pddl.c: scan-ops_pddl.y
	bison --defines="scan-ops_pddl.h" --name-prefix="ops_pddl" --file-prefix="scan-ops_pddl" --output="scan-ops_pddl.c" $(BISON_FLAGS) scan-ops_pddl.y

lex-fct_pddl.o: lex-fct_pddl.c scan-fct_pddl.c
	@echo "Compiling fct lexer"
	$(CC) -c $(CFLAGS) -o $@ lex-fct_pddl.c

lex-ops_pddl.o: lex-ops_pddl.c scan-ops_pddl.c
	@echo "Compiling ops lexer"
	$(CC) -c $(CFLAGS) -o $@ lex-ops_pddl.c

scan-fct_pddl.o: scan-fct_pddl.c lex-fct_pddl.o
	@echo "Compiling fct parser"
	$(CC) -c $(CFLAGS) -o $@ scan-fct_pddl.c

scan-ops_pddl.o: scan-ops_pddl.c lex-ops_pddl.o
	@echo "Compiling ops parser"
	$(CC) -c $(CFLAGS) -o $@ scan-ops_pddl.c


# misc
clean:
	rm -f *.o *.bak *~ *% core *_pure_p9_c0_400.o.warnings \
        \#*\# $(RES_PARSER_SRC) $(PDDL_PARSER_SRC)

veryclean: clean
	rm -f ff H* J* K* L* O* graph.* TIME* SEARCHTIME* *.symbex gmon.out \
	$(PDDL_PARSER_SRC) \
	lex-fct_pddl.c lex-ops_pddl.c lex.probname.c \
	*.output

lint:
	lclint -booltype Bool $(SOURCES) 2> output.lint

# DO NOT DELETE
