open Types

let create_tape str blank : tape =
	let len = String.length str in

	if len = 0 then
		{ left = []; current = blank; right = [] }
	else
		let current = String.get str 0 in
		let right =
			String.sub str 1 (len - 1)
			|> String.to_seq
			|> List.of_seq
		in
		{ left = []; current; right }


let move_right tape blank =
	match tape.right with
	| [] ->
		{
			left = tape.current :: tape.left;
			current = blank;
			right = [];
		}
	| head :: tail ->
		{
			left = tape.current :: tape.left;
			current = head;
			right = tail;
		}

let move_left tape blank =
	match tape.left with
	| [] ->
		{
			left = [];
			current = blank;
			right = tape.current :: tape.right;
		}
	| head :: tail ->
		{
			left = tail;
			current = head;
			right = tape.current :: tape.right;
		}

let move action blank tape =
	match action with
	| Types.Left -> move_left tape blank
	| Types.Right -> move_right tape blank

let write c tape =
	{
		left = tape.left;
		current = c;
		right = tape.right;
	}
