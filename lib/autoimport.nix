{ lib }:
{
  autoImport =
    dir:
    lib.mapAttrsToList (name: _: dir + "/${name}") (
      lib.filterAttrs (
        name: type: name != "default.nix" && (type == "directory" || lib.hasSuffix ".nix" name)
      ) (builtins.readDir dir)
    );
}
