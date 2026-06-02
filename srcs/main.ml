let () =
  let configuration = ParserFile.parserFile in
  ParserInput.parserInput configuration;
  PrintInfo.printHeader configuration