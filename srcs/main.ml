open Types

let () =
	let config =
		{
			name = "palindrome";
			alphabet = [ "a"; "b"; "."; "X"; "Y"; "n"; "y" ];
			blank = '.';
			states = [ "scanright"; "find_right_a"; "find_right_b"; "check_a"; "check_b"; "return_left"; "reject"; "accept"; "HALT" ];
			initial = "scanright";
			finals = [ "HALT" ];
		}
	in
	let tape = Tape.create_tape "abab" config.blank in
	let transitions =
		[
			(*? scanright *)
			{ read = '.'; write = '.'; action = Right ; from_state = "scanright"; to_state = "scanright" };
			{ read = 'X'; write = 'X'; action = Right ; from_state = "scanright"; to_state = "scanright" };
			{ read = 'Y'; write = 'Y'; action = Right; from_state = "scanright"; to_state = "accept" };
			{ read = 'a'; write = 'X'; action = Right ; from_state = "scanright"; to_state = "find_right_a" };
			{ read = 'b'; write = 'X'; action = Right; from_state = "scanright"; to_state = "find_right_b" };

			(*? find_right_a *)
			{ read = '.'; write = '.'; action = Left ; from_state = "find_right_a"; to_state = "check_a" };
			{ read = 'Y'; write = 'Y'; action = Left ; from_state = "find_right_a"; to_state = "check_a" };
			{ read = 'a'; write = 'a'; action = Right ; from_state = "find_right_a"; to_state = "find_right_a" };
			{ read = 'b'; write = 'b'; action = Right ; from_state = "find_right_a"; to_state = "find_right_a" };
			{ read = 'X'; write = 'X'; action = Right ; from_state = "find_right_a"; to_state = "find_right_a" };

			(*? find_right_b *)
			{ read = '.'; write = '.'; action = Left ; from_state = "find_right_b"; to_state = "check_b" };
			{ read = 'Y'; write = 'Y'; action = Left ; from_state = "find_right_b"; to_state = "check_b" };
			{ read = 'a'; write = 'a'; action = Right ; from_state = "find_right_b"; to_state = "find_right_b" };
			{ read = 'b'; write = 'b'; action = Right ; from_state = "find_right_b"; to_state = "find_right_b" };
			{ read = 'X'; write = 'X'; action = Right ; from_state = "find_right_b"; to_state = "find_right_b" };

			(*? check_a *)
			{ read = 'a'; write = 'Y'; action = Left ; from_state = "check_a"; to_state = "return_left" };
			{ read = 'Y'; write = 'Y'; action = Left ; from_state = "check_a"; to_state = "check_a" };
			{ read = 'b'; write = 'b'; action = Right; from_state = "check_a"; to_state = "reject" };
			{ read = 'X'; write = 'X'; action = Right; from_state = "check_a"; to_state = "reject" };


			(*? check_b *)
			{ read = 'b'; write = 'Y'; action = Left ; from_state = "check_b"; to_state = "return_left" };
			{ read = 'Y'; write = 'Y'; action = Left ; from_state = "check_b"; to_state = "check_b" };
			{ read = 'a'; write = 'a'; action = Right ; from_state = "check_b"; to_state = "reject" };
			{ read = 'X'; write = 'X'; action = Right ; from_state = "check_b"; to_state = "reject" };

			(*? return_left *)
			{ read = '.'; write = '.'; action = Right; from_state = "return_left"; to_state = "scanright" };
			{ read = 'X'; write = 'X'; action = Right ; from_state = "return_left"; to_state = "scanright" };
			{ read = 'Y'; write = 'Y'; action = Left ; from_state = "return_left"; to_state = "return_left" };
			{ read = 'a'; write = 'a'; action = Left ; from_state = "return_left"; to_state = "return_left" };
			{ read = 'b'; write = 'b'; action = Left ; from_state = "return_left"; to_state = "return_left" };

			(*? reject *)
			{ read = '.'; write = 'n'; action = Right ; from_state = "reject"; to_state = "HALT" };
			{ read = 'a'; write = 'a'; action = Right ; from_state = "reject"; to_state = "reject" };
			{ read = 'b'; write = 'b'; action = Right ; from_state = "reject"; to_state = "reject" };
			{ read = 'X'; write = 'X'; action = Right ; from_state = "reject"; to_state = "reject" };
			{ read = 'Y'; write = 'Y'; action = Right ; from_state = "reject"; to_state = "reject" };

			(*? accept *)
			{ read = '.'; write = 'y'; action = Right ; from_state = "accept"; to_state = "HALT" };
			{ read = 'a'; write = 'a'; action = Right ; from_state = "accept"; to_state = "accept" };
			{ read = 'b'; write = 'b'; action = Right ; from_state = "accept"; to_state = "accept" };
			{ read = 'X'; write = 'X'; action = Right ; from_state = "accept"; to_state = "accept" };
			{ read = 'Y'; write = 'Y'; action = Right ; from_state = "accept"; to_state = "accept" };


		]
	in
	Simulator.run config transitions tape

