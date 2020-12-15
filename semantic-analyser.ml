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


exception X_my_exception of expr';;
type env = Env of string list;;

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



  let ext_env params env = 
      params::env;;
  
  let read_write_append (r_lst1,w_lst1) (r_lst2,w_lst2) =
      (List.append r_lst1 r_lst2,List.append w_lst1 w_lst2)

  let rec find_read_write exp depth env cur_closure_params= 
    match exp with
    | Const'(x) -> ([],[])
    | If'(test,dit,dif) ->  if_read_write test dit dif depth env cur_closure_params
    | LambdaSimple'(params,body) -> find_read_write body (depth + 1) (ext_env cur_closure_params env) (Env params)
    | LambdaOpt'(mandatory, optional, body) -> find_read_write body (depth + 1) (ext_env cur_closure_params env) (Env((List.append mandatory [optional])))
    | Or'(ors) -> List.fold_left (fun acc exp -> (read_write_append acc (find_read_write exp depth env cur_closure_params)) ) ([],[]) ors
    | Set'(vr,vl) -> let (reads,writes) = find_read_write vl depth env cur_closure_params in
                      (reads,List.append (write_var vr depth env cur_closure_params) writes)
    | Seq'(seq) ->  List.fold_left (fun acc exp -> read_write_append acc (find_read_write exp depth env cur_closure_params)) ([],[]) seq
    | Def'(vr,vl) -> let (reads,writes) = find_read_write vl depth env cur_closure_params in  
                      (reads,List.append (write_var vr depth env cur_closure_params) writes )
    | Applic'(body,args) -> read_write_append (find_read_write body depth env cur_closure_params) (List.fold_left (fun acc exp -> read_write_append acc (find_read_write exp depth env cur_closure_params) ) ([],[]) args)
    | ApplicTP'(body,args) -> read_write_append (find_read_write body depth env cur_closure_params) (List.fold_left (fun acc exp -> read_write_append acc (find_read_write exp depth env cur_closure_params) ) ([],[]) args)
    | Var'(VarFree(name)) -> ([],[])
    | Var'(VarParam(name,minor)) -> if (depth == 0) then ([name, cur_closure_params::env],[]) else ([],[])
    | Var'(VarBound(name,major,minor)) -> if (depth -1 == major) then ([name, cur_closure_params::env],[]) else ([],[])
    | BoxSet'(vr,vl) -> find_read_write vl depth env cur_closure_params
    | BoxGet'(vr) -> ([],[])
    | Box'(var) -> ([],[])


    and if_read_write test dit dif depth env cur_closure_params= 
      let test_read = find_read_write test depth env cur_closure_params in
      let dit_read = find_read_write dit depth env cur_closure_params in
      let dif_read = find_read_write dif depth env cur_closure_params in
      read_write_append (read_write_append test_read dit_read) dif_read

      and write_var vr depth env params= 
      match vr with
      | VarParam(name,minor) -> if (depth == 0) then [name, params::env] else []
      | VarBound(name,major,minor) -> if (depth - 1 == major) then [name, params::env] else []
      | VarFree(name) -> [];;
  
  let get_read_write params expr  =
    find_read_write expr 0 [] (Env(params));;

  let get_list (env:env) =
    let Env(lst) = env in
    lst;;

  let rec is_common_ancestor (env1:env list) (env2:env list) var = 
    match env1 with
    | first::rest -> if ((List.exists (fun x -> x == first) env2) && (not (List.mem var (get_list first)))) then true else is_common_ancestor rest env2 var
    | [] -> false;; 


  let get_var_name var =
    match var with
    | Var'(VarParam(name,_)) -> name
    | Var'(VarBound(name,_,_)) -> name 
    | Var'(VarFree(name)) -> name
    | _ -> raise X_no_match ;;

  let var_match var1 env1 var2 env2 =
    let rec same_rib (env1:env list) (env2:env list) = 
      match env1,env2 with
     | first::rest , [] -> false
     | [] , first::rest -> false
     | [] , [] -> true
     | first1::rest1 , first2::rest2 -> if (first1 == first2) then same_rib rest1 rest2 else false in
    if ( (var1 = var2) && (not (is_common_ancestor env1 env2 var1)) && (not (same_rib env1 env2))) then true else false 

    let ignore_to_var_list ignores=
      let extract_var_from_ignore ignore = 
        match ignore with 
        | (VarBound(name,major,minor), _) -> name
        | _ -> "error" in
      List.map (fun ignore -> extract_var_from_ignore ignore) ignores;;

    let in_dont_ignore vr dont_ignore_read = 
      match vr with
      | VarParam(name,minor) -> List.mem name (ignore_to_var_list dont_ignore_read)
      | VarBound(name,major,minor) -> List.mem name (ignore_to_var_list dont_ignore_read)
      | VarFree(name) -> false;;

    let append_to_dont_ignore vr depth dont_ignore env params =
      match vr with 
      | VarParam(name,minor) -> dont_ignore
      | VarBound(name,major,minor) -> if (depth -1 == major) then (VarBound(name,major,minor),params::env)::dont_ignore else dont_ignore
      | VarFree(name) -> dont_ignore;;
    
    let foursome_append (rlist1,wlist1,dir1,diw1) (rlist2,wlist2,dir2,diw2) =
        let dont_ignore_read  = List.fold_left (fun acc var -> if (not (List.mem var dir1)) then var::acc else acc) dir1 dir2 in
        let dont_ignore_write  = List.fold_left (fun acc var -> if (not (List.mem var dir1)) then var::acc else acc) diw1 diw2 in
        (List.append rlist1 rlist2,List.append wlist1 wlist2,dont_ignore_read,dont_ignore_write)

    let rec third_rule_find_read_write exp depth env cur_closure_params dont_ignore_read dont_ignore_write = 
      match exp with
      | Const'(x) -> ([],[], dont_ignore_read, dont_ignore_write)
      | If'(test,dit,dif) ->  third_rule_if_read_write test dit dif depth env cur_closure_params dont_ignore_read dont_ignore_write
      | LambdaSimple'(params,body) -> third_rule_find_read_write body (depth + 1) (ext_env cur_closure_params env) (Env params) dont_ignore_read dont_ignore_write
      | LambdaOpt'(mandatory, optional, body) -> third_rule_find_read_write body (depth + 1) (ext_env cur_closure_params env) (Env((List.append mandatory [optional]))) dont_ignore_read dont_ignore_write
      | Or'(ors) -> List.fold_left (fun acc exp -> (foursome_append acc (third_rule_find_read_write exp depth env cur_closure_params dont_ignore_read dont_ignore_write)) ) ([],[], dont_ignore_read, dont_ignore_write) ors
      | Set'(vr,vl) -> let (reads,writes, dont_ignore_read1, dont_ignore_write1) = third_rule_find_read_write vl depth env cur_closure_params dont_ignore_read dont_ignore_write in
                        let writes = if (in_dont_ignore vr dont_ignore_read) 
                        then
                         List.append (write_var vr depth env cur_closure_params) writes 
                        else 
                        writes in
                        (reads, writes, dont_ignore_read1, (append_to_dont_ignore vr depth dont_ignore_write1 env cur_closure_params))
      | Seq'(seq) ->  List.fold_left (fun acc exp -> foursome_append acc (third_rule_find_read_write exp depth env cur_closure_params dont_ignore_read dont_ignore_write)) ([],[], dont_ignore_read, dont_ignore_write) seq
      | Def'(vr,vl) -> let (reads,writes, dont_ignore_read1, dont_ignore_write1) = third_rule_find_read_write vl depth env cur_closure_params dont_ignore_read dont_ignore_write in  
                        let writes = if (in_dont_ignore vr dont_ignore_read) 
                        then 
                        List.append (write_var vr depth env cur_closure_params) writes 
                        else 
                        writes in
                        (reads, writes, dont_ignore_read1, (append_to_dont_ignore vr depth dont_ignore_write1 env cur_closure_params))
      | Applic'(body,args) -> foursome_append (third_rule_find_read_write body depth env cur_closure_params dont_ignore_read dont_ignore_write) (List.fold_left (fun acc exp -> foursome_append acc (third_rule_find_read_write exp depth env cur_closure_params dont_ignore_read dont_ignore_write) ) ([],[],dont_ignore_read,dont_ignore_write) args)
      | ApplicTP'(body,args) -> foursome_append (third_rule_find_read_write body depth env cur_closure_params dont_ignore_read dont_ignore_write) (List.fold_left (fun acc exp -> foursome_append acc (third_rule_find_read_write exp depth env cur_closure_params dont_ignore_read dont_ignore_write) ) ([],[],dont_ignore_read,dont_ignore_write) args)
      | Var'(VarFree(name)) -> ([],[], dont_ignore_read, dont_ignore_write)
      | Var'(VarParam(name,minor)) -> if (depth == 0) && (List.mem name (ignore_to_var_list dont_ignore_write)) then ([name, cur_closure_params::env],[], dont_ignore_read, dont_ignore_write) else ([],[], dont_ignore_read, dont_ignore_write)
      | Var'(VarBound(name,major,minor)) -> if (depth -1 == major) && (List.mem name (ignore_to_var_list dont_ignore_write)) then
                                             ([name, cur_closure_params::env],[], (VarBound(name,major,minor), cur_closure_params::env)::dont_ignore_read, dont_ignore_write ) else 
                                             if (depth -1 == major) then
                                              ([],[], (VarBound(name,major,minor), cur_closure_params::env)::dont_ignore_read, dont_ignore_write)
                                              else ([],[], dont_ignore_read, dont_ignore_write)
      | BoxSet'(vr,vl) -> third_rule_find_read_write vl depth env cur_closure_params dont_ignore_read dont_ignore_write
      | BoxGet'(vr) -> ([],[], dont_ignore_read, dont_ignore_write)
      | Box'(var) -> ([],[], dont_ignore_read, dont_ignore_write)


      and third_rule_if_read_write test dit dif depth env cur_closure_params dont_ignore_read dont_ignore_write= 
      let test_read = third_rule_find_read_write test depth env cur_closure_params dont_ignore_read dont_ignore_write in
      let dit_read = third_rule_find_read_write dit depth env cur_closure_params dont_ignore_read dont_ignore_write in
      let dif_read = third_rule_find_read_write dif depth env cur_closure_params dont_ignore_read dont_ignore_write in
      foursome_append (foursome_append test_read dit_read) dif_read

  let ignore_to_env ignores =
    let extract_env ignore =
      match ignore with 
      | (VarBound(name,major,minor), env) -> (name, env)
      | _ -> raise X_no_match in
    List.map (fun ignore -> extract_env ignore) ignores;;

  let third_rule params body = 
      let get_dont_ignore_read = (fun (a,b,c,d) -> c) in
      let get_dont_ignore_write = (fun (a,b,c,d) -> d) in
      let get_r_w = (fun (a,b,c,d) -> (List.append a (ignore_to_env c), List.append b (ignore_to_env d))) in
      match body with
      | Seq'(ribs) ->get_r_w (List.fold_left (fun acc rib -> (foursome_append (third_rule_find_read_write rib 0 [] (Env params) (get_dont_ignore_read acc) (get_dont_ignore_write acc)) acc )) ([],[],[],[])  ribs)
      | _ -> get_read_write params body;;




  let rec get_need_to_be_boxed_vars params body =
    if (params = [] ) then [] else 
    let (reads,writes) = third_rule params body in
    let lst = (List.fold_left (fun acc (var1, env1) -> if (List.exists (fun (var2, env2) -> var_match var1 env1 var2 env2) writes) then var1::acc else acc ) [] reads) in
    List.fold_right (fun param acc  -> if (List.mem param lst) then param::acc else acc) params []

  let rec box_var var_name body =
    match body with
    | Const'(x) -> Const'(x)
    | If'(test,dit,dif) ->  If'(box_var var_name test,box_var var_name dit,box_var var_name dif)
    | LambdaSimple'(params,body) -> if (List.mem var_name params) then LambdaSimple'(params,body) else LambdaSimple'(params,box_var var_name body)
    | LambdaOpt'(mandatory, optional, body) -> if (List.mem var_name (List.append mandatory [optional])) then LambdaOpt'(mandatory, optional, body) else LambdaOpt'(mandatory, optional,box_var var_name body)
    | Or'(ors) -> Or'(List.map (fun expr -> box_var var_name expr) ors)
    | Set'(vr,Box'(vr2)) -> Set'(vr,Box'(vr2))
    | Set'(vr,vl) -> if ((get_var_name (Var'(vr))) = var_name) then BoxSet'(vr,box_var var_name vl) else Set'(vr,box_var var_name vl)
    | Seq'(seq) ->  Seq'(List.map (fun expr -> box_var var_name expr) seq)
    | Def'(vr,vl) -> Def'(vr,box_var var_name vl)
    | Applic'(body,args) -> Applic'(box_var var_name body,List.map (fun arg -> box_var var_name arg) args)
    | ApplicTP'(body,args) -> ApplicTP'(box_var var_name body,List.map (fun arg -> box_var var_name arg) args)
    | Var'(VarFree(name)) -> Var'(VarFree(name))
    | Var'(VarParam(name,minor)) -> if (name = var_name) then BoxGet'(VarParam(name,minor)) else Var'(VarParam(name,minor)) 
    | Var'(VarBound(name,major,minor)) -> if (name = var_name) then BoxGet'(VarBound(name,major,minor)) else Var'(VarBound(name,major,minor))
    | Box'(vr) -> Box'(vr)
    | BoxGet'(vr) -> BoxGet'(vr)
    | BoxSet'(vr,vl) -> BoxSet'(vr,box_var var_name vl) 

  let find_param_minor var_name params =
    index_of params var_name;;

  (* add Set'(VarParam(v, minor), Box'(VarParam(v,minor))) in the begging of the lambda *)
  let add_set_box body vars params=
    let sets= List.map (fun var_name -> Set'(VarParam(var_name, find_param_minor var_name params),Box'(VarParam(var_name,find_param_minor var_name params)))) vars in
    match body with 
    | Seq'(seq) -> Seq'(List.append sets seq)
    | expr -> Seq'(List.append sets [expr])

  let rec apply_box expr =
    let (params,body) = match expr with 
                        | LambdaSimple'(params,body) -> (params,body)
                        | LambdaOpt'(mandatory, optional, body) -> ((List.append mandatory [optional]),body)
                        | _ -> raise (X_my_exception expr) in
    if (params = []) then expr else
    let need_to_be_boxed = get_need_to_be_boxed_vars params body in 
    if (need_to_be_boxed = [] ) then expr else
    let new_body = add_set_box body need_to_be_boxed params in
    let new_body = List.fold_left (fun acc var -> box_var var acc) new_body need_to_be_boxed in
    match expr with 
    | LambdaSimple'(params,_) -> LambdaSimple'(params,new_body)
    | LambdaOpt'(mandatory, optional, _) -> LambdaOpt'(mandatory, optional, new_body)
    | _ -> raise (X_my_exception expr)

  let rec reach_lambda e =
    match e with
    | Const'(x) -> Const'(x)
    | Var'(var) -> Var'(var)
    | If'(test,dit,dif) -> If'(reach_lambda test,reach_lambda dit, reach_lambda dif)
    | Seq'(seq) -> Seq'(List.map reach_lambda seq)
    | Set'(var,vl) -> Set'(var, reach_lambda vl)
    | Def'(var,vl) -> Def'(var, reach_lambda vl)
    | Or'(ors) -> Or'(List.map reach_lambda ors)
    | LambdaSimple'(params, body) -> apply_box (LambdaSimple'(params,reach_lambda body))
    | LambdaOpt'(mandatory, optional, body) -> apply_box (LambdaOpt'(mandatory, optional,reach_lambda body))
    | Applic'(body, args) -> Applic'(reach_lambda body, List.map reach_lambda args)
    | ApplicTP'(body,args) -> ApplicTP'(reach_lambda body, List.map reach_lambda args)
    | _ -> raise (X_my_exception e);;  

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


(* implement!!!!! *)
let box_set e =  reach_lambda e;; 


let run_semantics expr =
  box_set
    (annotate_tail_calls
       (annotate_lexical_addresses expr));;
  
end;; (* struct Semantics *)


let test_semantics str = Semantics.run_semantics (List.hd (Tag_Parser.tag_parse_expressions (read_sexprs str)));;

let test_find_read_write str =
  let expr_tag = (annotate_lexical (List.hd ((Tag_Parser.tag_parse_expressions (read_sexprs str)))) []) in
  let LambdaSimple'(params,body) = expr_tag in
  find_read_write body 0 [] (Env params);;

let test_tp_string x = 
  annotate_TC (annotate_lexical (List.hd ((Tag_Parser.tag_parse_expressions (read_sexprs x)))) []) false;;

let test_lexical_string x =
  annotate_lexical (List.hd ((Tag_Parser.tag_parse_expressions (read_sexprs x)))) [];;

let test_get_need_to_be_boxed_vars str = 
  let expr_tag = (annotate_lexical (List.hd ((Tag_Parser.tag_parse_expressions (read_sexprs str)))) []) in
  let LambdaSimple'(params,body) = expr_tag in
  get_need_to_be_boxed_vars params body;;