Eio_main.run (fun env ->
  let cwd = Eio.Stdenv.cwd env in
  let filename = Eio.Path.(cwd / "test-file") in
  Eio.Path.save ~create:(`Or_truncate 0o666) filename "eio-data";
  Eio.traceln "Got %S" @@ Eio.Path.load filename)
