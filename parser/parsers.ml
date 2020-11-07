#use "../pc.ml";;
#use "../reader.ml";;
open PC;;

let digit = range '0' '9';;

let nt_Sign = disj (char '+') (char '-');;

let nt_Natural = 
    let digits = plus digit in

    
    pack digits (fun (ds) -> (int_of_string (list_to_string ds)));;

let nt_Integer = 
  let integ = caten (maybe nt_Sign) nt_Natural in
  pack integ 
  (
    fun ((sign,num)) -> 
      match sign with
      | Some('+') -> Fraction(num,1)
      | Some('-') -> Fraction(-1*num,1)
      | None -> Fraction(num,1)
      | Some(_) -> raise X_no_match
  );;

let rec num_of_digits x =
  if x <= 0 then 0
  else num_of_digits (x / 10) + 1;;

let rec pow num exp = 
  if exp = 0 then 1
  else  num *(pow (num) (exp -1));;

let nt_Float =  
              let flo = caten nt_Integer (caten (char '.') nt_Natural) in
              pack flo
              (fun ((frac,(_,rs)))->
              match frac with
              |Fraction(ls, _) -> (float_of_int ls) +. ((float_of_int rs) /. (float_of_int (pow 10 (num_of_digits rs))))
              | _ -> raise X_no_match
              );;


let rec gcd a b = 
  if a = 0 then b
  else gcd (b mod a) a;;


let nt_Fraction = 
  let frac = caten nt_Integer (caten (char '/') nt_Natural) in
              pack frac
                   (fun (fr,(_,denom)) ->
                   match fr with 
                   | Fraction(nomer,_) -> let gd = gcd nomer denom in
                                          Fraction(nomer/gd , denom/gd)
                   | _ -> raise X_no_match
                   )
                 
             ;;

            (* before:
            # let nt_Fraction = 
              let frac = caten nt_Integer (caten (char '/') nt_Natural) in
                            pack frac
                              (fun ((Fraction(denom,_),(_,nomen)),rest) ->
                                match a with
                                | number -> []
                                | _ -> raise X_no_match
                              )
                            
                        ;;
            *)
             

let nt_Number = disj nt_Integer 
               (disj nt_Float nt_Fraction);;
 

let nt_LowerCaseLetter = range 'a' 'z';;

let nt_UpperCaseLetter = range 'A' 'Z';;

let nt_PunctuationMarks =  disj (char '!') 
                          (disj (char '$') 
                          (disj (char '^')
                          (disj (char '-')
                          (disj (char '_')
                          (disj (char '=')
                          (disj (char '+')
                          (disj (char '<')
                          (disj (char '>')
                          (disj (char '?')
                          (disj (char '/') (char ':') ))))))))));;

let nt_Dot = (char '.');;

let nt_List = caten (char '(') 
             (caten (star sexpr) (char ')'));;

let nt_DottedList = caten (char '(') 
                   (caten (plus nt_Sexpr) 
                   (caten (char '.') 
                   (caten nt_Sexpr (char ')'))));;

let nt_SymbolCharNotDot = disj nt_digit 
                         (disj nt_LowerCaseLetter 
                         (disj nt_UpperCaseLetter nt_PunctuationMarks));;

let nt_SymbolChar = disj nt_SymbolCharNoDot nt_SymbolChar ;;

let nt_Symbol =  disj nt_SymbolCharNotDot 
                (caten nt_SymbolChar (plus nt_SymbolChar));;

let nt_StringChar = disj nt_StringLiteralChar nt_StringMetaChar;;


let nt_String = caten (char '"') 
               (caten ( (star nt_StringChar) (char '"')));;

let nt_Boolean = disj (word_ci "#f") (word_ci "t")
test_string nt_Natural "123";;
