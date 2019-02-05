# Compiler-Design-Assignment
Project that is meant to show us how to program a compiler for class TC3048 Compiler Design given by Abelardo Lopez Laguna. I will include his project specification in the next section. It is note worthy that the project is divided in phases and I will make folders with each phase.

# Programming Project Description

 

The programming project will require planning to finish it on schedule. The following is a brief description of the requirements for each of the stages. Some hints and suggestions are given, but you are not required to follow them. If you do not understand the technical terms don’t worry, we will cover those during the course.

## Phase 1

### Lexical Analyzer (Scanner)

 This part of the translator takes the input program, extracts and encodes the relevant information required for the rest of the translation process. You need to decide the representation of the tokens using regular expressions. Refer to the tiny-C language definition later on this document that describes the tokens of the language.

 A lexical generator (flex) is suggested for this section of your project. During the first month of the course, several examples on how to use flex will be given. This is the easiest part of the project and should be enough for you to make you comfortable with the development tools.

During this phase it is recommended that you also implement the symbol table management routines of your code. Use of dynamic data structures, such as hash tables, is required but you can use static tables to make this part of your project work. Full credit will be given at the end of the syntactical analyzer if you use dynamic data structures.

 

### Syntactical Analyzer (Parser)

Based on the stream of tokens from the lexical analyzer and on the grammar of the language, the syntactical analyzer will decide if the input program is syntactically correct. The output of this stage should detect any errors found in the input program. Although error correction is preferred, you should focus your efforts on error detection first.

During the course a parser generator (bison) will be covered. Based on the grammar definition you should convert it to a format amenable to bison. This part of the project is more complicated if you decide to use error correction. Extra credit will be given if you use error correction.

## Phase 2

### Semantic Analysis

 In this course we will use syntax-oriented translation to generate intermediate code for the interpreter, thus the semantic analysis and code generation are done at the same time.

The semantic analysis is responsible for type checking and type conversion as well as checking for correct declaration of identifiers. This will require extensive symbol table management so make sure you have implemented your symbol table management routines before you start working on the semantic analysis.

## Phase 2

### Code generation

The intermediate code generation is the most time-consuming part of the project so please don’t underestimate it. This part of the project will generate quadruples for each of the code segments analyzed so far. You can use back patching to generate correct jump addresses or you can generate an output file and then process the jump targets separately. The output file of this process should contain a list of valid quadruples, defined by you, and serve as input to the interpreter. The class notes propose a format for the quadruples, but feel free to modify them to suit your own needs.

 

### Interpreter

This is the final stage of your project. You must execute the output of the intermediate code generation in a pseudo virtual machine. This virtual machine must be capable of reading from the keyboard and displaying the information on the screen. Rudimentary memory management should also be implemented. 

This part of the project is not that complex and can be done in a short time, provided you fully understand what your quadruples do. Unfortunately in past projects this portion is rarely done because teams start the project late.

# Grammar Used (tiny-C)
program    ⇒ var_dec stmt_seq

var_dec    ⇒ var_dec single_dec

           | ε

single_dec ⇒ type ID SEMI

type       ⇒ INTEGER

           | FLOAT

stmt_seq   ⇒ stmt_seq stmt 

           | ε

stmt       ⇒ IF exp THEN stmt

           | IF exp THEN stmt ELSE stmt

           | WHILE exp DO stmt

           | variable ASSIGN exp SEMI

           | READ LPAREN variable RPAREN SEMI

           | WRITE LPAREN exp RPAREN SEMI

           | block

block      ⇒ LBRACE stmt_seq RBRACE

exp        ⇒ simple_exp LT simple_exp

           | simple_exp EQ simple_exp

           | simple_exp

simple_exp ⇒ simple_exp PLUS term

           | simple_exp MINUS term

           | term

term       ⇒ term TIMES factor

           | term DIV factor

           | factor

factor     ⇒ LPAREN exp RPAREN

           | INT_NUM

           | FLOAT_NUM

           | variable

variable   ⇒ ID


