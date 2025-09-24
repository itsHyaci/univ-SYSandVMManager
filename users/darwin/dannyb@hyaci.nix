{ config, lib, pkgs, systemName, ... }:

{
  imports = [ ../common/dannyb.nix ];

  home = {
    packages = with pkgs; [
      irony-server
      bear
      dtools
      beamMinimal28Packages.elixir-ls
      vips
    ];
  };
}
