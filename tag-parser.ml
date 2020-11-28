#use "reader.ml";;
open Reader;;

type constant =
  | Sexpr of sexpr
  | Void

type expr =
  | Const of constant    
  | Var of string             
  | If of expr * expr * expr  
  | Seq of expr list  
  | Set of expr * expr        
  | Def of expr * expr         
  | Or of expr list             
  | LambdaSimple of string list * expr
  | LambdaOpt of string list * string * expr
  | Applic of expr * (expr list);;  
  
type letexp = Let of expr list * expr list * expr list

(* let unparse_let letExp = 
    match letExp with
    | Let(vals,params,body) -> Pair(Symbol("let"), ) *)

let rec expr_eq e1 e2 =
  match e1, e2 with
  | Const Void, Const Void -> true
  | Const(Sexpr s1), Const(Sexpr s2) -> sexpr_eq s1 s2
  | Var(v1), Var(v2) -> String.equal v1 v2
  | If(t1, th1, el1), If(t2, th2, el2) -> (expr_eq t1 t2) &&
                                            (expr_eq th1 th2) &&
                                              (expr_eq el1 el2)
  | (Seq(l1), Seq(l2)
    | Or(l1), Or(l2)) -> List.for_all2 expr_eq l1 l2
  | (Set(var1, val1), Set(var2, val2)
    | Def(var1, val1), Def(var2, val2)) -> (expr_eq var1 var2) &&
                                             (expr_eq val1 val2)
  | LambdaSimple(vars1, body1), LambdaSimple(vars2, body2) ->
     (List.for_all2 String.equal vars1 vars2) &&
       (expr_eq body1 body2)
  | LambdaOpt(vars1, var1, body1), LambdaOpt(vars2, var2, body2) ->
     (String.equal var1 var2) &&
       (List.for_all2 String.equal vars1 vars2) &&
         (expr_eq body1 body2)
  | Applic(e1, args1), Applic(e2, args2) ->
     (expr_eq e1 e2) &&
       (List.for_all2 expr_eq args1 args2)
  | _ -> false;;
	
                       
exception X_syntax_error;;

let is_Var x = 
  let reserved_word_list =
    ["and"; "begin"; "cond"; "define"; "else";
    "if"; "lambda"; "let"; "let*"; "letrec"; "or";
    "quasiquote"; "quote"; "set!"; "pset!"; "unquote";
    "unquote-splicing"] in
    not (List.mem x reserved_word_list);;  

let rec is_proper_list pr = 
  match pr with
  | Nil -> true
  | Pair(x, Nil)-> true
  | Pair(x, Pair(y, z)) -> is_proper_list (Pair(y, z))
  | Pair (x,y) -> false
  | _ -> raise X_syntax_error;;


  let rec pairs_to_list_map pr func=
    match pr with
    | Pair(x,Nil) -> (func x)::[]
    | Pair(x, Pair(y,z)) -> (func x)::(pairs_to_list_map (Pair(y,z)) func)
    | Pair(x, y) -> (func x)::[(func y)]
    | Nil -> []
    | _ -> raise X_no_match;;

let rec pairs_to_list pr=
  match pr with
  | Pair(x,Nil) ->  x::[]
  | Pair(x, Pair(y,z)) -> x::(pairs_to_list (Pair(y,z)))
  | Pair(x, y) -> x::[y]
  | Nil -> []
  | _ -> raise X_no_match;;

let pairs_to_string_list pr = 
  pairs_to_list_map pr (fun (Symbol(x))->x);;

let rec seperate_list_last lst = 
  match lst with
  |x::y::[] -> x::[] , y
  |x::y -> let a, b = seperate_list_last y in x::a, b

let get_params lst = 
  pairs_to_list_map lst (fun (Pair(Symbol(param), _)) -> param);;

let get_vals lst = 
  pairs_to_list_map lst (fun (Pair(param, Pair(vals, _))) -> vals);;

let get_params_vals lst = 
  let params = pairs_to_list_map lst (fun (Pair(Symbol(param), _)) -> param) in
  let vals = pairs_to_list_map lst (fun (Pair(param, Pair(vals, _))) -> vals) in
  (params, vals);;

let rec tag_parse exp = 
  match exp with
  | Number(x) -> Const(Sexpr(Number(x)))
  | Bool(x) -> Const(Sexpr(Bool(x)))
  | Char(x) -> Const(Sexpr(Char(x)))
  | String(x) -> Const(Sexpr(String(x)))
  | Symbol(x) -> if is_Var(x) then Var(x) else raise X_syntax_error
  | Pair(Symbol("quote"), Pair(x, Nil)) -> Const(Sexpr(x))
  | Pair(Symbol("if"), Pair(test, Pair(dit, Pair(dif, Nil)))) -> If(tag_parse test, tag_parse dit, tag_parse dif)
  | Pair(Symbol("if"), Pair(test, Pair(dit,Nil))) -> If(tag_parse test, tag_parse dit, Const(Void))
  | Pair(Symbol("lambda"), x) -> parse_lambda  x
  | Pair(Symbol("or"), Nil) ->  Const(Sexpr(Bool(false)))
  | Pair(Symbol("or"), Pair(x, Nil)) ->  tag_parse x
  | Pair(Symbol("or"), x) -> Or(pairs_to_list_map x tag_parse)
  | Pair(Symbol("set!"), Pair(vars, Pair(vals, Nil))) -> Set(tag_parse vars, tag_parse vals)
  | Pair(Symbol("define"), Pair(vars, Pair(vals, Nil))) -> Def(tag_parse vars, tag_parse vals) 
  | Pair(Symbol("begin"),Nil) -> Const(Void)
  | Pair(Symbol("begin"),exps) -> parse_seq exps
  | Pair(Symbol("quasiquote"),Pair(rest, Nil)) -> parse_quasiquote rest 
  (* | Pair(Symbol("cond"), Pair(rest,Nil)) -> parse_cond rest  *)
  | Pair(Symbol("let"),  Pair(init,body)) -> parse_let init body
  | Pair(Symbol("let*"), Pair(init,body)) -> parse_let_star init body
  (* | Pair(Symbol("letrec"), Pair(init,body)) -> parse_letrec init body *)
  | Pair(Symbol("and"), rest) -> parse_and rest

  | Pair(Symbol(x), y) -> Applic(tag_parse (Symbol(x)), (pairs_to_list_map y tag_parse) )
  | Pair(x,y) -> Applic (tag_parse x, (pairs_to_list_map y tag_parse))
  | _ -> raise X_syntax_error

  and parse_quasiquote exps = 
    match exps with
    | Pair(Symbol("unquote"), Pair(sexp, Nil)) -> tag_parse sexp
    | Pair(Symbol("unquote-splicing"),Pair(sexp, Nil) ) -> raise X_syntax_error
    | Nil -> tag_parse (Pair(Symbol("quote") , Pair(Nil,Nil)))
    | Symbol(x) -> tag_parse (Pair(Symbol("quote") , Pair(Symbol(x),Nil) ))
    (* | Pair( Pair(Symbol("unquote-splicing"), Pair()), B) -> parse_tag Pair(sexpr, B) *)

  and parse_and rest = 

    match rest with 
    | Nil -> Const(Sexpr(Bool(true)))
    | Pair(x, Nil) -> tag_parse x
    | Pair(x,y) -> 
      let Pair(test,rest) = rest in
      let _then = Pair(Symbol("and") , rest) in
      let _else = Bool(false) in
      tag_parse (Pair(Symbol("if"),Pair(test,Pair(_then,Pair(_else,Nil)))))

  and parse_lambda x = 
   match x with 
   | Pair(Symbol(y), body) -> LambdaOpt([], y, parse_seq body)
   | Pair(args,body) -> if(is_proper_list args) then 
                            LambdaSimple(pairs_to_string_list args,parse_seq body)
                        else let args=pairs_to_string_list args in 
                              let mandatory, optional = seperate_list_last args in
                            LambdaOpt(mandatory, optional, parse_seq body)
   | _ -> raise X_syntax_error
 
  and parse_let init body = 
    let (paramters,vals) = get_params_vals init in
    let body = parse_seq body in
    let func = LambdaSimple(paramters,body) in
    Applic(func ,List.map tag_parse vals)

  and parse_let_star init body =
    match init with 
    | Nil -> tag_parse (Pair(Symbol("let"), Pair(Nil, body)))
    | Pair(x, Pair(y, z)) -> tag_parse (Pair(Symbol("let"), Pair(Pair(x, Nil),Pair(Pair(Symbol("let*"), Pair(Pair(y, z), body)), Nil))))
    | Pair(x, y) -> tag_parse (Pair(Symbol("let"), Pair(init, body)))
    | _ -> raise X_syntax_error

  and parse_letrec init body =
    let (paramters,vals) = get_params_vals init in
    parse_tag (Pair(Symbol("let"), Pair(Pair(x, Nil))))

    (* (let-rec ((f1 a) (f2 b) (f3 c)) (+ f1 f2 f3))

    [f1; f2; f3]
    [a; b; c]
    body
  
    (let ((f1 'wtv) (f2 'wtv) (f3 'wtv)) (set! f1 a) (set! f2 b) (set! f3 c) body)
  
  [exp1; exp2; exp3] -> Pair(Pair (exp1, pair('wtv, nil), pair(exp2, pair('wtv, nil)))) *)


  and parse_seq exps = 
    let exps = pairs_to_list exps in
      if (List.length exps = 1) then  
        tag_parse (List.hd exps)
      else 
         let parsed = List.map tag_parse exps in
          let parsed = List.fold_left 
                        (fun acc exp-> 
                            match exp with
                            | Seq(x) -> List.append acc x
                            | _ -> List.append acc [exp] )
                         []
                         parsed in                     
          Seq(parsed);;
          
          

                        
   



  

  




module type TAG_PARSER = sig
  val tag_parse_expressions : sexpr list -> expr list
end;; (* signature TAG_PARSER *)

module Tag_Parser : TAG_PARSER = struct

let reserved_word_list =
  ["and"; "begin"; "cond"; "define"; "else";
   "if"; "lambda"; "let"; "let*"; "letrec"; "or";
   "quasiquote"; "quote"; "set!"; "pset!"; "unquote";
   "unquote-splicing"];;  

(* work on the tag parser starts here *)

let tag_parse_expressions sexpr = List.map tag_parse sexpr

  
end;; (* struct Tag_Parser *)

