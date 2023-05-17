import compilerTools.Token;

%%
%class Lexer
%type Token
%line
%column
%{
    private Token token(String lexeme, String lexicalComp, int line, int column){
        return new Token(lexeme, lexicalComp, line+1, column+1);
    }
%}
/* Variables básicas de comentarios y espacios */
TerminadorDeLinea = \r|\n|\r\n
EntradaDeCaracter = [^\r\n]
EspacioEnBlanco = {TerminadorDeLinea} | [ \t\f]
ComentarioTradicional = "/*" [^*] ~"*/" | "/*" "*"+ "/"
FinDeLineaComentario = "//" {EntradaDeCaracter}* {TerminadorDeLinea}?
ContenidoComentario = ( [^*] | \*+ [^/*] )*
ComentarioDeDocumentacion = "/**" {ContenidoComentario} "*"+ "/"

/* Comentario */
Comentario = {ComentarioTradicional} | {FinDeLineaComentario} | {ComentarioDeDocumentacion}

/* Identificador */
Letra = [A-Za-zÑñ_ÁÉÍÓÚáéíóúÜü]
Real = {Letra}(\,{Letra})*
Digito = [0-9]
Cadena = \"{Letra}({Letra}|{Digito})*\"

/* Número */
Numero = 0 | [1-9][0-9]*
%%

/*CADENA*/
{Cadena} { return token(yytext(), "CADENA", yyline, yycolumn); }
cadena { return token(yytext(), "IDENTIFICADOR_CADENA", yyline, yycolumn); }

/*ENTERO*/
{Numero} { return token(yytext(), "ENTERO", yyline, yycolumn); }
numero { return token(yytext(), "IDENTIFICADOR_NUMERO", yyline, yycolumn); }

/*REAL*/
{Real} { return token(yytext(), "REAL", yyline, yycolumn); }
real { return token(yytext(), "IDENTIFICADOR_REAL", yyline, yycolumn); }

Declare { return token(yytext(), "DECLARE", yyline, yycolumn); }


/* Comentarios o espacios en blanco */
{Comentario}|{EspacioEnBlanco} { /*Ignorar*/ }



/* OPERACION AGRUPACION*/
"(" {return token(yytext(), "PAR_ABRE", yyline, yycolumn);}
")" {return token(yytext(), "PAR_CIERRA", yyline, yycolumn);}
"{" {return token(yytext(), "LLAVE_ABRE", yyline, yycolumn);}
"}" {return token(yytext(), "LLAVE_CIERRA", yyline, yycolumn);}

/* SIGNOS_DE_PUNTUACIO*/
"," {return token(yytext(), "coma", yyline, yycolumn);}
";" {return token(yytext(), "punto_coma", yyline, yycolumn);}

/* op_asignacion*/
"=" {return token(yytext(), "op_asignacion", yyline, yycolumn);}
/*op_logicos*/

SI  {return token(yytext(), "SI", yyline, yycolumn);}
 SINO {return token(yytext(), "SINO", yyline, yycolumn);}

FSI {return token(yytext(), "FINSI", yyline, yycolumn);}


/*operadores*/
"<"|">"|"=="|"<="|">="|"++"|"--" {return token(yytext(), "OPERADORES", yyline, yycolumn);}

/*errores*/




0{Numero} {return token(yytext(), "ERROR_2", yyline, yycolumn);}


. { return token(yytext(), "ERROR", yyline, yycolumn); }