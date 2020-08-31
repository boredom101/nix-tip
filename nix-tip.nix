{
tipsPath, confPath, type
}:

with builtins;

let
  
  recAttr = (path: set:
    if ((length path) == 1) then (getAttr (elemAt path 0) set) else recAttr (tail path) (getAttr (elemAt path 0) set)
  );
  
  args = rec {
    pkgs = import <nixpkgs> {};
    configuration = (import confPath args);
    lib = pkgs.stdenv.lib;
  };
  
  config = (import <home-manager/modules> args).config;
  
  tips = import tipsPath {};
  
  check = path:
    let
      splitPath = filter isString (split "\\." path);
    in recAttr splitPath config;
  
  results = filter (s: stringLength s > 0)  (map (tip:
    let
      enabled = (foldl' (a: b: a && b) true (map check tip.ifValues));
    in
      if enabled then "TIP: ${tip.thenValue} (${toString tip.weight})" else ""
  ) tips);

in (concatStringsSep "\n" results) + "\n"
