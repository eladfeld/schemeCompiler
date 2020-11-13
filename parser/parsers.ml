#use "../pc.ml";;
#use "../reader.ml";;
#use "numberParser.ml";;
#use "stringParser.ml";;
#use "symbolParser.ml";;
open PC;;

let parse_True = 
  let tru  = word_ci "#t" in
   pack tru 
     (fun(a) ->
     Bool(true));;

let parse_False = 
  let tru  = word_ci "#f" in
   pack tru 
     (fun(a) ->
     Bool(false));;

let nt_Boolean = disj parse_False parse_True;;

let nt_VisibleSimpleChar = guard nt_any (fun(c)-> c > ' ');;

let nt_NamedChar = disj_list 
  (pack (word_ci "newline") (fun _-> char_of_int (10))::
   pack (word_ci "nul") (fun _-> char_of_int (0))::
   pack (word_ci "page") (fun _-> char_of_int(12)) ::
   pack (word_ci "return") (fun _-> char_of_int(13)) :: 
   pack (word_ci "space") (fun _-> char_of_int(32)) ::
   pack (word_ci "tab") (fun _ -> char_of_int(9)) :: []);;

let nt_Char = pack (caten (word "#\\") (disj nt_NamedChar nt_VisibleSimpleChar)) (fun (_, c) -> Char(c));;

let nt_WhiteSpace = range (char_of_int 0) ' ';;

let nt_WhiteSpaces = star nt_WhiteSpace;;

let make_paired nt_left nt_right nt =
  let nt = caten nt_left nt in
  let nt = pack nt (function (_, e) -> e) in
  let nt = caten nt nt_right in
  let nt = pack nt (function (e, _) -> e) in
    nt;;

let make_spaced nt = make_paired nt_WhiteSpaces nt_WhiteSpaces nt;;

let rec list_to_pair = fun(lst) ->
match lst with 
| car::cdr -> Pair(car, (list_to_pair cdr))
| x -> Nil;;

let rec nt_sexpr s= 
  let nt_sexpr = 
  make_spaced(disj_list 
  (nt_Boolean::  
  nt_Char::       
  nt_Number::     
  nt_String::     
  nt_Symbol::
  nt_List s::
  nt_DottedList s::
  nt_Quoted s::     
  nt_QuasiQuoted s::
  nt_Unquoted s::   
  nt_UnquoteAndSpliced s::[]
  )) in nt_sexpr s
  and nt_List s = 
    pack( caten (char '(') 
            (caten (star nt_sexpr) (char ')'))) (fun (_, (a, _))->list_to_pair a)
  and nt_DottedList s= 
    pack
      (caten (char '(') 
          (caten (plus nt_sexpr) 
            (caten (char '.') 
            (caten nt_sexpr (char ')'))))) (fun (_, (ls, (_, (rs, _))))-> list_to_pair (List.append ls (rs::[])))
  and nt_Quoted s= pack (caten (char (char_of_int 39)) nt_sexpr)
      (fun (_, (sexp)) -> Pair(Symbol("quote") , Pair(sexp, Nil)))

  and nt_QuasiQuoted s= pack (caten (char '`') nt_sexpr)
    (fun (_, (sexp)) -> Pair(Symbol("quasiquote") , Pair(sexp, Nil)))

  and nt_Unquoted s= pack (caten (char ',') nt_sexpr)
    (fun (_, (sexp)) -> Pair(Symbol("unquote") , Pair(sexp, Nil)))

  and nt_UnquoteAndSpliced s= pack (caten (word ",@") nt_sexpr)
    (fun (_, (sexp)) -> Pair(Symbol("unquote-splicing") , Pair(sexp, Nil)));;