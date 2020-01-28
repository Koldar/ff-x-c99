#!/bin/sh
#
# Makefile for FF v 1.0
#


####### FLAGS

TYPE	= 
ADDONS	= 

CC      = gcc

CFLAGS	= -Werror -fmax-errors=1 -O6 -Wall -g -ansi $(TYPE) $(ADDONS) 
# -g -pg

LIBS    = -lm

FLEX_FLAGS =

BISON_FLAGS =


####### Files

PDDL_PARSER_SRC	= scan-fct_pddl.tab.c \
	scan-ops_pddl.tab.c \
	scan-probname.tab.c \
	lex-fct_pddl.c \
	lex-ops_pddl.c 

PDDL_PARSER_OBJ = scan-fct_pddl.tab.o \
	scan-ops_pddl.tab.o 


SOURCES 	= main.c \
	memory.c \
	output.c \
	parse.c \
	inst_pre.c \
	inst_easy.c \
	inst_hard.c \
	inst_final.c \
	orderings.c \
	relax.c \
	search.c

OBJECTS 	= $(SOURCES:.c=.o)

####### Implicit rules

.SUFFIXES:

.SUFFIXES: .c .o

.c.o:; $(CC) -c $(CFLAGS) $<

####### Build rules


ff: $(OBJECTS) $(PDDL_PARSER_OBJ)
	$(CC) -o ff $(OBJECTS) $(PDDL_PARSER_OBJ) $(CFLAGS) $(LIBS)

# pddl syntax
scan-fct_pddl.tab.c: scan-fct_pddl.y lex-fct_pddl.c
	bison -pfct_pddl -bscan-fct_pddl $(BISON_FLAGS) scan-fct_pddl.y

scan-ops_pddl.tab.c: scan-ops_pddl.y lex-ops_pddl.c
	bison -pops_pddl -bscan-ops_pddl $(BISON_FLAGS) scan-ops_pddl.y

lex-fct_pddl.c: lex-fct_pddl.l
	flex --nounistd --header-file="lex-fct_pddl.tab.h" --prefix=fct_pddl --outfile="lex-fct_pddl.c" $(FLEX_FLAGS) lex-fct_pddl.l

lex-ops_pddl.c: lex-ops_pddl.l
	flex --nounistd --header-file="lex-ops_pddl.tab.h" --prefix=ops_pddl --outfile="lex-ops_pddl.c" $(FLEX_FLAGS) lex-ops_pddl.l


# misc
clean:
	rm -f *.o *.bak *~ *% core *_pure_p9_c0_400.o.warnings \
        \#*\# $(RES_PARSER_SRC) $(PDDL_PARSER_SRC)

veryclean: clean
	rm -f ff H* J* K* L* O* graph.* TIME* SEARCHTIME* *.symbex gmon.out \
	$(PDDL_PARSER_SRC) \
	lex-fct_pddl.c lex-ops_pddl.c lex.probname.c \
	*.output

depend:
	makedepend -- $(SOURCES) $(PDDL_PARSER_SRC)

lint:
	lclint -booltype Bool $(SOURCES) 2> output.lint

# DO NOT DELETE
