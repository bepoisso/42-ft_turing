open Types

let () =
	let config =
		{
			name = "unary_sub";
			alphabet = [ "1"; "."; "-"; "=" ];
			blank = ".";
			states = [ "scanright"; "eraseone"; "subone"; "skip"; "HALT" ];
			initial = "scanright";
			finals = "HALT";
		}
	in
  let tape = Tape.create_tape "111-11=" in
	let transitions =
		[
			{ read = '.'; write = '.'; action = Right; from_state = "scanright"; to_state = "scanright" };
			{ read = '1'; write = '1'; action = Right; from_state = "scanright"; to_state = "scanright" };
			{ read = '-'; write = '-'; action = Right; from_state = "scanright"; to_state = "scanright" };
			{ read = '='; write = '.'; action = Left; from_state = "scanright"; to_state = "eraseone" };
			{ read = '1'; write = '='; action = Left; from_state = "eraseone"; to_state = "subone" };
			{ read = '-'; write = '.'; action = Left; from_state = "eraseone"; to_state = "HALT" };
			{ read = '1'; write = '1'; action = Left; from_state = "subone"; to_state = "subone" };
			{ read = '-'; write = '-'; action = Left; from_state = "subone"; to_state = "skip" };
			{ read = '.'; write = '.'; action = Left; from_state = "skip"; to_state = "skip" };
			{ read = '1'; write = '.'; action = Right; from_state = "skip"; to_state = "scanright" };
		]
	in
	Simulator.run config transitions tape

