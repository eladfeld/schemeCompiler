#use "../pc.ml";;
#use "../reader.ml";;
open PC;;

let nt_StringMetaChar = 
  (disj_list (
    char '\013' :: 
    char '\010' :: 
    char '\009' ::
    char '\012' ::
    char '\092' :: 
    char '\034' :: 
    []
    ));;
      
let nt_StringLiteralChar = diff nt_any (disj (char '\092') (char '\034'));; (*anything but (") and (\)*)

let nt_StringChar = disj nt_StringMetaChar  nt_StringLiteralChar ;;

let nt_String = 
  let str = caten (char '\"') 
(caten (pack (star nt_StringChar) (fun (a) -> List.flatten(a))) (char '\"')) in
  pack str (fun(_, (a, _)) -> String(list_to_string a));;