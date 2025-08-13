<div align="center">

# Danno's Universal System & VM Manager (Powered by Nix); Alpha Test on MacOS
ALERT! Work in Progress but I clone & update this repo on the regular so I really don't feel like privating. User beware, some features are currently fake news.

[Install](#os-x-instillation) • [System Manager Documenation] • [Virtual Machine Manager Documentaion](./docs/index.org)

![Build status: master](https://img.shields.io/badge/Alpha-v0.1.0-orange)

</div>

---

### Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [OS X Instilation](#os-x-instillation)
- [Build and Run VMs](#build-and-run-vms)

# Introduction

Yoinked & Twisted from: https://github.com/mrkuz/macos-config

- I found the repo from this post: https://www.reddit.com/r/NixOS/comments/1be4j7d/experiments_with_qemu_nixos_vms_on_macos/

> ✅ Tested on OS X
- [ ] TODO: add doom eMacs config
- [ ] TODO: consider creating a shell script installer.

<div align="center">
<p>
  <strong><em>
  Welcome to my System & Virtual Machine Manager built declaritively through Nix.
  </em></strong>
</p>
</div>

Manage your qemu vms & your system configuration using nix ([nix-darwin](https://github.com/LnL7/nix-darwin) if OSX) with [flakes](https://nix.dev/concepts/flakes.html).

There are 2 branches:

| Name       | System              | Description                                                                        |
|------------|---------------------|------------------------------------------------------------------------------------|
| mini  | darwin              | Minimal configuration including linux-builder                                      |
| chonk       | darwin              | For Casual Scrubs 2 Copy My Shit                                      |

*You are currently in the **chonk** branch*

The main burpose of the chonk branch is to store my config.

The config is declaritively defined through flakes. Notably, without the use of home-manager.

This branch also contains my OS X system managment scripts.

TODO: the untimate goal is a universal system menager to merge my linux stuff to this branch.

# Features:

The chonk branch is my config built ontop of the mini branch. Therefore the chonk branch inherits mini's features:
- Install and configure software packages via [nix](https://nix.dev)
- Build and run [NixOS](https://nixos.org) virtual machines using [QEMU](https://www.qemu.org) (see [here](#build-and-run-vms))
  + Good for isolated dev environments

Additionally, the chonk branch provides these features:
- Define nix packages to be installed declaritively through a declaritive profile using flakes
  - No home manager so you don't need to rsync after each edit. Instead, good ol GNU stow is used to store dotfiles.
- Manage [Homebrew](https://brew.sh) installations via [nix-homebrew](https://github.com/zhaofengli/nix-homebrew)

See the [System Manager Documenation] to see everything that gets installed.

Notes:
- Not everything is installed via nix. I use following guideline:
    1. If it is offical Apple software or there are no other options -> App Store (using [mas](https://github.com/mas-cli/mas))
    2. If it is proprietary software or distributed as DMG -> [Homebrew](https://brew.sh)
        - I also added a cmd to migrate stuff from a previous install 
    3. Else -> nix
    4. Exception: Some tools for development -> [mise](https://mise.jdx.dev)
- [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle) keeps track of software installed via App Store or Homebrew

# OS X Instillation

1. Install Nix using the [Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#determinate-nix-installer)

```shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

NOTE: Say no to installing determinate, install vanila nix from nix.com; Just use as an install script. 

For some reason, nix-darwin doesn't like determinate nix. Don't know why (I think it got botched on an update, it used to work) 

![Determinate nix NOT supported](./docs/images/good-nix-install.png)

2. Clone repo

```shell
nix shell nixpkgs#git
git clone https://github.com/itsHyaci/univ-SYSandVMManager
cd univ-SYSandVMManager
```

3. Install nix-darwin

To install the Virtual Machine Manager, run this cmd:
```shell
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin/master#darwin-rebuild -- switch --flake .#bootstrap
```

- [ ] TODO: edit config as to not necessitate appending this to nix: 
`--extra-experimental-features "nix-command flakes"`

Run this cmd next to copy my shit:
```shell
echo LOL not released yet, I\'m migrating my dotfiles to GNU stow
```


<a id="build-and-run-vms"></a>

# Build and Run VMs

Chonk is built ontop of mini. To avoid redundancy, this section will link to the mini branch's readme for building & running VMs. 

P.S. This branch is for copying my config. If you want more info on modifying the config, refer to the building blocks section of the mini branch readme.
