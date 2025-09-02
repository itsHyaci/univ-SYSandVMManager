{ config, lib, pkgs, nixpkgs, ... }:
{
  nix.linux-builder = {
    enable = true;
    ephemeral = true;
  };

  { pkgs ? import <nixpkgs> {} }:
with pkgs; buildEnv {
  name = "my-env";
  paths = [
    irony-server
    # asdf-vm
    bear
    dtools
    beamMinimal28Packages.elixir-ls
];
}

}
