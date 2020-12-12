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



  let ext_env params env = 
      params::env;;
    
  let rec find_read exp depth env cur_closure_params= 
    match exp with
    | Const'(x) -> []
    | If'(test,dit,dif) ->  if_read test dit dif depth env cur_closure_params
    | LambdaSimple'(params,body) -> find_read body (depth + 1) (ext_env cur_closure_params env) params
    | LambdaOpt'(mandatory, optional, body) -> find_read body (depth + 1) (ext_env cur_closure_params env) (List.append mandatory [optional])
    | Or'(ors) -> List.fold_left (fun acc exp -> (List.append (find_read exp depth env cur_closure_params) acc) ) [] ors
    | Set'(_,vl) -> find_read vl depth env cur_closure_params
    | Seq'(seq) ->  List.fold_left (fun acc exp -> List.append (find_read exp depth env cur_closure_params) acc ) [] seq
    | Def'(_,vl) -> find_read vl depth env cur_closure_params
    | Applic'(body,args) -> List.append (find_read body depth env cur_closure_params) (List.fold_left (fun acc exp -> List.append (find_read exp depth env cur_closure_params) acc ) [] args)
    | ApplicTP'(body,args) -> List.append (find_read body depth env cur_closure_params) (List.fold_left (fun acc exp -> List.append (find_read exp depth env cur_closure_params) acc ) [] args)
    | Var'(VarFree(name)) -> []
    | Var'(VarParam(name,minor)) -> if (depth == 0) then [VarParam(name,minor),env] else []
    | Var'(VarBound(name,major,minor)) -> if (depth -1 == major) then [VarBound(name,major,minor),env] else []
    | _ -> []


    and if_read test dit dif depth env cur_closure_params= 
      let test_read = find_read test depth env cur_closure_params in
      let dit_read = find_read dit depth env cur_closure_params in
      let dif_read = find_read dif depth env cur_closure_params in
      List.append (List.append test_read dit_read) dif_read;;


      let rec find_write exp depth env cur_closure_params= 
        match exp with
        | Const'(x) -> []
        | If'(test,dit,dif) ->  if_write test dit dif depth env cur_closure_params
        | LambdaSimple'(params,body) -> find_write body (depth + 1) (ext_env cur_closure_params env) params
        | LambdaOpt'(mandatory, optional, body) -> find_write body (depth + 1) (ext_env cur_closure_params env) (List.append mandatory [optional])
        | Or'(ors) -> List.fold_left (fun acc exp -> (List.append (find_write exp depth env cur_closure_params) acc) ) [] ors
        | Set'(vr,vl) -> List.append (write_var vr depth env) (find_write vl depth env cur_closure_params)
        | Seq'(seq) ->  List.fold_left (fun acc exp -> List.append (find_write exp depth env cur_closure_params) acc ) [] seq
        | Def'(vr,vl) -> List.append (write_var vr depth env) (find_write vl depth env cur_closure_params)
        | Applic'(body,args) -> List.append (find_write body depth env cur_closure_params) (List.fold_left (fun acc exp -> List.append (find_write exp depth env cur_closure_params) acc ) [] args)
        | ApplicTP'(body,args) -> List.append (find_write body depth env cur_closure_params) (List.fold_left (fun acc exp -> List.append (find_write exp depth env cur_closure_params) acc ) [] args)
        | Var'(VarFree(name)) -> []
        | Var'(VarParam(name,minor)) -> []
        | Var'(VarBound(name,major,minor)) -> []
        | _ -> []
    
        and write_var vr depth env = 
          match vr with
          | VarParam(name,minor) -> if (depth == 0) then [VarParam(name,minor),env] else []
          | VarBound(name,major,minor) -> if (depth - 1 == major) then [VarBound(name,major,minor),env] else []
          | VarFree(name) -> []

        and if_write test dit dif depth env cur_closure_params= 
          let test_write = find_write test depth env cur_closure_params in
          let dit_write = find_write dit depth env cur_closure_params in
          let dif_write = find_write dif depth env cur_closure_params in
          List.append (List.append test_write dit_write) dif_write;;

    let find_read_test str =
      let expr_tag = (annotate_lexical (List.hd ((Tag_Parser.tag_parse_expressions (read_sexprs str)))) []) in
      let LambdaSimple'(params,body) = expr_tag in
      find_read body 0 [] params;;

      let find_write_test str =
        let expr_tag = (annotate_lexical (List.hd ((Tag_Parser.tag_parse_expressions (read_sexprs str)))) []) in
        let LambdaSimple'(params,body) = expr_tag in
        find_write body 0 [] params;;

  let rec exist element lst =
    match lst with 
    | hd::tail -> if (hd = element) then true else (exist element tail)
    | [] -> false;; 
    
  let rec remove_dups lst = 
      match lst with
      | first::rest -> if (exist first rest) then (remove_dups rest) else first::(remove_dups rest)
      | [] -> [];;
  
  let find_read_write params rib  =
    let read = remove_dups (find_read  rib 0  [] params) in 
    let write =remove_dups (find_write rib 0  [] params) in
    (read, write);; 


  let var_match var1 env1 var2 env2 =
    match var1, var2 with
    | VarParam(name1,minor1) , VarBound(name2,major2,minor2) -> if ((name1 = name2) & (!common_ancestor(env1,env2))) then true else false
    | VarParam(name1, minor1), VarParam(name2, minor2) -> if ((name1 = name2) & (!common_ancestor(env1,env2))) then true else false
    | VarBound(name1, major1, minor1), VarParam(name2,minor2) -> if ((name1 = name2) & (!common_ancestor(env1,env2))) then true else false
    | VarBound(name1, major1, minor1), VarBound(name2, major2, minor2) -> if ((name1 = name2) & (!common_ancestor(env1,env2))) then true else false;;

  let rec get_need_to_be_boxed_vars params body =
    match body with
    | Const'(x) -> []
    | Var'(var) ->  []
    | If'(test,dit,dif) -> if_ribs_with_box test dit dif
    | Seq'(seq) -> (* seq_ribs_with_box seq params *) []
    | Set'(var,vl) -> []
    | Def'(var,vl) -> []
    | Or'(ors) -> []
    | LambdaSimple'(params, body) ->  
    | LambdaOpt'(mandatory, optional, body) -> 
    | Applic'(body, args) -> applic_with_box body args params
    | ApplicTP'(body,args) ->   
    | _ -> raise X_no_match

    (* and seq_ribs_with_box seq params=
      let vars = List.map (fun (rib) find_read_write params rib) seq in *)
    and applic_with_box body args params =
      let body_read  = find_read  body 0 [] params in
      let body_write = find_write body 0 [] params in
      let args_read  = List.map (fun arg -> find_read  arg 0 [] params) args in
      let args_write = List.map (fun arg -> find_write arg 0 [] params) args in
      let all_read  = body_read ::args_read  in
      let all_write = body_write::args_write in
      List.filter (fun (Var'(var1),env1) -> List.exists (fun (Var'(var2),env2) ->  (var_match var1 env1 var2 env2) ) all_write) all_read
      List.map (fun rib_read_list -> List.map (fun (Var'(var1),env1)-> ) rib_read_list ) all_read
      
       
     r: [(Var1,env) ; (Var2, env)]
     w: 

     
      (lambda (x) 
        ( (lambda (y) x) (set! x 1) )
      )

      (lambda (x)
        (list (lambda () x) (lambda () (set! x 1)))
      )

      apply_box:
      params: ["x"]
      body: ((lambda (y) x) (set! x 1))

      applic_with_box:
      body: (lambda (y) x)  r:[vb(x):0,0]
      args: (set! x 1)      w:[vp(x):0]
      params: ["x"]

      (lambda (x)
        ((lambda () (set! x 1)) x)
      )
    (* (lambda (x) (lambda () (lambda () (lambda () x) (lambda () (set! x 1)) ) ) )
    *)

  let rec apply_box params body =
    let need_to_be_boxed = get_need_to_be_boxed_vars params body in
    Const'(Void)
    (* 1. now box the vars in the tree *)
    (* 2. make sure to return same expr' as called this function e.g LambdaSimple' / LambdaOpt' *)

  let rec reach_lambda e =
    match e with
    | Const'(x) -> Const'(x)
    | Var'(var) -> Var'(var)
    | If'(test,dit,dif) -> If'(reach_lambda test,reach_lambda dit, reach_lambda dif)
    | Seq'(seq) -> Seq'(List.map reach_lambda seq)
    | Set'(var,vl) -> Set'(var, reach_lambda vl)
    | Def'(var,vl) -> Def'(var, reach_lambda vl)
    | Or'(ors) -> Or'(List.map reach_lambda ors)
    | LambdaSimple'(params, body) -> apply_box params (reach_lambda body)
    | LambdaOpt'(mandatory, optional, body) ->  apply_box (List.append mandatory [optional]) (reach_lambda body)
    | Applic'(body, args) -> Applic'(reach_lambda body, List.map reach_lambda args)
    | ApplicTP'(body,args) -> ApplicTP'(reach_lambda body, List.map reach_lambda args)
    | _ -> raise X_no_match;;  

 
    
  

(* 
    1 -> find read write  -> two arrays 
    2 -> build a list of need-to-be-boxed vars -> list of string 
    3 -> change tree to apply boxing -> tree
*)




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


(* הערות:
בודק אם הפרמטר שאנחנו קוראים כרגע מתייחס ללמדה שממנה התחלנו את הבדיקה if (depth - 1 == major) איפה שבדקנו 
כלומר במצב כזה
(lambda (x)
  (lambda () x))
 הפרמטר איקס כן יכנס לרשימת קריאה 
אבל במצב כזה 
(lambda (x)
  (lambda (x) x))
הפרמטר איקס לא יכנס לרשימת קריאה כי הוא לא מתייחס לפרמטר מהלמדה שאנחנו בודקים
לכן הבדיקה הזו לא באמת מתייחסת לדרישה שלא יהיה אב משותף בין הריב שקורא לריב שכותב
בגלל זה הפכתי את הרשימת קריאה לזוג של משתנה(כולל המיינור והמייג'ור) ושל הסביבה בזמן השימוש בו
ככה אחרי שנמצא שני משתנים חשודים שעלולים להתנגש נבדוק לפי הסביבות שלהם אם יש להם אב משותף (לפי הפוינטר ולא לפי ערך, בדקתי עובד ) 

 ?לא עשיתי אפליי_בוקס רק על הבאדי reach_lambda למה בפונקציה
 כי אז הייתי מאבד את פאראמס ולא הייתי יכול להשתמש בהם כדי להרחיב את הסביבה 

 why i added the cur_closur_params in find_read ?
 because we always get into this function in context of lambda and if we call it with body only
 we will lose the params and won't be able to extend the env 
*)


(* (lambda (x)
    d:0 (lambda ()
        (list 
          (lambda () d:1 vb:1,0 x)
          (lambda () (set! x 1))
        )
      ) 
    )    
  ) 
*)

(* 
"(lambda (x) 
  (lambda ()
    (lambda () x) 
    (set! x 1) 
  )
 )"

[ ([(VarBound ("x", 0, 0), [["x"]])], []);
  ([], [(VarParam ("x", 0), [])])]




  "
  (lambda (x) 
    (lambda () x) 
    (lambda () (set! x 1) )
  )"

[   ([(VarBound ("x", 0, 0), [["x"]])], [])   ;                                     
    ([], [(VarBound ("x", 0, 0), [["x"]])])    ]




    (lambda (x) 
      (set! x (+ x 1)) 
      (lambda (y) (+ x y))
    )

    Seq'( [... ; <write-occur> ; ... ; E ; ...]) where E contains <read occur>
    VarBound(1,0) --> VarBound(1,0)
    VarParam(0)



    Seq' ([...; <read-occur>; ...; E; ...])  *)


    (lambda (x) 
      ((lambda (y) (set! x 2)) x)
    )

    (lambda (y x)
      ((lambda (x) x) (set! x 1))
    )

    (lambda (x)
      (list 
        ((lambda () x))
        (lambda (set! x 1))
      )
    )

