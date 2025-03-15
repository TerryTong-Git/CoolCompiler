/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */
%}

%x comment
int line_num = 1;

/*
 * Define names for regular expressions here.
 */

DARROW          =>
DIGIT           [0-9]+
CLASS           ?:class
ELSE            ?:else
FI              ?:fi
IF              ?:if
IN              ?:in
INHERITS        ?:inherits
LET             ?:let
LOOP            ?:loop
POOL            ?:pool
THEN            ?:then
WHILE           ?:while
ASSIGN          ?:assign
CASE            ?:case
ESAC            ?:esac
OF              ?:of
NEW             ?:new
LE              ?:le
NOT             ?:not
ISVOID          ?:isvoid
STR_CONST       ?:str_const
INT_CONST       ?:int_const
ERROR           ?:error

TRUE            t(?:rue)
FALSE           f(?:alse)

TYPEID          [A-Z][A-Za-z0-9_]*
OBJECTID        [a-z][A-Za-z0-9_]*
SELF            self
SELF_TYPE       SELF_TYPE

ADD             \+
DIVIDE          \/
SUBTRACT        -
MULTIPLY        \*
EQUALS          =
LESSTHAN        <
DOT             \.
TILDE           ~
COMMA           ,
SEMICOLON       ;
COLON           :
LEFTPAREN       \(
RIGHTPAREN      \)
AT              @
LEFTBRACE       \{
RIGHTBRACE      \}

STRING          "[\\n|\\f|\\b|\\t|~[\n\f\b\t\0]]*"
SPACE           [ \n\f\b\t\r\v]+
COMMENT         --.*--
%%

 /*
  *  Nested comments, need to choose between comment and the mul, comment can have apostrophe, cannot end a file without closing the comment.
  */




 /*
  *  The multiple-character operators.
  */
{DARROW}		{ return (DARROW); }

 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */

{CLASS}           {return (CLASS);}
{ELSE}            {return (ELSE);}
{FI}              {return (FI);}
{IF}              {return (IF);}
{IN}              {return (IN);}
{INHERITS}        {return (INHERITS);}
{LET}             {return (LET);}
{LOOP}            {return (LOOP);}
{POOL}            {return (POOL);}
{THEN}            {return (THEN);}
{WHILE}           {return (WHILE);}
{ASSIGN}          {return (ASSIGN);}
{CASE}            {return (CASE);}
{ESAC}            {return (ESAC);}
{OF}              {return (OF);}
{NEW}             {return (NEW);}
{LE}              {return (LE);}
{NOT}             {return (NOT);}
{ISVOID}          {return (ISVOID);}
{TRUE}            {return (BOOL_CONST);}
{FALSE}           {return (BOOL_CONST);}
{DIGIT}           {cool_yylval.symbol = inttable.add_string(yytext); return (INT_CONST);}
{TYPEID}          {cool_yylval.symbol = idtable.add_string(yytext); return (TYPEID);}
{SELF}            {cool_yylval.symbol = idtable.add_string(yytext); return (OBJECTID);}
{SELF_TYPE}       {cool_yylval.symbol = idtable.add_string(yytext); return (TYPEID);}
{OBJECTID}        {cool_yylval.symbol = idtable.add_string(yytext); return (OBJECTID);}

{ADD}             {return (43);}
{DIVIDE}          {return (47);}
{SUBTRACT}         {return (45);}
{MULTIPLY}         {return (42);}
{EQUALS}           {return (61);}
{LESSTHAN}         {return (60);}
{DOT}              {return (46);}
{TILDE}            {return (126);}
{COMMA}            {return (44);}
{SEMICOLON}        {return (59);}
{COLON}            {return (58);}
{LEFTPAREN}        {return (40);}
{RIGHTPAREN}       {return (41);}
{AT}               {return (64);}
{LEFTBRACE}        {return (123);}
{RIGHTBRACE}       {return (125);}
{SPACE}            /*eat */
{STRING}           {cool_yylval.symbol = stringtable.add_string(yytext); return (STR_CONST);}
{COMMENT}          /*eat */

"*"                 BEGIN(comment);
<comment>[^*\n]*
<comment>"*"+[^*/\n]*
<comment>\n         ++line_num;
<comment>"*"+"/"    BEGIN(INITIAL);

 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */


%%
