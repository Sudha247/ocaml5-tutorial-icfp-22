open Effect
open Effect.Deep

type _ Effect.t += Increment : int Effect.t

let add () =
  (perform Increment) + (perform Increment)

let main () =
  let increment_by = ref 0 in
  match_with add () {
    retc = (fun res -> Format.printf "%d\n" res);
    exnc = raise;
    effc = fun (type a) (eff: a t) ->
      match eff with
      | Increment ->
          Some (fun (k: (a, _) continuation) ->
            incr increment_by;
            continue k !increment_by)
      | _ -> None
  }

let () =
  main ()
