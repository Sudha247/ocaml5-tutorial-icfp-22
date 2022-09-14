let domain_new = Domain.spawn (fun () -> print_endline "Hello there!")

let domain_res = Domain.spawn (fun () -> 50*100)

let () =
  Domain.join domain_new;
  print_int (Domain.join domain_res);
  print_string "\n"