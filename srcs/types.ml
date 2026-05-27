type action =
	| Left
	| Right

type transition = {
	read : char;
	write : char;
	action : action;
	from_state : string;
	to_state : string;
}

type tape = {
	left : char list;
	current : char;
	right : char list;
}

type configuration = {
  name : string;
  alphabet : string list;
  blank : string;
  states : string list;
  initial : string;
	finals : string;
}


type machine = {
	config			: configuration;
	tape 				: tape;
	state				: string;
	transitions	: transition list;
}
