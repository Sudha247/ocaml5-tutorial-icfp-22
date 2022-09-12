open Effect
open Effect.Deep

type 'a _promise =
    Waiting of ('a,unit) continuation list
  | Done of 'a

  type 'a promise = 'a _promise ref
;;

type _ Effect.t += Async : (unit -> 'a) -> 'a promise Effect.t
type _ Effect.t += Yield : unit t
type _ Effect.t += Await : 'a promise -> 'a Effect.t

let async f = perform (Async f)

let yield () = perform Yield

type file_descr = Unix.file_descr
type sockaddr = Unix.sockaddr
type msg_flag = Unix.msg_flag

type _ Effect.t += Accept : file_descr -> (file_descr * sockaddr) Effect.t
type _ Effect.t += Recv : file_descr * bytes * int * int * msg_flag list -> int Effect.t

let accept fd = perform (Accept fd)
let recv fd buf pos len mode = perform (Recv (fd, buf, pos, len, mode))

type _ Effect.t += Send : file_descr * bytes * int * int * msg_flag list -> int Effect.t

let send fd bus pos len mode = perform (Send (fd, bus, pos, len, mode))

let ready_to_read fd =
  match Unix.select [fd] [] [] 0. with
  | [], _, _ -> false
  | _ -> true

let ready_to_write fd =
  match Unix.select [] [fd] [] 0. with
  | _, [], _ -> false
  | _ -> true

let q = Queue.create ()
let enqueue t = Queue.push t q

type blocked = Blocked : 'a Effect.t * ('a, unit) continuation -> blocked


let br = Hashtbl.create 13
  (* tasks blocked on writes *)
  let bw = Hashtbl.create 13

  let rec schedule () =
    if not (Queue.is_empty q) then
      (* runnable tasks available *)
      Queue.pop q ()
    else if Hashtbl.length br = 0 && Hashtbl.length bw = 0 then
      (* no runnable tasks, and no blocked tasks => we're done. *)
      ()
    else begin (* no runnable tasks, but blocked tasks available *)
      let rd_fds = Hashtbl.fold (fun fd _ acc -> fd::acc) br [] in
      let wr_fds = Hashtbl.fold (fun fd _ acc -> fd::acc) bw [] in
      let rdy_rd_fds, rdy_wr_fds, _ = Unix.select rd_fds wr_fds [] (-1.) in
      let rec resume ht = function
        | [] -> ()
        | x::xs ->
            begin match Hashtbl.find ht x with
            | Blocked (Recv (fd, buf, pos, len, mode), k) ->
                enqueue (fun () -> continue k (Unix.recv fd buf pos len mode))
            | Blocked (Accept fd, k) -> failwith "not implemented"
            | Blocked (Send (fd, buf, pos, len, mode), k) -> failwith "not implemented"
            | Blocked _ -> failwith "impossible"
            end;
            Hashtbl.remove ht x
      in
      resume br rdy_rd_fds;
      resume br rdy_wr_fds;
      schedule ()
    end
