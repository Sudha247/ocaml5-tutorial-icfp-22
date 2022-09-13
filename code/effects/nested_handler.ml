type _ Effect.t +=
  | A : unit Effect.t
  | B : unit Effect.t

let baz () =
 perform A

let bar () =
 try_with baz () {
  effc = fun (type a) (eff: a t) ->
    match eff with
    | B -> Some (fun (k: (a, _) continuation) -> continue k () ) )
    | _ -> None
 }

let foo () =
  try_with bar () {
    effc = fun (type a) (eff: a t) ->
      match eff with
      | A -> Some (fun (k: (a, _) continuation) -> continue k ())
      | _ -> None
  }
