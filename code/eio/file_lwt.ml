open Lwt.Syntax

let promise =
  let* file_descr = Lwt_unix.openfile "test-file" [Unix.O_WRONLY] 0o666 in
  let output_channel = Lwt_io.of_fd ~mode:Output file_descr in
  let* () = Lwt_io.write output_channel "lwt-data" in
  let* () = Lwt_io.close output_channel in
  let* file_descr = Lwt_unix.openfile "test-file" [Unix.O_RDONLY] 0o666 in
  let input_channel = Lwt_io.of_fd ~mode:Input file_descr in
  let* content = Lwt_io.read input_channel in
  Format.printf "Got %S\n" content;
  Lwt.return ()

let () =
  Lwt_main.run promise
