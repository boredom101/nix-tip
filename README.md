# nix-tip
A NixOS / Nix recommendation system (Proof of Concept)

## Example:

`$ ./nix-tip.sh "home" home.nix examples/shell-tips.nix`
Recommends integrations based on enabled shells and programs.

## Format:

```nix
[
  {
    ifValue = "path.to.bool.value";
    thenValues = ["path.to.another.bool.value"];
    weight = 10; # Could be any int from -100 to 100
  }
  # And so on...
]
```
