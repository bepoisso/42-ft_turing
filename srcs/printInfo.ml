let center_text width text =
  let len = String.length text in
  if len >= width then text
  else
    let left = (width - len) / 2 in
    let right = width - len - left in
    String.make left ' ' ^ text ^ String.make right ' '

let printName (configuration : Types.configuration) width =
  let line = String.make width '*' in
  let empty = "*" ^ String.make (width - 2) ' ' ^ "*" in

  print_endline line;
  print_endline empty;
  print_endline ("*" ^ center_text (width - 2) configuration.name ^ "*");
  print_endline empty;
  print_endline line

let printInfo (configuration : Types.configuration) =
  print_endline ("Alphabet: [ " ^ String.concat ", " configuration.alphabet ^ " ]");
  print_endline ("States: [ " ^ String.concat ", " configuration.states ^ " ]");
  print_endline ("Initial: " ^ configuration.initial);
  print_endline ("Finals: [ " ^ String.concat ", " configuration.finals ^ " ]")

let actionToString (action : Types.action) =
  match action with
  | Types.Left -> "LEFT"
  | Types.Right -> "RIGHT"

let printTransition from_state (transition : Types.transition) = 
  Printf.printf
    "(%s, %c) -> (%s, %c, %s)\n"
    from_state
    transition.read
    transition.to_state
    transition.write
    (actionToString transition.action)

let printHeader (configuration : Types.configuration) =
  printName configuration 80;
  printInfo configuration;
  List.iter (fun (state, transitions) ->
  List.iter (printTransition state) transitions
  ) configuration.transitions;
  let endLine = String.make 80 '*' in
  print_endline endLine