#use "../pc.ml";;
#use "../reader.ml";;
#use "numbersParser.ml";;
open PC;;



let nt_Dot = (char '.');;

let nt_Letter = range_ci 'a' 'z';;

let nt_PunctuationMarks = disj_list 
  (char '!' :: 
  char '$' ::
  char '^' ::
  char '-' ::
  char '_' ::
  char '=' ::
  char '+' ::
  char '<' ::
  char '>' ::
  char '?' ::
  char '/' ::
  char ':' ::[]);;


let nt_SymbolCharNotDot = disj digit 
                         (disj nt_Letter nt_PunctuationMarks));;

let nt_SymbolChar = disj nt_SymbolCharNotDot nt_Dot ;;

let nt_Symbol = 
  let sym = disj  
      (pack (caten nt_SymbolChar (plus nt_SymbolChar)) (fun(a, b) -> a::b))
      (pack nt_SymbolCharNotDot (fun(a)->a::[]))
       in 
    pack sym(
      fun(a)->
      Symbol(list_to_string (List.map lowercase_ascii a))
    );;

