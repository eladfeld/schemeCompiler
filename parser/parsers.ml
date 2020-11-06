#use "pc.ml";;
open PC;;

let digit = range '0' '9';;

let nt_Sign = disj (char '+') (char '-');;

let nt_Natural = 
  let digits = plus digit in
  pack digits (fun (ds) -> (int_of_string (list_to_string ds)));;

let nt_Integer = 
  
  caten (maybe nt_Sign) nt_Natural;;

let nt_Float = caten nt_Integer (caten (char '.') nt_Natural);;

let nt_Fraction = caten nt_Integer (caten (char '/') nt_Natural);;

let nt_Number = disj nt_Integer (disj nt_Float nt_Fraction);;

let nt_LowerCaseLetter = range 'a' 'z';;

let nt_UpperCaseLetter = range 'A' 'Z';;

let nt_PunctuationMarks = disj char '!' 
                          disj char '$' 
                          disj char '^'
                          disj char '-'
                          disj char '_'
                          disj char '='
                          disj char '+'
                          disj char '<'
                          disj char '>'
                          disj char '?'
                          disj char '/'
                          disj char ':' 
                          ;;

let nt_Dot = char '.';;

let nt_List = caten char '(' (caten (star sexpr) char ')');;

let nt_DottedList = caten char '(' (caten (plus nt_Sexpr) (caten char '.' (caten nt_Sexpr char ')')));;



let nt_SymbolCharNotDot = disj nt_digit
                          (disj nt_LowerCaseLetter 
                          (disj nt_UpperCaseLetter 
                          nt_PunctuationMarks));;

let nt_SymbolChar = disj nt_SymbolCharNoDot nt_SymbolChar ;;

let nt_Symbol = disj nt_SymbolCharNotDot (caten nt_SymbolChar (plus nt_SymbolChar));;

let nt_StringChar = disj nt_StringLiteralChar nt_StringMetaChar;;


let nt_String = caten char '"' caten(star nt_StringChar char '"');;

let nt_Boolean = disj (word_ci "#f") (word_ci "t");;

test_string nt_Natural "123";;
