open Eio.Std

let run_server ~sw socket =
  while true do
    Eio.Net.accept_fork socket ~sw (fun flow _addr ->
      traceln "Server accepted connection from client";
      let parse' = Eio.Buf_read.of_flow ~max_size:100 flow in
      while true do
        let msg = Eio.Buf_read.line parse' in
        traceln "Server received: %S" msg;
        Eio.Flow.copy_string msg flow;
        Eio.Flow.copy_string "\n" flow
      done;
    )
    ~on_error:(function
      | End_of_file -> ()
      | ex -> traceln "Error handling connection: %s" (Printexc.to_string ex)
    );
  done

let run (fn : net:Eio.Net.t -> Switch.t -> unit) =
  Eio_main.run @@ fun env ->
  let net = Eio.Stdenv.net env in
  Switch.run (fn ~net)

let port = 9301
let addr = `Tcp (Eio.Net.Ipaddr.V4.loopback, port)

let test_address addr ~net sw =
  let server = Eio.Net.listen net ~sw ~reuse_addr:true ~backlog:5 addr in
  traceln "Server accepting connections on port %d" port; 
  run_server ~sw server

let () = run (test_address addr)
