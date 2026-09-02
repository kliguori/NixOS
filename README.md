# NixOS
This repo contains my NixOS configurations for the below systems.

## Sherlock
Sherlock is my desktop and main system.
- MSI ACE MEG x570
- Ryzen 9 3900X (12 core)
- Nvidia 2080Ti 
- 2x16 GB DDR4
- 500 GB nvme
- 500 GB nvme
- 1 TB HDD

## Watson
Watson will be my primary laptop.

## Lestrade
Lestrade is backup laptop.
- Dell XPS15 9500 
- i7 10750H (6 core)
- GTX 1650Ti
- 2x8 GB DDR4
- 500 GB nvme

## Gregson
Gregson is a (somewhat) usefull testbed for watson/lestrade.
- Lenovo ThinkPad T14 Gen 1 
- Ryzen 7 Pro 4750U (8 core)
- 16 GB (soldered) DDR4
- 8 GB SoDimm DDR4

## Hudson
Hudson is a home server.

## Mycroft
Mycroft is a remote backup target.

## Wiggins
Wiggins will be a vps for running headscale.

## To do:
- [x] Fix claude vm

## About installing and managing
nix run github:nix-community/nixos-anywhere/<tag> -- \                                            17:58:48
--flake .#<host> \
--disk-encryption-keys /tmp/luks.key <path-to-luks-key> \
--extra-files <path-to-extra-folder> \
--target-host root@<ip-of-target>
