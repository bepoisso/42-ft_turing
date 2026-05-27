type action =
    | Left
    | Right

type transition = {
    read : char;
    write : char;
    action : action;
    to_state : string;
}

type machine = {
  name : string;
  alphabet : string list;
  blank : string;
  states : string list;
  initial : string;
}
