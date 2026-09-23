{ lib }:
rec {
  autoImport =
    dir:
    let
      entries = builtins.readDir dir;
    in
    lib.concatLists (
      lib.mapAttrsToList (
        name: type:
        let
          path = dir + "/${name}";
        in
        if type == "directory" then
          # if a subdir has a default.nix, just import the dir, otherwise autoImport
          if builtins.pathExists (path + "/default.nix") then [ path ] else autoImport path
        else if name != "default.nix" && lib.hasSuffix ".nix" name then
          [ path ]
        else
          [ ]
      ) entries
    );
}
