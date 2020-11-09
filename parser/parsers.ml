#use "../pc.ml";;
#use "../reader.ml";;
open PC;;

(*-------------------------------------helper functions----------------------------------------*)

let rec gcd a b = 
  if a = 0 then b
  else gcd (b mod a) a;;

let float_of_char c = 
    let num = (int_of_char c)-(int_of_char '0') in
      float_of_int num


(*-----------------------------------------end-------------------------------------------------*)

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
 (**)
let nt_IntegerAsInteger =
  let integ = caten nt_Sign nt_Natural in
    pack integ 
    (
      fun ((sign,num)) -> 
        sign*num
    );; 
    
(*   *)
let nt_Fraction = 
  let frac = caten nt_IntegerAsInteger (caten (char '/') nt_Natural) in
              pack frac
                   (fun (nomer,(_,denom)) ->
                      let gd = gcd nomer denom in
                      Fraction(nomer/gd , denom/gd)
                   )
                 
             ;;

(*  *)
let nt_Integer = 
  let integ = caten nt_Sign nt_Natural in
  pack integ 
  (
    fun ((sign,num)) -> 
     Fraction(sign*num,1)
  );;



let nt_Float = 
  let flo = caten nt_IntegerAsInteger (caten (char '.') nt_Mantissa) in
    pack flo
    (
      fun (ls,(_,rs)) ->
        if ls<0 
        then Float((float_of_int ls) -. rs)
        else Float((float_of_int ls) +. rs)
    );;
             
let nt_Number = disj nt_Float  
               (disj nt_Fraction nt_Integer);;
 

let nt_LowerCaseLetter = range 'a' 'z';;

let nt_UpperCaseLetter = range 'A' 'Z';;


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

let nt_Dot = (char '.');;


let nt_List = caten (char '(') 
             (caten (star nt_sexpr) (char ')'));;

let nt_DottedList = caten (char '(') 
                   (caten (plus nt_Sexpr) 
                   (caten (char '.') 
                   (caten nt_Sexpr (char ')'))));;

let nt_SymbolCharNotDot = disj digit 
                         (disj nt_LowerCaseLetter 
                         (disj nt_UpperCaseLetter nt_PunctuationMarks));;

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

let nt_StringMetaChar = caten 
  (char '\'') 
  (disj_list (
    char '\''::
    char '"'::
    char 't'::
    char 'f'::
    char 'n'::
    char 'r'::[]
    ));;


let nt_StringChar = disj nt_StringLiteralChar nt_StringMetaChar;;


let nt_String = caten (char '"') 
               (caten ( (star nt_StringChar) (char '"')));;

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


let nt_sexpr = disj_list 
  (nt_Boolean::
  ny_char::
  





