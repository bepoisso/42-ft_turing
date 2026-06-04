open Types

let () =
  let configuration = ParserFile.parserFile in
  ParserInput.parserInput configuration;
  Printer.printHeader configuration;
  Simulator.run configuration Sys.argv.(2)

