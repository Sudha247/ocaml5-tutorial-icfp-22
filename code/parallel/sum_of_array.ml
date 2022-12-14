module Task = Domainslib.Task

let num_domains = Domain.recommended_domain_count - 1
let n = try int_of_string Sys.argv.(2) with _ -> 1000000

(** Empty Array*)
let a = Array.create_float n

let _init_sequential a =
  for i = 0 to (Array.length a - 1) do
    a.(i) <- Random.float 100.
  done

let init_parallel a pool =
  Task.parallel_for ~start:0 ~finish:(Array.length a - 1)
    ~body:(fun i -> a.(i) <- Random.float 100.) pool

let () =
   let pool = Task.setup_pool ~num_domains () in
   Task.run pool (fun () -> init_parallel a pool)