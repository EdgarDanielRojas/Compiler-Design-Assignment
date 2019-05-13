/**
 *
 *
 * @file    codeGen.c
 *
 * @author  Edgar Daniel Rojas Vazquez
 *
 * @date    Thu 09 May 2019
 *
 * @brief   Implements all the functions for handling the generation
 *          of code and the handling of the linked list that contains
 *          the code.
 *
 * References:
 *
 * Revision history:
 *          Thu 09 MAY 2019 -- File created
 *
 * @warning If there is not enough memory to create a node
 *          the related function indicates failure.
 *          If the DEBUG compiler flag is set then the program will terminate
 *          but more information is displayed indicating the source of error.
 *
 *
 */

 #include "UserDefined.h"
 #include <glib.h>
 #include <stdlib.h>
 #include <string.h>
 #include <stdio.h>

 /**
  * @enum operatorTypes
  *
  * @brief This is the basic operators available for our code
  *
  *
  */
enum operatorTypes {GOTO,ASSIGNOP,READOP,WRITEOP,LTOP,EQOP,ADDOP,SUBOP,MULOP,DIVOP};

/**
 * @struct codeEntry
 *
 * @brief This is the user-defined symbol table entry.
 *
 * @c TableEntry is the user-defined structure that describes a symbol table
 * entry. Each entry has the following fields:
 *
 * @c name_p is a string holding the name of the variable. This may be
 *    different from the hash key (the key is the variable name plus the
 *    value of the current context).
 *
 * @c type indicates if the variable is integer or float.
 *
 * @c scope is an integer indicating the symbol table entry scope.
 *
 * @c lineNumber is the line number where the variable was defined.
 *
 * @c value is a union of all possible values (integer/float). Not space
 *    efficient if smaller types are allowed.
 *
 */
typedef struct codeEntry_{
   entry_p                dest;       /**< Entry in which to save result */
   enum operatorTypes     op;         /**< Operator type */
   entry_p                arg1;       /**< First argument for operator */
   entry_p                arg2;       /**< Second argument for operator */
   int                    linenum;    /**< Line number to jump to */
}codeEntry;

/**
 * @typedef entry_c
 *
 * @brief declare a pointer to the @c codeEntry @c structure
 */
typedef struct codeEntry_ *entry_c; /**< Declaration of ptr to a code entry */

typedef struct stmtHelper{
  GArray * next;
} stmth;

typedef struct stmtHelper * stmt_p;

typedef struct expHelper{
  entry_p place;
  GArray * true;
  GArray * false;
  GArray * next;
} exph;

typedef struct expHelper * exp_p;

typedef struct mnHelper{
  int quad;
  GArray * next;
} mnh;

typedef struct mnHelper * mn_p;

/**
 * Global codearray variable
*/
GPtrArray * codeArray;

int cline;

/**
 *
 * @brief Creates a code entry in our dynamic array.
 *
 * @b CreateCodeEntry will create a struct of type codeEntry
 *    and insert it into our GArray code array.
 *
 * @param  theTable_p pointer to the table to be printed.
 * @return @c EXIT_SUCCESS if the table was traversed with no
 *         problems, otherwise return @c EXIT_FAILURE.
 *
 * @code
 *  if (PrintTable(theTable_p) != EXIT_SUCCESS)
 *  printf("Error printing the symbol table\n");
 * @endcode
 *
 *
 */
void createCodeEntry(entry_p des,enum operatorTypes op,entry_p arg1,entry_p arg2,int linenum);

void getCodeEntry();

GArray * copyArray(GArray * ar);

void backPatch(GArray * array,int line);

stmt_p createStmt(GArray * array);

GArray * mergeList(GArray * array1,GArray * array2);

exp_p createExp(int t,int f,entry_p place);

mn_p createMN(int next,int quad);

void printCode(GPtrArray * code);

char * opType(enum operatorTypes a);

void interpretCode(GPtrArray * code);
