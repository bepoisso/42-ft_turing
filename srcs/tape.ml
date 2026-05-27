type tape = {
	left : char list;
	current : char;
	right : char list;
}

let print_tape tape =
	let string_of_char_list chars =
		match chars with
		| [] -> "(nil)"
		| _ -> String.of_seq (List.to_seq chars)
	in
	Printf.printf "left[%s]; current[%c]; right[%s]\n"
		(string_of_char_list (List.rev tape.left))
		tape.current
		(string_of_char_list tape.right)

let create_tape str =
	let len = String.length str in
	if len = 0 then
		{ left = []; current = '.'; right = [] }
	else
		let current = String.get str 0 in
		let right =
			String.sub str 1 (len - 1)
			|> String.to_seq
			|> List.of_seq
		in
		{ left = []; current; right }


let move_right tape =
	match tape.right with
	| [] ->
		{
			left = tape.current :: tape.left;
			current = '.';
			right = [];
		}
	| head :: tail ->
		{
			left = tape.current :: tape.left;
			current = head;
			right = tail;
		}

let move_left tape =
	match tape.left with
	| [] ->
		{
			left = [];
			current = '.';
			right = tape.current :: tape.right;
		}
	| head :: tail ->
		{
			left = tail;
			current = head;
			right = tape.current :: tape.right;
		}

let write c tape =
	{
		left = tape.left;
		current = c;
		right = tape.right;
	}
