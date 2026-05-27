open Types

let tape_to_string tape =
	let string_of_char_list chars =
		match chars with
		| [] -> ""
		| _ -> String.of_seq (List.to_seq chars)
	in

	Printf.sprintf "%s<%c>%s"
		(string_of_char_list (List.rev tape.left))
		tape.current
		(string_of_char_list tape.right)

let print_outputs_machine (machine : machine) =
	let transition = Transition.find_transition machine.state machine.tape.current machine.transitions in
	let direction = match transition.action with
		| Left -> "LEFT"
		| Right -> "RIGHT"
	in
	Printf.printf "[%s] (%s, %c) -> (%s, %c, %s)\n"
		(tape_to_string machine.tape)
		machine.state
		transition.read
		transition.to_state
		transition.write
		direction
