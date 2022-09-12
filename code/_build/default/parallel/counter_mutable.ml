let v = ref 0

let incr n () =
  for _i = 1 to n do
    incr v
  done

let () =
  incr 100000 ();
  Printf.printf "v = %d\n" !v
