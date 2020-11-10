#use "../pc.ml";;
#use "../reader.ml";;
open PC;;

let nt_StringMetaChar = 
  (disj_list (
    word "\\\\"::
    word "\\t"::
    word "\\f"::
    word "\\n"::
    word "\\r"::[]
    ));;
      
let nt_StringLiteralChar = guard nt_any (fun(c)-> c != '"' && c != '\\');;

let nt_StringChar = disj nt_StringMetaChar (pack nt_StringLiteralChar (fun(a) -> a::[])) ;;

let nt_String = 
  let str = caten (char '\"') 
(caten (pack (star nt_StringChar) (fun (a) -> List.flatten(a))) (char '\"')) in
  pack str (fun(_, (a, _)) -> String(list_to_string a));;