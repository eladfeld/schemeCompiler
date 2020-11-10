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
                      Number(Fraction(nomer/gd , denom/gd))
                   )
                 
             ;;

(*  *)


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