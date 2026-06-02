type action =
    | Left
    | Right

type transition = {
    read : char;
    write : char;
    action : action;
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
  blank : char;
  states : string list;
  initial : string;
  finals : string list;
  transitions : (string * transition list) list;
}


type machine = {
    config            : configuration;
    tape                 : tape;
    state                : string;
    transitions    : transition list;
}
