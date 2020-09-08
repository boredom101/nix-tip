{conf}:

with builtins;

let


    config = import conf rec {
        pkgs = import <nixpkgs> {};
        config = {};
        lib = pkgs.stdenv.lib;
    };

    recExtract = (conf: path:
        if (isAttrs conf) then concatLists (map (x:
            recExtract (getAttr x conf) (path ++ [x])
        ) (attrNames conf)) else (
            if (isBool conf && conf == true) then [(concatStringsSep "." path)] else []
        )
    );

    extracts = recExtract config [];

    string = (concatStringsSep ";" extracts);
in string
