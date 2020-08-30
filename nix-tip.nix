{
tipsPath, confPath, type
}:

let
  
  recAttr = (path: set:
    if ((builtins.length path) == 1) then (builtins.getAttr (builtins.elemAt path 0) set) else recAttr (builtins.tail path) (builtins.getAttr (builtins.elemAt path 0) set)
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
      splitPath = builtins.filter builtins.isString (builtins.split "\\." path);
    in recAttr splitPath config;
  
  results = builtins.filter (s: builtins.stringLength s > 0)  (builtins.map (tip:
    let
      enabled = (builtins.foldl' (a: b: a && b) true (map check tip.ifValues));
    in
      if enabled then "TIP: ${tip.thenValue} (${toString tip.weight})" else ""
  ) tips);

in (builtins.concatStringsSep "\n" results) + "\n"
