open Types


let step machine =
	let current_symbol = machine.tape.current in
	let trans = Transition.find_transition machine.state current_symbol machine.transitions in
	let tape =
		machine.tape
		|> Tape.write trans.write
		|> Tape.move trans.action machine.config.blank
	in
	{ machine with tape; state = trans.to_state }



let run configuration transitions tape =
	let machine =
		{
			config = configuration;
			tape;
			state = configuration.initial;
			transitions;
		}
	in
	let rec loop current =
		if List.mem current.state current.config.finals then
			(
				Printf.printf "output: %s\n" (Printer.tape_to_string current.tape);
				current
			)
		else
			(
				Printer.print_outputs_machine current;
				loop (step current)
			)
	in
	ignore (loop machine);
	