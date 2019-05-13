/**
 *
 *
 * @file    UserDefined.c
 *
 * @author  Edgar Daniel Rojas Vazquez
 *
 * @date    Mon 18 Feb 2019
 *
 * @brief   Implements all the user defined functions for handling the
 *          specific user-defined data structure that is pointed to
 *          by the doubly linked list node.
 *
 * References:
 *          Code loosely based on my Generic Singly linked list algorithm.
 *
 * Revision history:
 *          Mon 18 Feb 2019 -- File created
 *
 * @warning If there is not enough memory to create a node or the hash
 *          management fails the related function indicates failure.
 *          If the DEBUG compiler flag is set then the program will terminate
 *          but more information is displayed indicating the source of error.
 *
 *
 */

#include "UserDefined.h"

/**
 *
 * @brief Prints the contents of the symbol table entry.
 *
 * @b PrintItem will print each field according to the user's formatting.
 *
 * @param  theEntry_p is a pointer to a user-defined structure element.
 *
 * @return @c EXIT_SUCCESS the item was printed with no
 *         problems, otherwise return @c EXIT_FAILURE
 *
 * @code
 *  PrintItem(theEntry_p);
 * @endcode
 *
 */
int PrintItem (entry_p theEntry_p){
	if(theEntry_p->type == integer) {
	    printf("%s \t %s \t %d \t %d\n",theEntry_p->name_p, "INTEGER",theEntry_p->lineNumber,theEntry_p->value.i_value);
  	}
	else {
	    printf("%s \t %s \t %d \t %f\n",theEntry_p->name_p, "FLOAT  ",theEntry_p->lineNumber,theEntry_p->value.r_value);
	}
	return(EXIT_SUCCESS);
}

/**
 *
 * @brief Captures the key, value and data pointers from @c g_hash_foreach
 * and calls PrintItem for each element.
 *
 * @b SupportPrint is a support function that captures the key, value and
 * data pointers from @c g_hash_foreach and in turn calls @c PrintItem to
 * display each hash entry.
 *
 * @param  key_p pointer to the key
 * @param  value_p pointer to the value
 * @param  user_p pointer to the user defined data
 * @return @c void
 *
 * @code
 *  g_hash_table_foreach(theTable_p, (GHFunc)SupportPrint, NULL);
 * @endcode
 *
 */
void SupportPrint (gpointer key_p, gpointer value_p, gpointer user_p){
	entry_p temp = (entry_p) value_p;
	PrintItem(temp);
}

/**
 *
 * @brief Prints all the elements of a table.
 *
 * @b PrintTable will print all the elements of @p table_p. It calls
 * the user-defined function PrintItem which handles the format of the data
 * portion of the items in the table.
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
 * @warning This function @b requires a user-defined function to do the
 *          actual printing of the data element.
 *
 */
int PrintTable (GHashTable * theTable_p){
	g_hash_table_foreach(theTable_p, (GHFunc)SupportPrint, NULL);
	return EXIT_SUCCESS;
}

/**
 *
 * @brief Allocates memory to a node of the user-defined data structure.
 *
 * @b NewItem will allocate space for the @c varName_p string and set the
 * fields of the @c tableEntry structure.
 *
 * @param  varName_p is the input string which is copied by NewItem.
 * @param  type is the variable type (integer or real).
 * @param  scope is the scope of the variable.
 * @param  lineNumber line where the variable was declared.
 *
 * @return @c entry_p pointer to the memory block that holds the newly created
 *         symbol table entry. The 32-bit value for the variable is set to
 *         zero.
 *
 * @code
 *  newNode_p = NewItem("someVariable", integer, 0, 13, 27);
 * @endcode
 *
 */
entry_p NewItem (char * varName_p, enum myTypes type,
                 unsigned int lineNumber){
	entry_p temp = g_hash_table_lookup(SymbolTable,varName_p);
	if(temp == NULL){
		temp = (entry_p) malloc(sizeof(tableEntry));

		temp->name_p = g_strdup(varName_p);
		temp->type = type;
		temp->lineNumber = lineNumber;
		if(type == integer)
			temp->value.i_value = 0;
		else
			temp->value.r_value = 0.0;
		  /* Will add the value and type correcty in a more advanced implementation */
		  //new_node->value = 0;
		if(g_hash_table_insert(SymbolTable, temp->name_p, temp)) {
			return temp;
		}
		else {
		    printf("Error: While inserting the node");
				return NULL;
		    //exit(EXIT_FAILURE);
		}
	}
	return temp;
}

/**
 *
 * @brief Finds node by name in the user-defined data structure.
 *
 * @b FindItem will find the node in the hash table and return the result.
 *
 * @param  varName_p is the name of the node.
 *
 * @return @c entry_p pointer to the memory block that holds the newly created
 *         symbol table entry. The 32-bit value for the variable is set to
 *         zero.
 *
 * @code
 *  Node_p = FindItem("someVariable");
 * @endcode
 *
 */
entry_p FindItem (char * varName_p){
	entry_p temp = g_hash_table_lookup(SymbolTable, varName_p);

	if(temp != NULL){
		return temp;
	}
	else {
	    return NULL;
	}
}

/**
 *
 * @brief Updates a symbol's information
 *
 * @b The UpdateItem function looks for the symbol in the hashtable
 *    and then updates the information contained
 *
 * @param  identifier_name is a string that indicates the name of the
 *         symbol.
 *         type is the enum type of the symbol (either INT [0] of FLT [1])
 *         value is the contained value for that variable (has the fields
*          integer_value and float_value)
 *
 * @code
 *  UpdateSymbol(identifier_name, FLT, 12.12);
 * @endcode
 *
 */
entry_p UpdateItem(char * varName_p, enum myTypes type, uVal v){
	entry_p node = g_hash_table_lookup(SymbolTable, varName_p);
	if(node != NULL) {
		node->type = type;
		if(type==integer){

			node->value.i_value = v.i_value;
		}
		else{
			node->value.r_value = v.r_value;
		}
	}
	return node;
}

/**
 *
 * @brief De-allocates memory assigned to user-defined data structure.
 *
 * @b FreeItem will de-allocate the @c string inside the user-defined data
 * structure @c tableEntry.
 *
 * @param  theEntry_p is a pointer to the user-defined data structure.
 * @return @c EXIT_SUCCESS if the item was de-allocated with no
 *         problems, otherwise return @c EXIT_FAILURE.
 *
 * @code
 *  FreeItem(theEntry_p);
 * @endcode
 *
 * @warning This function must be passed as a parameter when calling
 *          DestroyTable() since it will call it to de-allocate the
 *          user-defined structure.
 */
int FreeItem (entry_p theEntry_p){
	free(theEntry_p->name_p);
	free(theEntry_p);
	return(EXIT_SUCCESS);
}

/**
 *
 * @brief De-allocates memory assigned to each user-defined data structure in
 *        the hash table.
 *
 * @b DestroyTable will de-allocate the user-defined data structure. It also
 *    deallocates memory for the hash table.
 *
 * @param  theTable_p is a pointer to the hast table.
 * @return @c EXIT_SUCCESS if the list was de-allocated with no problems,
 *         otherwise return @c EXIT_FAILURE
 *
 * @code
 *  DestroyList(theList_p);
 * @endcode
 *
 * @see FreeItem()
 *
 */
int DestroyTable (GHashTable * theTable_p){
	g_hash_table_destroy(theTable_p);
	return(EXIT_SUCCESS);
}

/**
 *
 * @brief Creates a new temporary constant
 *
 * @b The createTempConstant creates a new temporary constant and adds it
 *    to the symbol table for better handling the operations within the
 *    code
 *
 * @param  value is the numerical value to be assigned to the temp (either
 *         integer_value or float_value)
 *         type is the enum containing the type for the constant (either FLT
 *         or INT)
 *
 * TODO: Handle the usage of temps
 *
 * @code
 *  createTempConstant(12.12, FLT);
 * @endcode
 *
 */
entry_p createTempConstant(uVal value, enum myTypes type) {
  char * temp = malloc(sizeof(char *));
  char * c = malloc(sizeof(char *));
  int i=0;
  // Assign the correct temp name
  do {
    sprintf(temp, "t");
    snprintf(c, sizeof(char *), "%d", i);
    strcat(temp, c);
    i++;
  } while (FindItem(temp) != NULL);
  entry_p item = NewItem(temp,type,0);
  UpdateItem(temp, type, value);
	return item;
}
