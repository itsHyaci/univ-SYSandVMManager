{ config, lib, pkgs, nixpkgs, ... }:
{
  nix.linux-builder = {
    enable = true;
    ephemeral = true;
  };

#  packages.aarch64-linux = {
#        name = "my-sys";
#        paths = with pkgs; [
#          irony-server
#          bear
#          dtools
#          beamMinimal28Packages.elixir-ls
#        ];
#  };

}
