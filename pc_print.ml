(* pc.ml
 * A parsing-combinators package for ocaml
 *
 * Prorammer: Mayer Goldberg, 2018
 *)

(* general list-processing procedures *)
#use "reader.ml";;
open Reader;;
#use "tag-parser.ml";;
open Tag_Parser;;
let rec ormap f s =
  match s with
  | [] -> false
  | car :: cdr -> (f car) || (ormap f cdr);;

let rec andmap f s =
  match s with
  | [] -> true
  | car :: cdr -> (f car) && (andmap f cdr);;	  

let lowercase_ascii  =
  let delta = int_of_char 'A' - int_of_char 'a' in
  fun ch ->
  if ('A' <= ch && ch <= 'Z')
  then char_of_int ((int_of_char ch) - delta)
  else ch;;

let string_to_list str =
  let rec loop i limit =
    if i = limit then []
    else (String.get str i) :: (loop (i + 1) limit)
  in
  loop 0 (String.length str);;

let list_to_string s =
  String.concat "" (List.map (fun ch -> String.make 1 ch) s);;

module PC = struct

(* the parsing combinators defined here *)
  
exception X_not_yet_implemented;;

exception X_no_match;;

let const pred =
  function 
  | [] -> raise X_no_match
  | e :: s ->
     if (pred e) then (e, s)
     else raise X_no_match;;

let caten nt1 nt2 s =
  let (e1, s) = (nt1 s) in
  let (e2, s) = (nt2 s) in
  ((e1, e2), s);;

let pack nt f s =
  let (e, s) = (nt s) in
  ((f e), s);;

let nt_epsilon s = ([], s);;

let caten_list nts =
  List.fold_right
    (fun nt1 nt2 ->
     pack (caten nt1 nt2)
	  (fun (e, es) -> (e :: es)))
    nts
    nt_epsilon;;

let disj nt1 nt2 =
  fun s ->
  try (nt1 s)
  with X_no_match -> (nt2 s);;

let nt_none _ = raise X_no_match;;
  
let disj_list nts = List.fold_right disj nts nt_none;;

let delayed thunk s =
  thunk() s;;

let nt_end_of_input = function
  | []  -> ([], [])
  | _ -> raise X_no_match;;

let rec star nt s =
  try let (e, s) = (nt s) in
      let (es, s) = (star nt s) in
      (e :: es, s)
  with X_no_match -> ([], s);;

let plus nt =
  pack (caten nt (star nt))
       (fun (e, es) -> (e :: es));;

let guard nt pred s =
  let ((e, _) as result) = (nt s) in
  if (pred e) then result
  else raise X_no_match;;
  
let diff nt1 nt2 s =
  match (let result = nt1 s in
	 try let _ = nt2 s in
	     None
	 with X_no_match -> Some(result)) with
  | None -> raise X_no_match
  | Some(result) -> result;;

let not_followed_by nt1 nt2 s =
  match (let ((_, s) as result) = (nt1 s) in
	 try let _ = (nt2 s) in
	     None
	 with X_no_match -> (Some(result))) with
  | None -> raise X_no_match
  | Some(result) -> result;;
	  
let maybe nt s =
  try let (e, s) = (nt s) in
      (Some(e), s)
  with X_no_match -> (None, s);;

(* useful general parsers for working with text *)

let make_char equal ch1 = const (fun ch2 -> equal ch1 ch2);;

let char = make_char (fun ch1 ch2 -> ch1 = ch2);;

let char_ci =
  make_char (fun ch1 ch2 ->
	     (lowercase_ascii ch1) =
	       (lowercase_ascii ch2));;

let make_word char str = 
  List.fold_right
    (fun nt1 nt2 -> pack (caten nt1 nt2) (fun (a, b) -> a :: b))
    (List.map char (string_to_list str))
    nt_epsilon;;

let word = make_word char;;

let word_ci = make_word char_ci;;

let make_one_of char str =
  List.fold_right
    disj
    (List.map char (string_to_list str))
    nt_none;;

let one_of = make_one_of char;;

let one_of_ci = make_one_of char_ci;;

let nt_whitespace = const (fun ch -> ch <= ' ');;

let make_range leq ch1 ch2 (s : char list) =
  const (fun ch -> (leq ch1 ch) && (leq ch ch2)) s;;

let range = make_range (fun ch1 ch2 -> ch1 <= ch2);;

let range_ci =
  make_range (fun ch1 ch2 ->
	      (lowercase_ascii ch1) <=
		(lowercase_ascii ch2));;

let nt_any (s : char list) = const (fun ch -> true) s;;

let trace_pc desc nt s =
  try let ((e, s') as args) = (nt s)
      in
      (Printf.printf ";;; %s matched the head of \"%s\", and the remaining string is \"%s\"\n"
		     desc
		     (list_to_string s)
		     (list_to_string s') ;
       args)
  with X_no_match ->
    (Printf.printf ";;; %s failed on \"%s\"\n"
		   desc
		   (list_to_string s) ;
     raise X_no_match);;

(* testing the parsers *)

let unread_number = function
| Fraction(n1,n2) -> Printf.sprintf "%d/%d" n1 n2
| Float(f) -> Printf.sprintf "%f" f

let unread_char c = 
match c with
| '\n' -> "#\newline"
| '\t' -> "#\tab"
| ' ' -> "#\space"
(* Fuck it...Skipping the rest of the named chars *)
| _ -> Printf.sprintf "#\\%c" c;;

let rec unread sexpr = 
match sexpr with
| Nil -> "()"
| Bool(true) -> "#t"
| Bool(false) -> "#f"
| Number(n) -> unread_number n
| Char(c) -> unread_char c
| String(s) -> Printf.sprintf "\"%s\"" s (* Fuck it...Skipping string meta chars *)
| Symbol(s) -> s
| Pair(s1, s2) -> unread_list sexpr

and unread_list = function
| Pair(a, b) -> Printf.sprintf " %s%s" (unread a) (unread_list b)
| Nil -> ")"
| sexpr -> Printf.sprintf "%s)" (unread sexpr);;

let untag expr = 
let rec untag_rec expr is_nested = 
match expr with
| Const(Sexpr(s)) -> unread s
| Const(Void) when is_nested -> "#<void>"
| Const(Void) -> ""
| Var(name) -> unread (Symbol(name))
| If(test, dit, dif) -> Printf.sprintf "(if %s %s %s)" (untag_nested test) (untag_nested dit) (untag_nested dif)
| Seq(exprs) -> Printf.sprintf "(begin %s)" (untag_list exprs)
| Or(exprs) ->  Printf.sprintf "(or %s)" (untag_list exprs)
| Set(expr1, expr2) -> Printf.sprintf "(set! %s %s)" (untag_nested expr1) (untag_nested expr2)
| Def(expr1, expr2) -> Printf.sprintf "(define %s %s)" (untag_nested expr1) (untag_nested expr2)
| LambdaSimple(args, expr) -> Printf.sprintf "(lambda (%s) %s)" (String.concat " " args) (untag_nested expr)
| LambdaOpt([], arg, expr) -> Printf.sprintf "(lambda %s %s)" arg (untag_nested expr)
| LambdaOpt(args, arg, expr) -> Printf.sprintf "(lambda (%s . %s) %s)" (String.concat " " args) arg (untag_nested expr)
| Applic(expr, args) -> Printf.sprintf "(%s %s)" (untag_nested expr) (untag_list args) 
and untag_nested expr = untag_rec expr true 
and untag_list exprs = String.concat " " (List.map untag_nested exprs) in
untag_rec expr false

let print_exprs exprs = 
let exprs = List.map untag exprs in
Printf.printf "%s\n" (String.concat "\n" exprs);;


let test_string nt str =
  let (e, s) = (nt (string_to_list str)) in
  (e, (Printf.sprintf "->[%s]" (list_to_string s)));;

end;; (* end of struct PC *)

(* end-of-input *)
