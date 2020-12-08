#use "tag-parser.ml";;

type var = 
  | VarFree of string
  | VarParam of string * int
  | VarBound of string * int * int;;

type expr' =
  | Const' of constant
  | Var' of var
  | Box' of var
  | BoxGet' of var
  | BoxSet' of var * expr'
  | If' of expr' * expr' * expr'
  | Seq' of expr' list
  | Set' of var * expr'
  | Def' of var * expr'
  | Or' of expr' list
  | LambdaSimple' of string list * expr'
  | LambdaOpt' of string list * string * expr'
  | Applic' of expr' * (expr' list)
  | ApplicTP' of expr' * (expr' list);;

let rec expr'_eq e1 e2 =
  match e1, e2 with
  | Const' Void, Const' Void -> true
  | Const'(Sexpr s1), Const'(Sexpr s2) -> sexpr_eq s1 s2
  | Var'(VarFree v1), Var'(VarFree v2) -> String.equal v1 v2
  | Var'(VarParam (v1,mn1)), Var'(VarParam (v2,mn2)) -> String.equal v1 v2 && mn1 = mn2
  | Var'(VarBound (v1,mj1,mn1)), Var'(VarBound (v2,mj2,mn2)) -> String.equal v1 v2 && mj1 = mj2  && mn1 = mn2
  | If'(t1, th1, el1), If'(t2, th2, el2) -> (expr'_eq t1 t2) &&
                                            (expr'_eq th1 th2) &&
                                              (expr'_eq el1 el2)
  | (Seq'(l1), Seq'(l2)
  | Or'(l1), Or'(l2)) -> List.for_all2 expr'_eq l1 l2
  | (Set'(var1, val1), Set'(var2, val2)
  | Def'(var1, val1), Def'(var2, val2)) -> (expr'_eq (Var'(var1)) (Var'(var2))) &&
                                             (expr'_eq val1 val2)
  | LambdaSimple'(vars1, body1), LambdaSimple'(vars2, body2) ->
     (List.for_all2 String.equal vars1 vars2) &&
       (expr'_eq body1 body2)
  | LambdaOpt'(vars1, var1, body1), LambdaOpt'(vars2, var2, body2) ->
     (String.equal var1 var2) &&
       (List.for_all2 String.equal vars1 vars2) &&
         (expr'_eq body1 body2)
  | Applic'(e1, args1), Applic'(e2, args2)
  | ApplicTP'(e1, args1), ApplicTP'(e2, args2) ->
	 (expr'_eq e1 e2) &&
	   (List.for_all2 expr'_eq args1 args2)
  | _ -> false;;
	
                       
exception X_syntax_error;;


let rec index_of_rec lst element indx =
  match lst with
  | [] -> -1
  | car::cdr -> 
      if (car = element) then indx
      else index_of_rec cdr element (indx + 1);;

let index_of lst element = 
  index_of_rec lst element 0;;

let rec major_minor_rec lst element env_num= 
  match lst with
  | [] -> -1, -1
  | car::cdr -> let indx = index_of car element in
    if(indx < 0) then major_minor_rec cdr element (env_num +1)
    else env_num, indx;;

let major_minor lst element = 
  major_minor_rec lst element 0;;

let make_var x env=
  match env with
  | params::env -> let index = index_of params x in
                  if(index >= 0) then 
                    VarParam(x, index)
                  else 
                    let major, minor = major_minor env x in
                    if(major >= 0) 
                      then VarBound(x, major, minor)
                    else VarFree(x)
  | [] -> VarFree(x);;

let rec annotate_lexical e env =
  match e with 
  | Const(c) -> Const'(c)
  | If(test,dit,dif) -> If'(annotate_lexical test env, annotate_lexical dit env, annotate_lexical dif env)
  | Seq(seq) -> Seq'(List.map (fun exp-> annotate_lexical exp env) seq)
  | Set(Var(name),vl) -> Set'(make_var name env , annotate_lexical vl env)
  | Def(Var(name),vl) -> Def'(make_var name env , annotate_lexical vl env)
  | Or(ors) -> Or'(List.map (fun exp-> annotate_lexical exp env) ors) 
  | Applic(func , arguments) -> Applic'(annotate_lexical func env, List.map (fun arg -> annotate_lexical arg env) arguments)
  | LambdaSimple(params,body) -> LambdaSimple'(params , annotate_lexical body (params::env))
  | LambdaOpt(mandatory , optional , body) -> LambdaOpt'(mandatory, optional , annotate_lexical body  ((List.append mandatory [optional])::env))
  | Var(x) -> Var'(make_var x env)
  | _ -> raise X_syntax_error;;

let rec annotate_TC expr in_tp = 
  match expr with 
  | Const'(x) -> Const'(x)
  | Var'(var) -> Var'(var)
  | If'(test,dit,dif) -> If'(annotate_TC test false, annotate_TC dit in_tp, annotate_TC dif in_tp)
  | Seq'(seq) -> Seq'(List.mapi (fun index expr -> if (index == ((List.length seq) -1)) then annotate_TC expr in_tp else annotate_TC expr false) seq)
  | Set'(var,vl) -> Set'(var, annotate_TC vl false)
  | Def'(var,vl) ->Def'(var, annotate_TC vl false)
  | Or'(ors) -> Or'(List.mapi (fun index expr -> if (index == ((List.length ors) -1)) then annotate_TC expr in_tp else annotate_TC expr false) ors)
  | LambdaSimple'(params, body) -> LambdaSimple'(params, annotate_TC body true)
  | LambdaOpt'(mandatory, optional, body) -> LambdaOpt'(mandatory, optional, annotate_TC body true)
  | Applic'(body, args) -> 
    if(in_tp) then 
      ApplicTP'(annotate_TC body false, List.map (fun arg -> annotate_TC arg false ) args)
    else 
      Applic'(annotate_TC body false, List.map (fun arg -> annotate_TC arg false ) args)
  | _ -> raise X_no_match;;  

  let rec find_read_write  exp depth =
    let read = [] in
    let write = [] in
    match exp with
    | Const'(x) -> read,write
    | If'(test,dit,dif) ->  if_read_write test dit dif depth
    (* | Seq'(x) -> *)
    | LambdaSimple'(params,body) -> find_read_write body (depth + 1)
    | LambdaOpt'(mandatory, optional, body) -> find_read_write body (depth + 1)
    |
    | 


    and if_read_write test dit dif depth = 
      let test_read, test_write = find_read_write test depth in
      let dit_read, dit_write = find_read_write dit depth in
      let dif_read, dif_write = find_read_write dif depth in
      test_read::dit_read::dif_read, test_write::dit_write::dif_write;;


    | Var'(VarBound(name, major, minor)) -> if (major - 1) == depth then name::read, write
    | Set'(VarBound(name, major, minor), _) -> if (major - 1) == depth then read, name::write


    (*
  (lambda (x y z)
    ->>>> 0
    (lambda () 1 (lambda ()  varbound(z, 1, 2))
    (lambda (z)  (lambda ()  (set! varbound(z, 0, 0) 1))
  )

*)
  let apply_box expr =
    let read_writes = find_read_write expr 0


    (* (lambda () (if a b c)) *)

  let rec box_set? e =
    match e with
    | Const'(x) -> Const'(x)
    | Var'(var) -> Var'(var)
    | If'(test,dit,dif) -> If'(box_set? test,box_set? dit, box_set? dif)
    | Seq'(seq) -> Seq'(List.map box_set? seq)
    | Set'(var,vl) -> Set'(box_set? var, box_set? vl)
    | Def'(var,vl) -> Def'(box_set? var, box_set? vl)
    | Or'(ors) -> Or'(List.map box_set? ors)
    | LambdaSimple'(params, body) -> LambdaSimple'(params,apply_box body)
    | LambdaOpt'(mandatory, optional, body) ->  LambdaOpt'(mandatory,optional, apply_box body)
    | Applic'(body, args) -> Applic'(box_set? body, List.map box_set? args)
    | ApplicTP'(body,args) -> ApplicTP'(box_set? body, List.map box_set? args)
    | _ -> raise X_no_match;;  
    



    

  
  
  let tp_test_string x = 
    annotate_TC (annotate_lexical (List.hd ((Tag_Parser.tag_parse_expressions (read_sexprs x)))) []) false;;

  let lexical_test_string x =
    annotate_lexical (List.hd ((Tag_Parser.tag_parse_expressions (read_sexprs x)))) [];;
  
  
    
module type SEMANTICS = sig
  val run_semantics : expr -> expr'
  val annotate_lexical_addresses : expr -> expr'
  val annotate_tail_calls : expr' -> expr'
  val box_set : expr' -> expr'
end;;


module Semantics : SEMANTICS = struct

let annotate_lexical_addresses e = 
  annotate_lexical e [];;


let annotate_tail_calls e = annotate_TC e false;;


(* implement!!!!!! *)
let box_set e = e;; 


let run_semantics expr =
  box_set
    (annotate_tail_calls
       (annotate_lexical_addresses expr));;
  
end;; (* struct Semantics *)




(* (lambda (x)
 --->
    (lambda (x) x (lambda () (set! x 3))
    (lambda () x))
*)

(*
  (lambda (x y z)
  
    (lambda (z)  (lambda ()  z)
    (lambda (z)  (lambda ()  (set! z 1))
  )

*)

(*  
major

(lambda (x)
  (lambda (z) 
    (set! x (+ z 1)))
    (lambda (w) z))


(lambda (x)
   (list 
   (set! x (+ x 1))
   (lambda () x)))


(lambda (x) 
    (list 
      (lambda () (set! x (+ x 1))) 
      (lambda () x)))


(lambda (x)
  (lambda () x)
  (lambda (y) (set! x (+ x y))))


(lambda (x)
    (set! x (+ x 1))
    (lambda (y) (+ x y)))


    seq [[] []] *)