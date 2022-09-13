open Effect
open Effect.Deep

type _ Effect.t += E : string Effect.t

let print () =
  print_string "0";
  print_string (perform E);
  print_string "3"

let main () =
  match_with print () {
    retc = (fun res -> res);
    exnc = raise;
    effc = fun (type a) (eff: a t) ->
      match eff with
      | E ->
          Some (fun (k: (a, _) continuation) ->
           print_string "1";
           continue k "2";
           print_endline "4")
      | _ -> None
  }

let () =
  main ()
