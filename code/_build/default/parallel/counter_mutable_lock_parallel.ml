let n = try int_of_string Sys.argv.(1) with _ -> 10000

let v = ref 0
let m = Mutex.create ()

let incr n () =
  for _i = 1 to n do
    Mutex.lock m;
    incr v;
    Mutex.unlock m
  done

let () =
  let domains = Array.init 4 (fun _ -> Domain.spawn (incr n)) in
  incr n ();
  Array.iter Domain.join domains;
  Printf.printf "v = %d\n" !v
