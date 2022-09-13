type _ Effect.t += Ohno : exn -> 'a Effect.t

let raise'' (e : exn) : 'a =
  Effect.perform (Ohno e)

let try_with (f : unit -> 'a) (h : exn -> 'a) : 'a =
  Effect.Deep.match_with f () {
    retc = Fun.id;
    exnc = raise;
    effc = fun (type a) (eff: a Effect.t) -> 
      match eff with
      | Ohno e ->
          Some (fun (_k: (a, _) Effect.Deep.continuation) -> h e)
      | _ -> None
  }

exception Invalid_argument

(** [sqrt f] returns the square root of [f].
    @raise Invalid_argument if f < 0. *)
let sqrt f =
  if f < 0.0 then raise'' Invalid_argument
  else sqrt f

let _ =
  try_with (fun () ->
    let r = sqrt 42.42 in
    Printf.printf "%f\n%!" r;
    let r = sqrt (-1.0) in
    Printf.printf "%f\n" r)
  (function Invalid_argument -> Printf.printf "Invalid_argument to sqrt\n" | _ -> Printf.printf "Unknown exception")

(* Prints:
   6.513064
   Invalid_argument to sqrt *)
