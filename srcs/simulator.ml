open Types


let step machine =
	let current_symbol = machine.tape.current in
	let trans = Transition.find_transition machine.state current_symbol machine.transitions in
	let tape =
		machine.tape
		|> Tape.write trans.write
		|> Tape.move trans.action
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
		if current.state = current.config.finals then
			current
		else
			(
				Printer.print_outputs_machine current;
				loop (step current)
			)
	in
	ignore (loop machine);
	