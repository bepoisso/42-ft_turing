let check_input input (configuration : Types.configuration) =
  let chars = List.init (String.length input) (fun i -> String.make 1 input.[i]) in
  if not (List.for_all (fun c -> List.mem c configuration.alphabet) chars) then (
    print_endline "Input contains invalid characters";
    exit 1
  );
  if List.exists (fun c -> c = String.make 1 configuration.blank) chars then (
    print_endline "Input can't contain blank charactersx";
    exit 1
  )

let parserInput (configuration : Types.configuration) =
  let input = Sys.argv.(2) in
  check_input input configuration