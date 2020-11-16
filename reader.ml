
#use "pc.ml";;
open PC;;

  exception X_not_yet_implemented;;
  exception X_this_should_not_happen;;
    
  type number =
    | Fraction of int * int
    | Float of float;;
    
  type sexpr =
    | Bool of bool
    | Nil
    | Number of number
    | Char of char
    | String of string
    | Symbol of string
    | Pair of sexpr * sexpr;;

  let rec sexpr_eq s1 s2 =
    match s1, s2 with
    | Bool(b1), Bool(b2) -> b1 = b2
    | Nil, Nil -> true
    | Number(Float f1), Number(Float f2) -> abs_float(f1 -. f2) < 0.001
    | Number(Fraction (n1, d1)), Number(Fraction (n2, d2)) -> n1 = n2 && d1 = d2
    | Char(c1), Char(c2) -> c1 = c2
    | String(s1), String(s2) -> s1 = s2
    | Symbol(s1), Symbol(s2) -> s1 = s2
    | Pair(car1, cdr1), Pair(car2, cdr2) -> (sexpr_eq car1 car2) && (sexpr_eq cdr1 cdr2);;
    
  
(*-------------------------------------helper functions-------------------------------------*)
  let rec gcd a b = 
    if a = 0 then b
    else gcd (b mod a) a;;

  let float_of_char c = 
      let num = (int_of_char c)-(int_of_char '0') in
        float_of_int num;;

  let rec list_to_proper_list = fun(lst) ->
    match lst with 
    | car::cdr -> Pair(car, (list_to_proper_list cdr))
    | x -> Nil;;

  let rec list_to_improper_list = fun (lst) ->
    match lst with
    | [] -> Nil
    | first :: [] -> Pair(first,Nil)
    | first :: second :: [] -> Pair(first,second)
    | first :: rest -> Pair(first,list_to_improper_list rest);;

  let make_paired nt_left nt_right nt =
    let nt = caten nt_left nt in
    let nt = pack nt (function (_, e) -> e) in
    let nt = caten nt nt_right in
    let nt = pack nt (function (e, _) -> e) in
      nt;;

  let nt_notEndOfLine = guard nt_any (fun(c) -> c != '\n') ;;

  let nt_LineComment = pack 
                      (caten (char ';') (caten (star nt_notEndOfLine) (maybe (char '\n')))) 
                      (fun(_,(list_of_char, _)) -> '_');;

  let nt_WhiteSpace = range (char_of_int 0) ' ';;
(*-------------------------------------Boolean----------------------------------------------*)
  let nt_False = pack (word_ci "#f") (fun _ -> Bool(false));;
  let nt_True = pack (word_ci "#t") (fun _ -> Bool(true));;
  let nt_Boolean = disj nt_False nt_True;;


(*-------------------------------------Char-------------------------------------------------*)

  let nt_CharPrefix = word "#\\";; 
  let nt_VisibleSimpleChar = guard nt_any (fun c -> c > ' ');;
  let nt_NamedChar = disj_list 
                      (pack (word_ci "newline") (fun _ -> char_of_int(10)) :: 
                      pack (word_ci "nul") (fun _-> char_of_int(0)) ::
                      pack (word_ci "page") (fun _-> char_of_int(12)) ::
                      pack (word_ci "return") (fun _-> char_of_int(13)) :: 
                      pack (word_ci "space") (fun _-> char_of_int(32)) ::
                      pack (word_ci "tab") (fun _->char_of_int(9)) :: []);;

  let nt_Char = pack (caten nt_CharPrefix (disj nt_NamedChar nt_VisibleSimpleChar)) (fun (_,c) -> Char(c));;

(*-------------------------------------Number-----------------------------------------------*)
  let digit = range '0' '9';;

  let nt_Sign = 
    let sign =maybe (disj (char '+') (char '-')) in
    pack sign 
    (
      fun (s) ->
        match s with 
        | Some('+') -> 1
        | Some('-') -> -1
        | None -> 1
        | _ -> raise X_no_match
    )
    ;;

  let nt_Natural = 
      let digits = plus digit in
        pack digits (fun (ds) -> (int_of_string (list_to_string ds)));;

  let nt_Mantissa = 
    let mantissa = plus digit in
      pack mantissa (
                    fun (ds) -> 
                      List.fold_right 
                          (fun a b ->
                            let f = (float_of_char a) in
                            (f +. b ) /. 10.)
                          ds 
                          0.
                  );;

  let nt_IntegerAsInteger =
    let integ = caten nt_Sign nt_Natural in
      pack integ 
      (
        fun ((sign,num)) -> 
          sign*num
      );; 
      

  let nt_Fraction = 
    let frac = caten nt_IntegerAsInteger (caten (char '/') nt_Natural) in
                pack frac
                    (fun (nomer,(_,denom)) ->
                        let gd = gcd nomer denom in
                        Number(Fraction(nomer/gd , denom/gd))
                    )
                  
              ;;

  let nt_Snotation = pack (caten (char_ci 'e') nt_IntegerAsInteger) (fun (_,exp)-> 10. ** (float_of_int exp)) ;; 


  let nt_Integer = 
    let integ = caten (caten nt_Sign nt_Natural) (maybe nt_Snotation) in
    pack integ 
    (
      fun (((sign,num),snot)) ->
        match snot with
      | Some(snot) ->  Number(Float( (float_of_int (sign*num)) *. snot))
      | None -> Number(Fraction(sign*num,1))
    );;


  let nt_Float = 
    let flo = caten (caten nt_IntegerAsInteger (caten (char '.') nt_Mantissa)) (maybe nt_Snotation) in
      pack flo
      (
        fun ((ls,(_,rs)),sn) ->
        let fl = if ls<0 
        then ((float_of_int ls) -. rs)
        else ((float_of_int ls) +. rs) in
        match sn with
        |Some(sn) -> Number(Float(sn *. fl))
        |none -> Number(Float(fl))
          
      );;
              
  let nt_Number = disj_list(
  nt_Float :: 
  nt_Fraction::
  nt_Integer::[]
  );;


(*-------------------------------------String-----------------------------------------------*)
    let nt_StringMetaChar = 
    (disj_list (
      (pack (word "\\\\") (fun _ -> '\\'))::
      (pack (word "\\\"") (fun _ -> '\"')) ::
      (pack (word "\\t") (fun _->'\t'))::
      (pack (word "\\f") (fun _->'\012'))::
      (pack (word "\\n") (fun _-> '\n' ))::
      (pack (word "\\r") (fun _-> '\r'))::[]
      ));;
        
  let nt_StringLiteralChar = guard nt_any (fun(c)-> c != '\"' && c != '\\');;

  let nt_StringChar = disj nt_StringMetaChar nt_StringLiteralChar ;;

  let nt_String = 
    let str = caten (char '\034') 
  (caten (star nt_StringChar) (char '\034')) in
  pack str (fun(_, (char_list, _)) -> String(list_to_string char_list));;
  
  (* let nt_StringMetaChar = 
    (disj_list (
      (pack (word "\\\\") (fun _ -> '\\'))::
      (pack (word "\\\"") (fun _ -> '\"')) ::
      (pack (word "\\t") (fun _->'\t'))::
      (pack (word "\\f") (fun _->'\012'))::
      (pack (word "\\n") (fun _-> '\n' ))::
      (pack (word "\\r") (fun _-> '\r'))::[]
      ));;
        
  let nt_StringLiteralChar = guard nt_any (fun(c)-> c != '"' && c != '\\');;

  let nt_StringChar = disj nt_StringMetaChar (pack nt_StringLiteralChar (fun(a) -> a::[])) ;;

  let nt_String = 
    let str = caten (char '\"') 
  (caten (pack (star nt_StringChar) (fun (a) -> List.flatten(a))) (char '\"')) in
  pack str (fun(_, (a, _)) -> String(list_to_string a));; *)

(*-------------------------------------Symbol-----------------------------------------------*)

  let nt_Dot = char '.' ;;
  let nt_Letter = range_ci 'a' 'z';;
  let nt_PunctuationMark = disj_list(
                                char '!' ::
                                char '$' ::
                                char '^' ::
                                char '*' ::
                                char '-' ::
                                char '_' ::
                                char '=' ::
                                char '+' ::
                                char '<' ::
                                char '>' ::
                                char '?' ::
                                char '/' ::
                                char ':' :: []);;

  let nt_SymbolCharNoDot = disj digit (disj nt_Letter nt_PunctuationMark);;
  let nt_SymbolChar = disj nt_SymbolCharNoDot nt_Dot;;
  let nt_Symbol = 
    pack((disj 
            (pack (caten nt_SymbolChar (plus nt_SymbolChar)) (fun (c,ls) -> c::ls))
            (pack nt_SymbolCharNoDot (fun c -> c::[]))))
    (fun (symb) -> Symbol(String.lowercase_ascii (list_to_string symb)));;

(*-------------------------------------Sexp-------------------------------------------------*)
  let rec nt_Sexpr s= 
  let nt_sexpr = 
    make_spacedCommented(disj_list ( 
                  nt_Boolean::  
                  nt_Char::       
                  (not_followed_by nt_Number nt_Symbol)::     
                  nt_String::     
                  nt_Symbol::
                  nt_List s::
                  nt_DottedList s::
                  nt_Quoted s::     
                  nt_QuasiQuoted s::
                  nt_Unquoted s::   
                  nt_UnquoteAndSpliced s::[])) 
  in nt_sexpr s

  (*-------------------------------------comments and whitespace------------------------------*)
  and nt_SexprComment s= (pack 
  (caten (word "#;") nt_Sexpr) 
      (fun(_) -> '_')) 

  and nt_CommentOrWhiteSpaces s=
    star (disj_list([ nt_WhiteSpace; nt_LineComment; nt_SexprComment s]))

  and make_spacedCommented nt s= make_paired (nt_CommentOrWhiteSpaces s) (nt_CommentOrWhiteSpaces s) nt s
(*-------------------------------------List-------------------------------------------------*)
  and nt_List s = 
  pack (caten (char '(') (caten (nt_CommentOrWhiteSpaces s) (caten (star nt_Sexpr) (char ')')))) 
  (fun (_, (_, (a, _)))->list_to_proper_list a)

  and nt_DottedList s= 
  pack
    (caten (char '(') 
        (caten (plus nt_Sexpr) 
          (caten (char '.') 
          (caten nt_Sexpr (char ')'))))) (fun (_, (ls, (_, (rs, _))))-> list_to_improper_list (List.append ls (rs::[])))

(*-------------------------------------Quotes-----------------------------------------------*)

  and nt_Quoted s= pack (caten (char (char_of_int 39)) nt_Sexpr)
    (fun (_, (sexp)) -> Pair(Symbol("quote") , Pair(sexp, Nil)))

  and nt_QuasiQuoted s= pack (caten (char '`') nt_Sexpr)
  (fun (_, (sexp)) -> Pair(Symbol("quasiquote") , Pair(sexp, Nil)))

  and nt_Unquoted s= pack (caten (char ',') nt_Sexpr)
  (fun (_, (sexp)) -> Pair(Symbol("unquote") , Pair(sexp, Nil)))

  and nt_UnquoteAndSpliced s= pack (caten (word ",@") nt_Sexpr)
  (fun (_, (sexp)) -> Pair(Symbol("unquote-splicing") , Pair(sexp, Nil)));;


module Reader: sig
  val read_sexprs : string -> sexpr list
end
= struct
let normalize_scheme_symbol str =
  let s = string_to_list str in
  if (andmap
  (fun ch -> (ch = (lowercase_ascii ch)))
  s) then str
  else Printf.sprintf "|%s|" str;;


let read_sexprs string = 
            let (lst,rest) = test_string (star nt_Sexpr) string in
            lst;;
end;; (* struct Reader *)
