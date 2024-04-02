import ply.lex as lex

%{
    #include "definiciones.h"
    #include "tablaSimbolos/tablaSimbolos.h"
    #include "gestionErrores/gestionErrores.h"
    #include "tablasHash/tablaHash.h"
%}


%option noyywrap

/* ---------------- DEFINICIONES ----------------  */

/* Ponemos las definiciones básicas que nos proporciona python.org */
letra            [A-Za-z]
digit            [0-9]
nonzerodigit     [1-9]
binario          [01]
octal            [0-7]
hexadecimal      [0-9A-Fa-f]
espacio          [ \t]

/* ID */

ID               {letra}({letra}|{digit}|_)*

/* STRINGS */

stringescapeseq  "\\."
shortstringchar  [^\\]
longstringchar   [^\\\n]
longstringitem   [{longstringchar} | {stringescapeseq}]
shortstringitem  [shortstringchar | stringescapeseq]
shortstring      [\'{shortstringitem}*\' | \"{shortstringitem}*\"]
longstring       [\'\'\'{longstringitem}*\'\'\' | \"\"\"{longstringitem}*\"\"\"]
stringprefix      ("r"|"u"|"R"|"U"|"f"|"F"|"fr"|"Fr"|"fR"|"FR"|"rf"|"rF"|"Rf"|"RF")?
stringliteral    [{stringprefix}][{shortstring}|{longstring}]

/* INTEGERS */

decinteger       {nonzerodigit}([_]?{digit})* | "0"+([_]"0")*
bininteger       "0"[bB]([_]?{binario})+
octinteger       "0"[oO]([_]?{octal})+
hexinteger       "0"[xX]([_]?{hexadecimal})+
integer          ({decinteger} | {bininteger} | {octinteger} | {hexinteger})

/* FLOATS */

digitpart        {digit}([_]?{digit})*
fraction         "."{digitpart}
exponent         [eE][+-]?{digitpart}
pointfloat        ({digitpart}{fraction})|({digitpart}".")
exponentfloat     ({digitpart}|{pointfloat}){exponent}
floatnumber       {pointfloat}|{exponentfloat}
 
/* IMAGINARIOS */

imagnumber       ({floatnumber}|{digitpart})[jJ]

/* OPERADORES */

operadores        (\+\+|\-\-|\+|\-|\*{1,2}|\/{1,2}|\%|\@|\<\<|\>\>|\&|\||\^|\~|\:\=|\<|\>\=\<|\>\=|\=\=|\!\=)

/* DELIMITADORES */ 

delimitadores     (\(\)|\[\]|\{\}|,|:|\.|;|\@|\=|\->|\+=|\-=|\*=|\/=|\/\/=|\%=|\@=|\&=|\|=|\^=|>>=|<<=|\*\*=)

/* COMENTARIOS */
comentario        "#"[^\n]*

%%

{espacio}       ;    /* NO SE HACE NADA */
{comentario}    ;   /* NO SE HACE NADA */

{ID}            { return ID; }
{stringliteral} { return STRING; }
{nonzerodigit}([_]?{digit})* | "0"+([_]"0")*  { return NUM_INT; } /* Para decinteger */
"0"[bB]([_]?{binario})+                      { return NUM_INT; } /* Para bininteger */
"0"[oO]([_]?{octal})+                        { return NUM_INT; } /* Para octinteger */
"0"[xX]([_]?{hexadecimal})+                  { return NUM_INT; } /* Para hexinteger */
{floatnumber}    { return NUM_FLOAT; }
{imagnumber}    { return NUM_FLOAT; }
{operadores}    { return OP; }
{delimitadores} { return DEL; }
.               {return -1;}
<<EOF>>         {return EOF;}

%%

 /* ----------------  CODIGO C ----------------  */

// Abrimos el archivo
void abrirArchivo(char *nombreArchivo) {
    FILE *archivo = fopen(nombreArchivo, "r"); 
    if (archivo == NULL) {
        ficheroNoEncontrado(nombreArchivo); 
        exit(EXIT_FAILURE); 
    }
    yyin = archivo; 
}


int seguinte_comp_lexico(token *actual, hashTable *tabla) {
    actual->componente = yylex();

    if (actual->componente != 0) {
        actual->lexema = strdup(yytext);
        if (actual->componente == ID) {
            insertarElemento(*actual, tabla);
            return 1; 
        }
    }

    if (actual->componente != 0) return 1;

    return 0; 
}


void cerrarArchivo() {
    if (yyin != NULL) {
        fclose(yyin); 
        yyin = NULL; 
    }
    yylex_destroy();
}
