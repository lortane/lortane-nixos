let
  keyFiles = [
    ./keys/id_lortane-wes.pub
    ./keys/id_lortane-zack.pub
  ];
in {
  # actual content
  keyStrings = map builtins.readFile keyFiles;

  # file paths
  keyPaths = keyFiles;
}
