{
    tipsPath, confPath, type, confAttr ? ""
}:

with builtins;

let
  
  recAttr = (path: set:
    if ((length path) == 1) then (getAttr (elemAt path 0) set)
    else recAttr (tail path) (getAttr (elemAt path 0) set)
  );

  getPossiblities = (start: path: set:
    if ((elemAt path start) == "*") then (attrNames set)
    else if (length path == 1 + start) then [(elemAt path start)] else getPossiblities (start+1) path (getAttr (elemAt path start) set)
  );

  replaceList = (old: new: list:
    map (x: if (x == old) then new else x) list
  );

  splitAttr = filter isString (split "\\." confAttr);

  config = if (type == "home") then (
    let
      args = rec {
        pkgs = import <nixpkgs> {};
        configuration = if confAttr == " " then (import confPath args) else (recAttr splitAttr (import confPath args));
        lib = pkgs.stdenv.lib;
      };
    in (import <home-manager/modules> args).config
  ) else (
    let
      args = rec {
        modules = [(if confAttr == " " then (import confPath args) else (recAttr splitAttr (import confPath args)))];
        pkgs = import <nixpkgs> {};
      };
    in (import <nixpkgs/nixos/lib/eval-config.nix> args).config
  );
  args = rec {
    pkgs = import <nixpkgs> {};
    configuration = if confAttr == " " then (import confPath args) else (recAttr splitAttr (import confPath args));
    lib = pkgs.stdenv.lib;
  };
  
  tips = import tipsPath {};
  
  check = paths:
    let
      splitPaths = (map (path: filter isString (split "\\." path)) paths);
      posses = (getPossiblities 0 (elemAt splitPaths 0) config);
      temp = (map (poss:
        {value = (foldl' (a: b:
            a && b
        ) true (map (x: recAttr (replaceList "*" poss x) config) splitPaths)); dynamic = poss;}
      ) posses);
    in temp;
  
  results = filter (s: stringLength s > 0)  (concatLists (map (tip:
      let
        checks = check tip.ifValues;
        temp = (map (x:
          if (x.dynamic == []) then {value = x.value; option = tip.thenValue;}
          else {value = x.value; option = builtins.replaceStrings ["*"] [x.dynamic] tip.thenValue;}
        ) checks);
        abs = (x:
          if (x < 0) then -x else x
        );
      in
        (map (x:
          if x.value then "${if tip.weight >= 0 then "Recommended" else "Discouraged"}: ${x.option} (${toString (abs tip.weight)})" else ""
        ) temp)
  ) tips));

in (concatStringsSep "\n" results) + "\n"

# splitPaths > list of list of strings
#  > 