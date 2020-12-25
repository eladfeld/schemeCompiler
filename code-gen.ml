#use "semantic-analyser.ml";;

(* This module is here for you convenience only!
   You are not required to use it.
   you are allowed to change it. *)
module type CODE_GEN = sig
  (* This signature assumes the structure of the constants table is
     a list of key-value pairs:
     - The keys are constant values (Sexpr(x) or Void)
     - The values are pairs of:
       * the offset from the base const_table address in bytes; and
       * a string containing the byte representation (or a sequence of nasm macros)
         of the constant value
     For example: [(Sexpr(Nil), (1, "T_NIL"))]
   *)
  val make_consts_tbl : expr' list -> (constant * (int * string)) list

  (* This signature assumes the structure of the fvars table is
     a list of key-value pairs:
     - The keys are the fvar names as strings
     - The values are the offsets from the base fvars_table address in bytes
     For example: [("boolean?", 0)]
   *)  
  val make_fvars_tbl : expr' list -> (string * int) list

  (* If you change the types of the constants and fvars tables, you will have to update
     this signature to match: The first argument is the constants table type, the second 
     argument is the fvars table type, and the third is an expr' that has been annotated 
     by the semantic analyser.
   *)
  val generate : (constant * (int * string)) list -> (string * int) list -> expr' -> string
end;;

let rec collect_sexp expr =
  match expr with
  | Const'(Void) -> [Void]
  | Const'(Sexpr(x)) -> [Sexpr(x)]
  | If'(test,dit,dif) -> List.append (List.append (collect_sexp test) (collect_sexp dit)) (collect_sexp dif)
  | LambdaSimple'(params,body) -> collect_sexp body
  | LambdaOpt'(mandatory, optional, body) -> collect_sexp body
  | Or'(ors) -> List.fold_left (fun acc o -> List.append acc (collect_sexp o)) [] ors
  | Set'(vr,vl) -> collect_sexp vl
  | Seq'(seq) ->  List.fold_left (fun acc e -> List.append acc (collect_sexp e)) [] seq
  | Def'(vr,vl) -> collect_sexp vl
  | Applic'(body,args) -> List.append (collect_sexp body) (List.fold_left (fun acc arg -> List.append acc (collect_sexp arg)) [] args)
  | ApplicTP'(body,args) -> List.append (collect_sexp body) (List.fold_left (fun acc arg -> List.append acc (collect_sexp arg)) [] args)
  | Var'(x) -> []
  | BoxSet'(vr,vl) -> collect_sexp vl
  | BoxGet'(vr) -> []
  | Box'(var) -> [] ;;

  

  let rec remove_dups lst no_dups= 
    match lst with
    | first::rest -> if (List.mem first no_dups) then (remove_dups rest no_dups) else (remove_dups rest (List.append no_dups [first]))
    | [] -> no_dups;;


  let expand_sexpr_list sexpr_list = 
    let rec expand_sexpr expr = 
      match expr with
      | Sexpr(Pair(car,cdr)) -> List.append (List.append (expand_sexpr car)(expand_sexpr cdr)) [Sexpr((Pair(car,cdr)))]
      | Sexpr(Symbol(s)) -> Sexpr(String(s))::[Sexpr(Symbol(s))]
      | Sexpr(sexp) -> [Sexpr(sexp)] in
    List.concat (List.map (fun sexpr -> expand_sexpr sexpr) sexpr_list);;

  let find_sexpr_offset sexp const_tbl = "";;

  let rec build_const_tbl sexprs const_tbl current_offset=
    let sexpr_to_const_entry sexpr const_tbl current_offset=
      match sexpr with
      | Sexpr(Bool(true)) -> (current_offset + 2 ,(Sexpr(Bool(true)), (current_offset , "MAKE_LITERAL_BOOL(1)\n") ))
      | Sexpr(Bool(false)) -> (current_offset + 2 ,(Sexpr(Bool(false)), (current_offset , "MAKE_LITERAL_BOOL(0)\n") ))
      | Sexpr(Nil) -> (current_offset + 1 ,(Sexpr(Nil), (current_offset , "MAKE_NIL\n") ) )
      | Void -> (current_offset + 1 ,(Void, (current_offset , "MAKE_VOID\n") ) ) 
      | Sexpr(Number(Fraction(num,denum))) -> (current_offset + 17 ,(Sexpr(Number(Fraction(num,denum))), (current_offset , "MAKE_LITERAL_RATIONAL(" ^ (string_of_int num) ^ "," ^ (string_of_int denum) ^ ")\n")))
      | Sexpr(Number(Float(flt))) -> (current_offset + 9 ,(Sexpr(Number(Float(flt))), (current_offset , "MAKE_LITERAL_FLOAT(" ^ (string_of_float flt) ^ ")\n")))
      | Sexpr(Char(c)) -> (current_offset + 2 ,(Sexpr(Char(c)), (current_offset, "MAKE_LITERAL_CHAR(" ^ (String.make 1 c) ^ ")\n")))
      | Sexpr(String(str)) -> (current_offset + 9 + (String.length str) ,(Sexpr(String(str)), (current_offset, "MAKE_LITERAL_STRING " ^ str ^"\n") ) )
      | Sexpr(Symbol(symb)) -> (current_offset + 9 ,(Sexpr(Symbol(symb)) , (current_offset  , "MAKE_LITERAL_SYMBOL(const_tbl+" ^ (find_sexpr_offset symb const_tbl) ^ ")\n")))
      | Sexpr(Pair(car,cdr)) -> (current_offset + 17, (Sexpr(Pair(car,cdr)) , (current_offset  , "MAKE_LITERAL_PAIR(const_tbl+" ^ (find_sexpr_offset car const_tbl) ^ ",const_tbl+" ^ (find_sexpr_offset cdr const_tbl) ^")\n")))
      in
    match sexprs with
    | sexpr::rest -> let (new_offset, entry) = (sexpr_to_const_entry sexpr const_tbl current_offset) in
                        build_const_tbl rest (List.append const_tbl [entry]) new_offset
    | [] -> const_tbl


module Code_Gen : CODE_GEN = struct
  let make_consts_tbl asts = 
    let sexprs_list = List.fold_left (fun acc ast -> List.append acc (collect_sexp ast)) [] asts in
    let sexprs_set = remove_dups sexprs_list [] in
    let sorted_sexprs_list = expand_sexpr_list sexprs_set  in
    let sorted_sexprs_list = List.append [Void; Sexpr(Nil) ; Sexpr(Bool(true)) ; Sexpr(Bool(false))] sorted_sexprs_list in
    let sorted_sexprs_set = remove_dups sorted_sexprs_list [] in 
    build_const_tbl sorted_sexprs_set [] 0 ;;
    
    
  let make_fvars_tbl asts = raise X_not_yet_implemented;;
  let generate consts fvars e = raise X_not_yet_implemented;;
end;;

let test_collect_sexp str = 
  collect_sexp (Semantics.run_semantics (List.hd (Tag_Parser.tag_parse_expressions (Reader.read_sexprs str))));;

let test_expand_sexp str =
  let sexprs_list = List.fold_left (fun acc ast -> List.append acc (collect_sexp ast)) [] (List.map (fun tag_parsed -> Semantics.run_semantics tag_parsed) (Tag_Parser.tag_parse_expressions (Reader.read_sexprs str))) in
  let sexprs_set = remove_dups sexprs_list [] in
  let sorted_sexprs_list = expand_sexpr_list sexprs_set  in
  let sorted_sexprs_set = remove_dups sorted_sexprs_list [] in 
  sorted_sexprs_set ;;

let test_make_const_table str= 
  let sexprs_list = List.fold_left (fun acc ast -> List.append acc (collect_sexp ast)) [] (List.map (fun tag_parsed -> Semantics.run_semantics tag_parsed) (Tag_Parser.tag_parse_expressions (Reader.read_sexprs str))) in
  let sexprs_set = remove_dups sexprs_list [] in
  let sorted_sexprs_list = expand_sexpr_list sexprs_set  in
  let sorted_sexprs_set = remove_dups sorted_sexprs_list [] in 
  build_const_tbl sorted_sexprs_set [] 0 ;;
