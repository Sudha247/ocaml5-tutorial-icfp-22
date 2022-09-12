let n = try int_of_string Sys.argv.(1) with _ -> 10000

let v = Atomic.make 0

let incr n () =
  for _i = 1 to n do
    Atomic.incr v
  done

let () =
  let domains = Array.init 4 (fun _ -> Domain.spawn (incr n)) in
  incr n ();
  Array.iter Domain.join domains;
  Printf.printf "v = %d\n" (Atomic.get v)
