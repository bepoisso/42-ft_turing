let check_args =
  if (List.mem "-h" (Array.to_list Sys.argv) || List.mem "--help" (Array.to_list Sys.argv)) then (
    print_endline "usage: ft_turing [-h] jsonfile input\n";
    print_endline "positional arguments:";
    print_endline "jsonfile       json description of the configuration\n";
    print_endline "input          input of the configuration\n";
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

let check_finals json =
  let finals = (json |> Yojson.Basic.Util.member "finals" |> Yojson.Basic.Util.to_list |> List.map Yojson.Basic.Util.to_string) in
  if not (List.for_all (fun x -> List.mem x (json |> Yojson.Basic.Util.member "states" |> Yojson.Basic.Util.to_list |> List.map Yojson.Basic.Util.to_string)) finals) then (
    print_endline "Each element of finals field must be part of states field";
    exit 1
  );
  finals

let parse_action str =
  match str with
  | "LEFT"  -> Types.Left
  | "RIGHT" -> Types.Right
  | _       ->
    Printf.printf "Invalid action: %s\n" str;
    exit 1

let parse_transition root_json trans_json : Types.transition =
  let alphabet = root_json |> Yojson.Basic.Util.member "alphabet" |> Yojson.Basic.Util.to_list |> List.map Yojson.Basic.Util.to_string in
  let states   = root_json |> Yojson.Basic.Util.member "states"   |> Yojson.Basic.Util.to_list |> List.map Yojson.Basic.Util.to_string in
  let read     = trans_json |> Yojson.Basic.Util.member "read"     |> Yojson.Basic.Util.to_string in
  if not (List.mem read alphabet) then (
    print_endline "Read element must be part of the alphabet field";
    exit 1
  );
  let read_char = read.[0] in
  let to_state = trans_json |> Yojson.Basic.Util.member "to_state" |> Yojson.Basic.Util.to_string in
  if not (List.mem to_state states) then (
    print_endline "to_state must be part of states field";
    exit 1
  );
  let write  = trans_json |> Yojson.Basic.Util.member "write"  |> Yojson.Basic.Util.to_string in
  if not (List.mem write alphabet) then (
    print_endline "write element must be part of alphabet field";
    exit 1
  );
  let write_char = read.[0] in
  let action = parse_action (trans_json |> Yojson.Basic.Util.member "action" |> Yojson.Basic.Util.to_string) in
  {
    read     = read_char;
    to_state = to_state;
    write    = write_char;
    action   = action;
  }

let check_transitions_tab json =
  let states = json |> Yojson.Basic.Util.member "states" |> Yojson.Basic.Util.to_list |> List.map Yojson.Basic.Util.to_string in
  let assoc  = json |> Yojson.Basic.Util.member "transitions" |> Yojson.Basic.Util.to_assoc in
  List.map (fun (state, trans_list) ->
    if not (List.mem state states) then (
      Printf.printf "State '%s' in transitions is not part of states field\n" state;
      exit 1
    );
    (state, trans_list |> Yojson.Basic.Util.to_list |> List.map (parse_transition json))
  ) assoc

let get_info json : Types.configuration =
  try {
    name = (json |> Yojson.Basic.Util.member "name" |> Yojson.Basic.Util.to_string);
    alphabet = (check_alphabet json);
    blank = (check_blank json);
    states = (json |> Yojson.Basic.Util.member "states" |> Yojson.Basic.Util.to_list |> List.map Yojson.Basic.Util.to_string);
    initial = (check_initial json);
    finals = (check_finals json);
    transitions = (check_transitions_tab json);
  }
  with Yojson.Basic.Util.Type_error _ -> (
    print_endline "Missing field";
    exit 1
  )

let action_to_string a =
  match a with
  | Types.Left  -> "LEFT"
  | Types.Right -> "RIGHT"

let print_transition (t : Types.transition) =
  Printf.printf "  read: %c, to_state: %s, write: %c, action: %s\n"
    t.read
    t.to_state
    t.write
    (action_to_string t.action)

let print_transitions transitions =
  List.iter (fun (state, trans_list) ->
    Printf.printf "State: %s\n" state;
    List.iter print_transition trans_list
  ) transitions

let parser =
  check_args;
  let filename = Sys.argv.(1) in
    let json = check_file filename in
      let configuration = get_info json in
        print_endline configuration.name;
        List.iter print_endline configuration.alphabet;
        print_endline configuration.blank;
        List.iter print_endline configuration.states;
        print_endline configuration.initial;
        List.iter print_endline configuration.finals;
        print_transitions configuration.transitions
