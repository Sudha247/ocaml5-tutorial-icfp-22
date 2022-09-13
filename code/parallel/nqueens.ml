module T = Domainslib.Task

let rec ok i j k xs =
  match xs with
    | [] -> true
    | h::t -> h<>i && h<>j && h<>k && ok i (j+1) (k-1) t

let rec _nqueens_seq n j xs =
  match n with
  | n when n = j -> 1
  | _ -> begin
      let count = ref 0 in
      for i = 0 to n-1 do
        if ok i (i+1) (i-1) xs then
          count := !count + (nqueens n (j+1) (i::xs))
      done;
      !count
    end

let rec nqueens pool n j xs = failwith "Implement me"

let num_domains = try int_of_string Sys.argv.(1) with _ -> 2
let board_size = try int_of_string Sys.argv.(2) with _ -> 13

let () =
  let pool = T.setup_pool ~num_domains:(num_domains - 1) () in
  let n_solutions = T.run pool (fun () -> nqueens pool board_size 0 []) in
  T.teardown_pool pool;

  Printf.printf "%i solutions for board of size %i\n" n_solutions board_size
