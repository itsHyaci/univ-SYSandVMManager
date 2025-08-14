<div align="center">

# Universal System & VM Manager (Powered by Nix)
ALERT! Work in Progress but I clone & update this repo on the regular so I really don't feel like privating. User beware, some features are currently fake news. 

[Install](#os-x-instillation) • [Scaffolding for Custom System Manager - Documentation] • [Virtual Machine Manager Documentation](./docs/index.org)

![Build status: master](https://img.shields.io/badge/Alpha-v0.1.0-orange)

</div>

---

### Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [OS X Nix Instilation](#os-x-nix-instillation)
- [Build and Run NixOS VMs](#build-and-run-nixos-vms)
- [Building Blocks](#building-blocks)
- [Credits](#credits)

# Introduction

> ✅ Tested on OS X
> 
> - [ ] TODO: Test on Debian (& other debian based distros like Ubuntu & PoPOS) & Arch (& artix). Maybe even NixOS for Nix ception 
> - [ ] TODO: If you're feeling particularly masochistic, add support for [NixBSD](https://github.com/nixos-bsd/nixbsd) & MinGW/Windows.
> - [ ] Also consider managing the Mac Classic emulators, SheepShaver & Basilisk.

<div align="center">
<p>
  <strong><em>
  Welcome to my System & Virtual Machine Manager built declaritively through Nix.
  </em></strong>
</p>
</div>

Manage your system configuration & qemu vms using nix ([nix-darwin](https://github.com/LnL7/nix-darwin) if OSX) with [flakes](https://nix.dev/concepts/flakes.html).

There are 2 branches:

| Name       | System              | Description                                                                        |
|------------|---------------------|------------------------------------------------------------------------------------|
| mini       | darwin              | Minimal configuration including linux-builder                                      |
| chonk      | darwin              | For Casual Scrubs 2 Copy My Shit                                                   |

*You are are currently on the **mini** branch*

The main purpose of the mini branch is to provide the virtual machine manager.

A secondary purpose is to get the nix system config scaffolding up & running. That way, you can build your own config. 

# Features:

- Install and configure software packages via [nix](https://nix.dev)
- Build and run [NixOS](https://nixos.org) virtual machines using [QEMU](https://www.qemu.org) (see [here](#build-and-run-vms))
  
## Use cases: 
- Run docker
- Isolate applications in an instance of either nixOS or sixOS
- Create isolated dev environments
- Launch Unikernels (I used it for testing VUH before deploying on a proxmox server)

# OS X Nix Instillation

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

If you just want the Virtual Machine Manager, run this cmd:
```shell
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin/master#darwin-rebuild -- switch --flake .#bootstrap
```

- [ ] TODO: edit config as to not necessitate appending this to nix: 
`--extra-experimental-features "nix-command flakes"`


<a id="build-and-run-vms"></a>

# Build and Run VMs

This section is TLDR Version for the VMM documentation.

## Building VMs
To build Linux packages on MacOS, you need a [remote Linux builder](https://nixos.org/manual/nixpkgs/stable/#sec-darwin-builder). Thankfully this can be archived with one line in nix-darwin:

```nix
nix.linux-builder.enable = true;
```

P.S. Enabling the linux builder is the one job bootstrap.nix .

The builder is setup to start automatically. If you dislike this, add following:

```nix
launchd.daemons.linux-builder.serviceConfig = {
  KeepAlive = lib.mkForce false;
  RunAtLoad = lib.mkForce false;
};
```

You then need to start the builder manually:

```shell
sudo launchctl start org.nixos.linux-builder
```

you can confirm if the builder is running with this cmd:
```shell
sudo launchctl list org.nixos.linux-builder
```

After the builder is up and running, you can launch every VM defined in `hosts/nixos/vm/` with a single command. For instance:

```shell
nix --extra-experimental-features "nix-command flakes" run .#playground-vm
```

In case of mishaps, go to the documentation 
cut into vmm docs{
P.S. If you need to edit your vm,module,etc run this before re-cloning & rebuilding:

```shell
sudo nix --extra-experimental-features "nix-command flakes" store gc --keep-outputs
```
}

<a id="vms"></a>

## VMs

TODO: user can chose between nixOS or sixOS. 

List of individual VM's that could be spun up:

| Name       | System          | Description                                                                        |
|------------|-----------------|------------------------------------------------------------------------------------|
| docker     | nixos (console) | Runs [Docker Engine](https://docs.docker.com/engine/)                              |
| firefox    | nixos (graphic) | Runs [Firefox Developer Edition](https://www.mozilla.org/en-US/firefox/developer/) |
| gnome      | nixos (graphic) | Latest [GNOME desktop environment](https://www.gnome.org) (without apps)           |
| k3s        | nixos (console) | Runs [k3s](https://k3s.io)                                                         |
| playground | nixos (console) | NixOS playground to fiddle around                                                  |
| toolbox    | nixos (graphic) | VM with some tools preconfigured                                                   |
| snapd      | nixos (console) | Runs [snapd](https://snapcraft.io/docs/get-started)                                |

TODO: Add support for building sixOS. the user could chose to use an instance of nixOS or an instance of sixOS(link to OS). Note graphics apps for sixOS might be scuffed.

Here's the quick TLDR.
sixOS is like if NixOS and Gentoo had a baby. 
- Gentoo but with Haskell instead of Python.
- NixOS but without systemd (s6 init is used instead) and is fully build from source (using nix as build instructions)

A massive motivation for this project is to easilly spin up instances of sixOS as easily as instances of NixOS.

### VUH

- [ ] TODO: Also in './vms/', add flake for the VUH-web-stack (A Virtual Machine img w/ C, D & Haskell Unikernel + Haskell Backend & Front-end-Scaffolding)



# Running VMs

Once the vm is built, the same instructions used for building the vm are used for running the vm.

Makesure you have VM net running.

```shell
sudo /opt/homebrew/opt/socket_vmnet/bin/socket_vmnet --vmnet-gateway\=192.168.105.1 /var/run/socket_vmnet
```

Additionally VMM is just qemu managed through nix. So any prebuilt image that can be run in qemu can be run through the VMM.

Wrapping qemu img with nix(Link to doc)

I used to use a systemd process to wrap qemu and launch an image with permissions for GPU passthrough without libvert. However nix provides a truely universal alternative. 

The following are cancelled for now. Note that the systemd process was necessary for gpu passthrough on linux. It might not be possible to do this with just nix. If that is the case, then the following are still a go:
> - [x] TODO: Merging with my systemd wrapped qemu process Arch Linux script. Test in these systemd distros: Debian (Also test in Ubuntu & PopOS), Arch & NixOS.
> - [x] TODO: Add support for [skarnet](https://skarnet.org/software/)'s [`s6`](https://skarnet.org/software/s6/) init system. Test in Artix (with s6 init) and [sixOS](https://codeberg.org/amjoseph/sixos).
> NOTE: You could you could use nix to auto wrap a qemu vm into a system-d process

Cut and paste into documentation.
{
In case you run into [issues](https://github.com/NixOS/nix/issues/4119) with [sandboxed](https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-sandbox) builds, you can disable the sandbox temporary with `--option sandbox false`.

To learn how to add additional VMs, check out [flake.nix](flake.nix) (look for `mkVm`).

VMs can also be build out-of-tree, see this [example](examples/darwin/nixos-vm).

The QEMU package provided and used by this configuration comes with support for hardware accelerated graphics, based on the awesome work of [Akihiko Odaki](https://gist.github.com/akihikodaki/87df4149e7ca87f18dc56807ec5a1bc5).

The '[qemuGuest](#qemu-guest)' module provides a bunch of useful configuration options for QEMU guests.
}

# Building Blocks

This is the TLDR/quickstart version of the [Scaffolding for Custom System Manager Documentation].

Cover the bery basics of creating your own config to manage your system through the univ-SYSandVMManager

NOTE: Though Nix is some shell script templates are also provided.

# Credits

Special thanks to Markus. My main resource for getting nix, nix-darwin & nix managed VM's running on MacOS.
  - His config: https://github.com/mrkuz/macos-config
  - Original Post: https://www.reddit.com/r/NixOS/comments/1be4j7d/experiments_with_qemu_nixos_vms_on_macos/

Special thanks to Akihiko Odaki for their qemu patch for accelerated graphics on Apple Silicon.
  - https://gist.github.com/akihikodaki/87df4149e7ca87f18dc56807ec5a1bc5

Thanks to the Arch wiki for infomation on wrapping qemu in a system-d process for gpu-passthrough.
