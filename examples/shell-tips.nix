{}:

with builtins;

let
  shells = ["bash" "zsh" "fish"];
  
  range = first: last: if first > last then [] else genList (n: first + n) (last - first + 1);
  
  stringToCharacters = s: map (p: substring p 1 s) (range 0 (stringLength s - 1));
  lower = stringToCharacters "abcdefghijklmnopqrstuvwxyz";
  upper = stringToCharacters "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  
  capitalize = (s: (replaceStrings lower upper (substring 0 1 s)) + (substring 1 ((stringLength s)-1) s));
  
  programs = ["broot" "dircolors" "direnv" "fzf" "keychain" "mcfly" "pazi" "starship" "z-lua" "zoxide"];
  
  mkTip = shell: program: {
    weight = 25;
    ifValues = ["programs.${shell}.enable" "programs.${program}.enable"];
    thenValue = "programs.${program}.enable${capitalize shell}Integration";
  };
  
  mkShellTips = shell: map (mkTip shell) programs;

in
  concatLists (map mkShellTips shells)
