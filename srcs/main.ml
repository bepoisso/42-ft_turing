open Types

let () =
  let configuration = ParserFile.parserFile in
  ParserInput.parserInput configuration;
  PrintInfo.printHeader configuration
  Simulator.run config transitions tape

