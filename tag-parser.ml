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


let unparse_const (const:constant) : sexpr = 
  match const with 
  | Sexpr(sexp) -> sexp
  | Void -> Nil


let rec tag_unparse exp = 
  match exp with 
  | Const(const) -> unparse_const const
  | Var(name) -> Symbol(name)
  | If(test,dit,dif) -> unparse_if test dit dif
  | Seq(seq) -> unparse_seq seq
  | Set(name,vl) -> unparse_set name vl
  | Def(name,vl) -> unparse_def name vl
  | Or(elements) -> unparse_or elements
  | LambdaSimple(params,body) -> unparse_LambdaSimple params body
  | LambdaOpt(mandatory,optional,body) -> unparse_LambdaOpt mandatory optional body
  | Applic(body, vals) -> unparse_Applic body vals
  | _ -> raise X_no_match

  and unparse_if test dit dif=
    Pair(Symbol("if"), Pair(tag_unparse test ,Pair(tag_unparse dit,Pair(tag_unparse dif,Nil))))
  
  and unparse_seq seq = 
    let rec set_pairs exprs =
      match exprs with
      | [] -> Nil
      | expr::[] -> Pair(tag_unparse expr,Nil)
      | expr::rest_exprs -> Pair(tag_unparse expr,set_pairs rest_exprs) in
    Pair(Symbol("begin"),set_pairs seq)

  and unparse_set name vl = 
      Pair(Symbol("set!"),Pair(tag_unparse name,Pair(tag_unparse vl,Nil)))

  and unparse_def name vl = 
      Pair(Symbol("define"),Pair(tag_unparse name, Pair(tag_unparse vl,Nil)))

  and unparse_or elements = 
    let rec set_pairs exprs =
      match exprs with
      | [] -> Nil
      | expr::[] -> Pair(tag_unparse expr,Nil)
      | expr::rest_exprs -> Pair(tag_unparse expr,set_pairs rest_exprs) in
    Pair(Symbol("or"),set_pairs elements)

  and unparse_LambdaSimple params body =
    let params = List.map (fun x -> Var(x)) params in
    let rec set_pairs exprs =
      match exprs with
      | [] -> Nil
      | expr::[] -> Pair(tag_unparse expr,Nil)
      | expr::rest_exprs -> Pair(tag_unparse expr,set_pairs rest_exprs) in
    Pair(Symbol("lambda"),Pair(set_pairs params,Pair(tag_unparse body,Nil)))
  
  and unparse_LambdaOpt mandatory optional body = 
  let mandatory = List.map (fun x-> Var(x)) mandatory in
  let rec set_improper_pairs exprs =
    match exprs with
    | [] -> Nil
    | expr::[] -> tag_unparse expr
    | expr1:: expr2 ::[] -> Pair(tag_unparse expr1 , tag_unparse expr2)
    | expr::rest_exprs -> Pair(tag_unparse expr,set_improper_pairs rest_exprs) in
  match mandatory with
  | [] -> Pair(Symbol("lambda"),Pair(tag_unparse (Var(optional)),Pair(tag_unparse body,Nil)))
  | _ -> Pair(Symbol("lambda"),Pair(Pair(set_improper_pairs mandatory,tag_unparse (Var(optional))),Pair(tag_unparse body,Nil)))
      

  and unparse_Applic body vals = 
    let rec set_pairs exprs =
      match exprs with
      | [] -> Nil
      | expr::[] -> Pair(tag_unparse expr,Nil)
      | expr::rest_exprs -> Pair(tag_unparse expr,set_pairs rest_exprs) in
    Pair(tag_unparse body,set_pairs vals);;
  

let unparse_let (params:expr list) (vals:expr list) (body:expr): sexpr =
  let rec params_n_vals (params:expr list) (vals:expr list) = 
    if ((List.length params) != (List.length vals)) then
      raise X_syntax_error 
    else match params,vals with
    | [], [] -> Nil
    | (param::[]), (vl::[]) -> Pair(Pair(tag_unparse param,Pair(tag_unparse vl,Nil)),Nil)
    | (param::rest_params), (vl::rest_vals) -> Pair(Pair(tag_unparse param,Pair(tag_unparse vl, Nil)), params_n_vals rest_params rest_vals)
    | _ -> raise X_syntax_error in
  Pair(Symbol("let"),Pair(params_n_vals params vals,Pair(tag_unparse body,Nil)));;


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
  |_ -> raise X_syntax_error

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
  | Pair(Symbol("if"), sexps) -> parse_if sexps 
  | Pair(Symbol("lambda"), x) -> parse_lambda  x
  | Pair(Symbol("or"), sexps ) -> parse_or sexps
  | Pair(Symbol("set!"), Pair(vars, Pair(vals, Nil))) -> Set(tag_parse vars, tag_parse vals)
  | Pair(Symbol("define"), Pair(Pair(Symbol(name), argl), expr)) -> mit_form_expnder name argl expr
  | Pair(Symbol("define"), Pair(vars, Pair(vals, Nil))) -> Def(tag_parse vars, tag_parse vals) 
  | Pair(Symbol("begin"),sexps) -> parse_begin sexps
  | Pair(Symbol("quasiquote"),Pair(rest, Nil)) -> quasiquote_expander rest 
  | Pair(Symbol("cond"), rest) -> cond_expander rest  
  | Pair(Symbol("let"),  Pair(init,body)) -> let_expander init body
  | Pair(Symbol("let*"), Pair(init,body)) -> let_star_expander init body
  | Pair(Symbol("letrec"), Pair(init,body)) -> letrec_expander init body
  | Pair(Symbol("and"), rest) -> and_expander rest

  | Pair(Symbol(x), y) -> Applic(tag_parse (Symbol(x)), (pairs_to_list_map y tag_parse) )
  | Pair(Pair(Symbol("lambda"),x),y) -> Applic (tag_parse (Pair(Symbol("lambda"),x)), (pairs_to_list_map y tag_parse))
  | _ -> raise X_syntax_error


and parse_if sexps =
  match sexps with 
  | Pair(test, Pair(dit, Pair(dif, Nil))) -> If(tag_parse test, tag_parse dit, tag_parse dif)
  | Pair(test, Pair(dit,Nil)) -> If(tag_parse test, tag_parse dit, Const(Void))
  | _ -> raise X_no_match

and parse_lambda x = 
  match x with 
  | Pair(Symbol(y), body) -> LambdaOpt([], y, parse_seq body)
  | Pair(args,body) -> if(is_proper_list args) then 
                          LambdaSimple(pairs_to_string_list args,parse_seq body)
                      else let args=pairs_to_string_list args in 
                            let mandatory, optional = seperate_list_last args in
                          LambdaOpt(mandatory, optional, parse_seq body)
  | _ -> raise X_syntax_error

and parse_or sexps = 
  match sexps with
  | Nil ->  Const(Sexpr(Bool(false)))
  | Pair(x, Nil) ->  tag_parse x
  | x -> Or(pairs_to_list_map x tag_parse)


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
        Seq(parsed)

and parse_begin sexps = 
  match sexps with
  | Nil -> Const(Void)
  | exps -> parse_seq exps
  
and cond_expander sexpr =
  let rec ribs_expander ribs =
    match ribs with
    | [] -> Nil
    | _ ->
    let first::rest = ribs in
    match first with
    | Pair(test, Pair(Symbol("=>"), func)) ->   
          Pair(Symbol "let", Pair(Pair(Pair(Symbol "value", Pair(test, Nil)), Pair(Pair(Symbol "f", Pair(Pair(Symbol "lambda", Pair(Nil, Pair(func, Nil))), Nil)), Pair(Pair(Symbol "rest", Pair(Pair(Symbol "lambda", Pair(Nil, Pair(ribs_expander rest, Nil))), Nil)), Nil))), Pair(Pair(Symbol "if", Pair(Symbol "value", Pair(Pair(Pair(Symbol "f", Nil), Pair(Symbol "value", Nil)), Pair(Pair(Symbol "rest", Nil), Nil)))), Nil)))
    | Pair(Symbol("else"), seq) ->  (Pair(Symbol("begin"), seq))
    | Pair(condition, seq) ->  (Pair(Symbol("if"), Pair(condition, Pair(Pair(Symbol("begin"), seq), ribs_expander rest))))
      in
      let ribss = pairs_to_list sexpr in
      tag_parse (ribs_expander ribss)
    
and quasiquote_expander exps = 

  match exps with
  | Pair(Symbol("unquote"), Pair(sexp, Nil)) -> tag_parse sexp
  | Pair(Symbol("unquote-splicing"),Pair(sexp, Nil) ) -> raise X_syntax_error
  | Nil -> tag_parse (Pair(Symbol("quote") , Pair(Nil,Nil)))
  | Symbol(x) -> tag_parse (Pair(Symbol("quote") , Pair(Symbol(x),Nil) ))
  | Pair(Pair(Symbol("unquote-splicing"),Pair(sexp, Nil)),b) -> Applic(Var("append"), [tag_parse sexp ;quasiquote_expander b ] )
  | Pair(a,Pair(Symbol("unquote-splicing"),Pair(sexp, Nil))) -> Applic(Var("cons") , [quasiquote_expander a ; tag_parse sexp])
  | Pair(a,b) -> Applic(Var("cons") , [quasiquote_expander a; quasiquote_expander b])
  | _ -> raise X_syntax_error

and let_expander init body = 
  let (paramters,vals) = get_params_vals init in
  let body = parse_seq body in
  let func = LambdaSimple(paramters,body) in
  Applic(func ,List.map tag_parse vals)

and let_star_expander init body =
  match init with 
  | Nil -> tag_parse (Pair(Symbol("let"), Pair(Nil, body)))
  | Pair(x, Pair(y, z)) -> tag_parse (Pair(Symbol("let"), Pair(Pair(x, Nil),Pair(Pair(Symbol("let*"), Pair(Pair(y, z), body)), Nil))))
  | Pair(x, y) -> tag_parse (Pair(Symbol("let"), Pair(init, body)))
  | _ -> raise X_syntax_error

and letrec_expander init body =
  let rec list_to_let_rec_pairs lst =
    match lst with
    | [] -> Nil
    | a::b -> Pair(Pair(a, Pair(Pair(Symbol("quote"),Pair(Symbol("whatever"), Nil)), Nil)), list_to_let_rec_pairs b) in
  let rec lists_to_let_rec_sets params vals body=
    match params, vals with
    | [], [] -> body
    | a::b, c::d ->  Pair(Pair(Symbol("set!"), Pair(a, Pair(c, Nil))), lists_to_let_rec_sets b d body) 
    | a::b, [] -> raise X_syntax_error
    | [], a::b -> raise X_syntax_error in
  let (params,vals) = get_params_vals init in
  let params = List.map (fun (x) -> Symbol(x)) params in
  tag_parse (Pair(Symbol("let") ,Pair(list_to_let_rec_pairs params ,lists_to_let_rec_sets params vals body)))

and and_expander rest = 
  match rest with 
  | Nil -> Const(Sexpr(Bool(true)))
  | Pair(x, Nil) -> tag_parse x
  | Pair(x,y) -> 
    let Pair(test,rest) = rest in
    let _then = Pair(Symbol("and") , rest) in
    let _else = Bool(false) in
    tag_parse (Pair(Symbol("if"),Pair(test,Pair(_then,Pair(_else,Nil)))))
  | _ -> raise X_syntax_error

          
and mit_form_expnder name argl expr =
  tag_parse (Pair(Symbol("define"), Pair(Symbol(name), Pair(Pair(Symbol("lambda"), Pair(argl, expr)), Nil))))

let tag_parse_string str =
  tag_parse (List.hd (Reader.read_sexprs str));;
  (* (define name (lambda argl expr) ) *)
  (* (define f (a b c) (+ a b c)) *)

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


(* (pset! (x y) (y x))
==>
(let ((val1 y)
     (val2 x))
     (set! x val1)
     (set! y val2)
)

(pset! (val1 y) (y val1))
==>
(let ((val1 y)
      (val2 val1))
     (set! val1 val1)
     (set! y val2)
)


(lambda () x) *)