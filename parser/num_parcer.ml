(* num_parcer.ml
 * A parsing-numbers package for ocaml
 *
 * Prorammer: michael and elad 2020
 *)

 #use "pc.ml";;
 open PC;;
 type expr = Exp of expr * expr |
              Mul of expr list |
              Add of expr list |
              Num of int;;
        
 let nt_whitespaces = star (char ' ');;
 
 let digit = range '0' '9';;
 
 let make_paired nt_left nt_right nt =
 let nt = caten nt_left nt in
 let nt = pack nt (function (_, e) -> e) in
 let nt = caten nt nt_right in
 let nt = pack nt (function (e, _) -> e) in
   nt;;
 
 let make_spaced nt = make_paired nt_whitespaces nt_whitespaces nt;;
 
 let tok_lparen = make_spaced ( char '(');;
 
 let tok_rparen = make_spaced ( char ')');;
 
 let tok_addop = make_spaced ( char '+');;
 
 let tok_mulop = make_spaced ( char '*');;
 
 let tok_expop =
  let caret = char '^' 
  and right_spaced = make_paired nt_epsilon nt_whitespaces in
  right_spaced caret;;
 
 let tok_num =
 let digits = plus digit in
   pack digits (fun (ds) -> Num (int_of_string (list_to_string ds)));;
 
 let rec nt_paren s =
 let nt_nested = pack (caten (caten tok_lparen nt_expr) tok_rparen)
  (fun ((l, e), r) -> e) in
  (disj tok_num nt_nested) s
 
 
  and nt_exp s =
  let head = star (pack (caten nt_paren tok_expop) (fun (p, o) -> p)) in
  let tail = nt_paren in
  let chain = caten head tail in
  let packed = pack chain
  (fun (hd, tl) -> match hd with
  | [] -> tl
  | hd -> List.fold_right (fun e aggr -> Exp (e, aggr))  hd tl) in
  packed s
 
  and nt_mul s =
  let head = nt_exp in
  let tail = star (pack (caten tok_mulop nt_exp)(fun (o, p) -> p)) in
  let chain = caten head tail in
  let packed = pack chain
  (fun (hd, tl) -> match tl with
  | [] -> hd
  | _ -> Mul (hd::tl)) in
  packed s
 
  and nt_add s =
  let head = nt_mul in
  let tail = (star (pack (caten tok_addop nt_mul) (fun (o, p) -> p))) in
  let chain = caten head tail in
  let packed = pack chain
  (fun (hd, tl) -> match tl with
  | [] -> hd
  | _ -> Add (hd::tl)) in
  packed s
  and nt_expr s = nt_add s;;
 
 let extract_AST (ast,rest) = if rest = [] then ast else raise X_no_match;;
 
 (* the "|>" operator is the reverse application operator, so f |> y = y f.
      It behaves similarly to the pipe operator in a shell *)
 let exp x y = (float_of_int x) ** (float_of_int y) |> int_of_float
   
 let rec eval = function
   | Num(n) -> n
   | Exp(b, e) -> exp (eval b) (eval e)
   | Mul(l) -> List.fold_left
                 (fun prod operand -> prod * (eval operand)) 1 l
   |Add(l) -> List.fold_left 
                (fun sum operand -> sum + (eval operand)) 0 l;;