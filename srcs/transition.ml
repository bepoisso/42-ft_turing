open Types

let find_transition state symbol transitions =
	let matches t = t.read = symbol && t.from_state = state in
	match List.find_opt matches transitions with
	|	Some t -> t
	|	None -> Printf.printf "Error: no transition found\n";
		exit 1

