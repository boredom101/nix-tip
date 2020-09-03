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

  args = rec {
    pkgs = import <nixpkgs> {};
    configuration = if confAttr == " " then (import confPath args) else (recAttr splitAttr (import confPath args));
    lib = pkgs.stdenv.lib;
  };
  
  config = (import <home-manager/modules> args).config;
  
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
      in
        (map (x:
          if x.value then "TIP: ${x.option} (${toString tip.weight})" else ""
        ) temp)
  ) tips));

in (concatStringsSep "\n" results) + "\n"

# splitPaths > list of list of strings
#  > 