# Linux Setup Scripts
My setup scripts for my workstations. You should edit the scripts to your liking before running it.
Please run the scripts as your actual user and not root. Provide sudo password when it asks you to. Flatpak packages and themes/icons are only installed for your user and not system wide. <br />

The printing stack (cups) is removed as I do not use it.

Visit my Matrix group: https://matrix.to/#/#tommytran732:matrix.org

## Notes on DNS handling

For desktop installations, the assumption here is that you will use a VPN of some sort for your privacy. No custom DNS server will be configured, as websites [can detect](https://www.dnsleaktest.com/) that you are using a different DNS server from your VPN provider's server.

For server installations (except Proxmox), Unbound will be configured to handle local DNSSEC validation. The difference in the scripts on how this is set up are because of the following reasons:

- Each distribution needs its own Unbound configuration due to version differences and how each distro package it.
- If both Unbound and systemd-resolved are preset on the system, whichever one get used depends entirely depends on whether systemd-resolved is running and controlling `/etc/resolv.conf` or not. My scripts set Unbound to enabled and systemd-resolved whenever possible.
- If systemd-resolved is not present on the system, NetworkManager will take control of `/etc/resolv.conf`. RHEL does not ship with systemd-resolved, so manual configuration to set NetworkManager to use the local DNS forwarder is needed.

# Arch Linux
Check out this repository: https://github.com/tommytran732/Arch-Setup-Script <br />

# Qubes OS

Checkout this repository: https://github.com/tommytran732/QubesOS-Scripts <br />

# Fedora CoreOS

Checkout this repository: https://github.com/tommytran732/Fedora-CoreOS-Ignition

