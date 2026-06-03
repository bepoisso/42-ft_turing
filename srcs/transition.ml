open Types

let find_transition state symbol transitions =
	let matches t = t.read = symbol in
	match List.assoc_opt state transitions with
	| None ->
		Printf.printf "Error: no transitions for state:\n%s\n" state;
		exit 1
	| Some state_transitions -> (
		match List.find_opt matches state_transitions with
		| Some t -> t
		| None ->
			Printf.printf "Error: no transition found:\n(%s, '%c')\n" state symbol;
			exit 1
	)

