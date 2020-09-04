# nix-tip
A NixOS / Nix recommendation system (Proof of Concept)

## Example:

`$ ./nix-tip --type "home" --config home.nix --tip examples/shell-tips.nix`
Recommends integrations based on enabled shells and programs.

## Help:
```
Usage: ./nix-tip --tip <tips.nix> --type <TYPE> --config <config.nix>

Options

  -A, --attr ATTRIBUTE      Optional attribute that selects a configuration
                      expression in the config file
  --color                   Color code the output
  -C, --config FILE         Config files to generate recommendations on
  -H, --help                Print this help.
      --show-trace          Sent to the call to nix-instantiate, useful for
                      debugging
  -T, --tip FILE            File containing tips to generate recommendations with
  --type                    The type of config file that is being used
```

## Format:

```nix
[
  {
    ifValues = ["path.to.bool.value"];
    thenValue = "path.to.another.bool.value";
    weight = 10; # Could be any int from -100 to 100
  }
  # And so on...
]
```

Works with NixOS and home-manager
(Just set `--type` to either `home` or `nixos`)
