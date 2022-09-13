let _matrix_multiply res x y =
  let i_n = Array.length x in
  let j_n = Array.length y.(0) in
  let k_n = Array.length y in

  for i = 0 to i_n - 1 do
    for j = 0 to j_n - 1 do
      let w = ref 0 in
      for k = 0 to k_n - 1 do
        w := !w + x.(i).(k) * y.(k).(j);
      done;
      res.(i).(j) <- !w
    done
  done

module T = Domainslib.Task

let num_domains = try Sys.argv.(1) |> int_of_string with _ -> 1
let size = try Sys.argv.(2) |> int_of_string with _ -> 1024

let matrix_multiply_parallel pool res x y =
  failwith "Implement me"

let _ =
    let pool = T.setup_pool ~num_domains:(num_domains - 1) () in

    let m1 = Array.init size (fun _ -> Array.init size (fun _ -> Random.int 100)) in
    let m2 = Array.init size (fun _ -> Array.init size (fun _ -> Random.int 100)) in
    let res = Array.make_matrix size size 0 in

    (* print_matrix m1; print_matrix m2; *)
    matrix_multiply_parallel pool res m1 m2;
    T.teardown_pool pool;