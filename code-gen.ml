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
  | Const'(Sexpr(x)) -> [x]
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


  let rec expand_sexpr expr = 
    match expr with
    | Pair(car,cdr) -> List.append (List.append (expand_sexpr car)(expand_sexpr cdr)) [(Pair(car,cdr))]
    | sexp -> [sexp];;


  let expand_sexpr_list sexpr_list =
    List.concat (List.map (fun sexpr -> expand_sexpr sexpr) sexpr_list);;


module Code_Gen : CODE_GEN = struct
  let make_consts_tbl asts = raise X_not_yet_implemented;;
    (* let sexprs_list =  collect_sexp asts in 
    let sexprs_set = remove_dups sexprs_list [] in
    let sorted_sexprs_list = expand_sexpr_list sexprs_list in
    let sorted_sexprs_set = remove_dups sorted_sexprs [] in [];; *)
    
    
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
