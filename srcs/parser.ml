let check_args =
  if (List.mem "-h" (Array.to_list Sys.argv) || List.mem "--help" (Array.to_list Sys.argv)) then (
    print_endline "usage: ft_turing [-h] jsonfile input\n";
    print_endline "positional arguments:";
    print_endline "jsonfile       json description of the machine\n";
    print_endline "input          input of the machine\n";
    print_endline "optional arguments:";
    print_endline "-h, --help     show this help message and exit";
    exit 0
  );
  if Array.length Sys.argv <> 3 then (
    print_endline "Bad usage";
    exit 1
   )

let check_file filename =
  if not (Sys.file_exists filename) then (
    print_endline "File doesn't exist";
    exit 1
   ) else
    try
      let json = Yojson.Basic.from_file filename in
      json
    with
    | Sys_error _ ->
      print_endline "Can't read file";
      exit 1
    | Yojson.Json_error _ ->
      print_endline "Invalid JSON";
      exit 1

let check_alphabet json = 
  let lst = (json |> Yojson.Basic.Util.member "alphabet" |> Yojson.Basic.Util.to_list |> List.map Yojson.Basic.Util.to_string) in
  if not (List.for_all (fun x -> String.length x = 1) lst) then (
    print_endline "Each element of the alphabet must be a string of length 1";
    exit 1
  );
  lst

let check_blank json =
  let blank = (json |> Yojson.Basic.Util.member "blank" |> Yojson.Basic.Util.to_string) in
  if String.length blank <> 1 then (
    print_endline "Blank element must be a string of length 1";
    exit 1
  );
  if not (List.mem blank (json |> Yojson.Basic.Util.member "alphabet" |> Yojson.Basic.Util.to_list |> List.map Yojson.Basic.Util.to_string)) then (
    print_endline "Blank element must be a part of alphabet";
    exit 1
  );
  blank

let check_initial json =
  let initial = (json |> Yojson.Basic.Util.member "initial" |> Yojson.Basic.Util.to_string) in
  if not (List.mem initial (json |> Yojson.Basic.Util.member "states" |> Yojson.Basic.Util.to_list |> List.map Yojson.Basic.Util.to_string)) then (
    print_endline "Initial must be a part of states list";
    exit 1
  );
  initial

let get_info json : Types.machine =
  try {
    name = (json |> Yojson.Basic.Util.member "name" |> Yojson.Basic.Util.to_string);
    alphabet = (check_alphabet json);
    blank = (check_blank json);
    states = (json |> Yojson.Basic.Util.member "states" |> Yojson.Basic.Util.to_list |> List.map Yojson.Basic.Util.to_string);
    initial = (check_initial json);
  }
  with Yojson.Basic.Util.Type_error _ -> (
    print_endline "Missing field";
    exit 1
  )

let parser =
  check_args;
  let filename = Sys.argv.(1) in
    let json = check_file filename in
      let machine = get_info json in
        print_endline machine.name;
        List.iter print_endline machine.alphabet;
        print_endline machine.blank;
        List.iter print_endline machine.states;
        print_endline machine.initial
