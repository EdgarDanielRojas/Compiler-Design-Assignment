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

#include "CodeGen.h"

void createCodeEntry(entry_p des,enum operatorTypes op,entry_p arg1,entry_p arg2,int linenum){
 	entry_c temp = (entry_c) malloc(sizeof(codeEntry));
	temp->dest = des;
	temp->op = op;
	temp->arg1 = arg1;
	temp->arg2 = arg2;
	temp->linenum = linenum;
	g_ptr_array_add(codeArray,(gpointer) temp);
	cline++;
}

void getCodeEntry(){
	return;
}

GArray * copyArray(GArray * ar){
 	if(ar == NULL){
		return NULL;
	}
	int length = ar->len;
	gint num;
	GArray * newArr = g_array_new(FALSE,FALSE,sizeof(gint));
	for(int i=0; i<length;i++){
		num = g_array_index(ar,gint,i);
		g_array_append_val(newArr,num);
	}
	return newArr;
}


void backPatch(GArray * array, int line){
	if(array == NULL)
		return;
	int length = array->len;
	entry_c temp;
	int index;
	for(int i=0; i<length; i++){
		index = g_array_index(array,gint,i);
		temp = g_ptr_array_index(codeArray,index);
		temp->linenum = line;
	}
	return;
}

stmt_p createStmt(GArray * array){
 	stmt_p temp = (stmt_p) malloc(sizeof(stmth));
	temp->next = copyArray(array);
	return temp;
}

GArray * mergeList(GArray * array1,GArray * array2){
 	if(array1 == NULL){
		return copyArray(array2);
	}
	if(array2 == NULL){
		return copyArray(array1);
	}
	int length1 = array1->len;
	int length2 = array2->len;
	gint num;
	GArray * newArr = g_array_new(FALSE,FALSE,sizeof(gint));
	for(int i=0; i<length1;i++){
		num = g_array_index(array1,gint,i);
		g_array_append_val(newArr,num);
	}
	for(int i=0; i<length2;i++){
		num = g_array_index(array2,gint,i);
		g_array_append_val(newArr,num);
	}
	return newArr;
}

exp_p createExp(int t,int f,entry_p place){

	exp_p temp = (exp_p) malloc(sizeof(exph));
	GArray * newArr1 = g_array_new(FALSE,FALSE,sizeof(gint));
	GArray * newArr2 = g_array_new(FALSE,FALSE,sizeof(gint));
	g_array_append_val(newArr1,t);
	g_array_append_val(newArr2,f);
	temp->true = newArr1;
	temp->false = newArr2;
	temp->place = place;
	temp->next = NULL;
	return temp;
}

mn_p createMN(int next,int quad){
 	mn_p temp = (mn_p) malloc(sizeof(mnh));
	GArray * newArr = g_array_new(FALSE,FALSE,sizeof(gint));
	g_array_append_val(newArr,next);
	temp->quad = quad;
	temp->next = newArr;
	return temp;
}

void printCode(GPtrArray * code){
	int length = code->len;
	entry_c temp;
	for(int i =0; i<length; i++){
		temp = g_ptr_array_index(code,i);
		char *a1 = "NA";
		char *a2 = "NA";
		char *d = "NA";
		if(temp->dest != NULL)
			d = temp->dest->name_p;
		if(temp->arg1 != NULL)
			a1 = temp->arg1->name_p;
		if(temp->arg2 != NULL)
			a2 = temp->arg2->name_p;
		int lin = temp->linenum;
		printf("Instruccion #%d Type %s Dest %s Arg1 %s Arg2 %s Line %d\n",i,opType(temp->op),d,a1,a2,lin);
	}
}

char * opType(enum operatorTypes a){
  switch (a) {
    case ADDOP:       return "+";
    case SUBOP:   return "-";
    case DIVOP:       return "/";
    case MULOP: return "*";
    case LTOP:        return "<";
    case EQOP:        return "==";
    case GOTO:           return "JUMP";
    case ASSIGNOP:     return ":=";
    case READOP:          return "READ";
    case WRITEOP:         return "WRITE";
    default:             return "ERROR";
  }
}

void interpretCode(GPtrArray * code){
	int length = code->len;
	int i =0;
	while (i<length){
		entry_c temp;
		temp = g_ptr_array_index(code,i);
		entry_p dest = temp->dest;
		entry_p arg1 = temp->arg1;
		entry_p arg2 = temp->arg2;
		enum operatorTypes op = temp->op;
		int line = temp->linenum;
		switch (op) {
		case ADDOP:
				if(arg1->type == integer && arg2->type == integer){
					if (dest->type == integer) {
							dest->value.i_value = arg1->value.i_value + arg2->value.i_value;
					} else{
							dest->value.r_value = arg1->value.i_value + arg2->value.i_value;
						}
				}
				if(arg1->type == real && arg2->type == real){
					if (dest->type == integer) {
							dest->value.i_value = arg1->value.r_value + arg2->value.r_value;
					} else{
							dest->value.r_value = arg1->value.r_value + arg2->value.r_value;
						}
				}
				if(arg1->type == real && arg2->type == integer){
					if (dest->type == integer) {
							dest->value.i_value = arg1->value.r_value + arg2->value.i_value;
					} else{
							dest->value.r_value = arg1->value.r_value + arg2->value.i_value;
						}
				}
				if(arg1->type == integer && arg2->type == real){
					if (dest->type == integer) {
							dest->value.i_value = arg1->value.i_value + arg2->value.r_value;
					} else{
							dest->value.r_value = arg1->value.i_value + arg2->value.r_value;
						}
				}
				printf("ADDITION INSTRUCTION EXECUTED\n");
				i++;
				break;
		case SUBOP:
				if(arg1->type == integer && arg2->type == integer){
					if (dest->type == integer) {
							dest->value.i_value = arg1->value.i_value - arg2->value.i_value;
					} else{
							dest->value.r_value = arg1->value.i_value - arg2->value.i_value;
						}
				}
				if(arg1->type == real && arg2->type == real){
					if (dest->type == integer) {
							dest->value.i_value = arg1->value.r_value - arg2->value.r_value;
					} else{
							dest->value.r_value = arg1->value.r_value - arg2->value.r_value;
						}
				}
				if(arg1->type == real && arg2->type == integer){
					if (dest->type == integer) {
							dest->value.i_value = arg1->value.r_value - arg2->value.i_value;
					} else{
							dest->value.r_value = arg1->value.r_value - arg2->value.i_value;
						}
				}
				if(arg1->type == integer && arg2->type == real){
					if (dest->type == integer) {
							dest->value.i_value = arg1->value.i_value - arg2->value.r_value;
					} else{
							dest->value.r_value = arg1->value.i_value - arg2->value.r_value;
						}
				}
				printf("SUBTRACTION INSTRUCTION EXECUTED\n");
				i++;
				break;
		case DIVOP:
				if(arg2->type == integer){
					if(arg2->value.i_value == 0){
						printf("ERROR: DIVISION BY ZERO\n");
						exit(EXIT_FAILURE);
					}
				}
				if(arg2->type == real){
					if(arg2->value.r_value == 0.0){
						printf("ERROR: DIVISION BY ZERO\n");
						exit(EXIT_FAILURE);
					}
				}
				if(arg1->type == integer && arg2->type == integer){
					if (dest->type == integer) {
							dest->value.i_value = arg1->value.i_value / arg2->value.i_value;
					} else{
							dest->value.r_value = arg1->value.i_value / arg2->value.i_value;
						}
				}
				if(arg1->type == real && arg2->type == real){
					if (dest->type == integer) {
							dest->value.i_value = arg1->value.r_value / arg2->value.r_value;
					} else{
							dest->value.r_value = arg1->value.r_value / arg2->value.r_value;
						}
				}
				if(arg1->type == real && arg2->type == integer){
					if (dest->type == integer) {
							dest->value.i_value = arg1->value.r_value / arg2->value.i_value;
					} else{
							dest->value.r_value = arg1->value.r_value / arg2->value.i_value;
						}
				}
				if(arg1->type == integer && arg2->type == real){
					if (dest->type == integer) {
							dest->value.i_value = arg1->value.i_value / arg2->value.r_value;
					} else{
							dest->value.r_value = arg1->value.i_value / arg2->value.r_value;
						}
				}
				printf("DIVISION INSTRUCTION EXECUTED\n");
				i++;
				break;
		case MULOP:
				if(arg1->type == integer && arg2->type == integer){
					if (dest->type == integer) {
							dest->value.i_value = arg1->value.i_value * arg2->value.i_value;
					} else{
							dest->value.r_value = arg1->value.i_value * arg2->value.i_value;
						}
				}
				if(arg1->type == real && arg2->type == real){
					if (dest->type == integer) {
							dest->value.i_value = arg1->value.r_value * arg2->value.r_value;
					} else{
							dest->value.r_value = arg1->value.r_value * arg2->value.r_value;
						}
				}
				if(arg1->type == real && arg2->type == integer){
					if (dest->type == integer) {
							dest->value.i_value = arg1->value.r_value * arg2->value.i_value;
					} else{
							dest->value.r_value = arg1->value.r_value * arg2->value.i_value;
						}
				}
				if(arg1->type == integer && arg2->type == real){
					if (dest->type == integer) {
							dest->value.i_value = arg1->value.i_value * arg2->value.r_value;
					} else{
							dest->value.r_value = arg1->value.i_value * arg2->value.r_value;
						}
				}
				printf("MULTIPLICATION INSTRUCTION EXECUTED\n");
				i++;
				break;
		case ASSIGNOP:
				if(arg1->type == integer){
					if (dest->type == integer) {
							dest->value.i_value = arg1->value.i_value;
					} else{
							dest->value.r_value = arg1->value.i_value;
						}
				}
				if(arg1->type == real){
					if (dest->type == integer) {
							dest->value.i_value = arg1->value.r_value;
					} else{
							dest->value.r_value = arg1->value.r_value;
						}
				}
				printf("ASSIGNMENT INSTRUCTION EXECUTED\n");
				i++;
				break;
		case LTOP:
				if(arg1->type == integer && arg2->type == integer){
					if(arg1->value.i_value < arg2->value.i_value) {
							i = line;
					}else{
							i++;
						}
					}
				if(arg1->type == real && arg2->type == real){
					if(arg1->value.r_value < arg2->value.r_value) {
							i = line;
					}else{
							i++;
						}
				}
				if(arg1->type == real && arg2->type == integer){
					if(arg1->value.r_value < arg2->value.i_value) {
							i = line;
					}else{
							i++;
						}
				}
				if(arg1->type == integer && arg2->type == real){
					if(arg1->value.i_value < arg2->value.r_value) {
							i = line;
					}else{
							i++;
						}
				}
				break;
		case EQOP:
		if(arg1->type == integer && arg2->type == integer){
			if(arg1->value.i_value == arg2->value.i_value) {
					i = line;
			}else{
					i++;
				}
			}
		if(arg1->type == real && arg2->type == real){
			if(arg1->value.r_value == arg2->value.r_value) {
					i = line;
			}else{
					i++;
				}
		}
		if(arg1->type == real && arg2->type == integer){
			if(arg1->value.r_value == arg2->value.i_value) {
					i = line;
			}else{
					i++;
				}
		}
		if(arg1->type == integer && arg2->type == real){
			if(arg1->value.i_value == arg2->value.r_value) {
					i = line;
			}else{
					i++;
				}
		}
		break;
		case READOP:
				if(dest->type == integer){
					int temp = 0;
					scanf("%d",&temp);
					dest->value.i_value = temp;
				}
				else{
					float temp = 0.0;
					scanf("%f",&temp);
					dest->value.i_value = temp;
				}
				printf("READ OPERATION EXECUTED\n");
				i++;
				break;
		case WRITEOP:
				if (arg1->type == integer)
						printf("%d\n",arg1->value.i_value);
				else
						printf("%f\n",arg1->value.r_value);
				printf("WRITE INSTRUCTION EXECUTED\n");
				i++;
				break;
		case GOTO:
				i = line;
				break;
		default:
				printf(
						"CRITICAL ERROR: It seems it occured in QUAD = %d\n Check if you are not creating a loop in the test file", i);
		}
	}
}
