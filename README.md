# Ansible Bootstrap Playbook

This repository contains an Ansible playbook designed to bootstrap a Linux system with necessary packages, configurations, and system tweaks. The playbook is tailored for environments using Arch focusing on setting up a GNOME desktop environment and various utilities.

## Features

This playbook will perform the following tasks:

### Pre-Run Setup
- Update package cache (Arch)
- Install necessary Ansible packages

### GNOME Desktop Environment Setup
- Install GNOME and GNOME Extra packages
- Configure GNOME peripherals (mouse, keyboard, etc.)
- Set GNOME shell settings (appearance, keybindings, etc.)
- Install and configure GNOME extensions
- Set up GNOME Terminal and keybindings
- Apply various GNOME system tweaks

### Software Installation
- Install VirtualBox and Extension Pack (including EULA acceptance)
- Install Telegram Desktop
- Install additional software using YAY (e.g., Spotify, VS Code)
- Install and configure ZRAM for improved memory management

### System Services and Utilities
- Set up udev rules and handlers
- Install and start the `tailscaled` service
- Create and configure systemd services (e.g., ZRAM service)
- Install and configure Fish shell
- Set up a new user with appropriate configurations and sudo access

### Custom Scripts and Configurations
- Copy and apply custom shell scripts
- Set up custom fonts and refresh font cache
- Apply various system tweaks (e.g., disable camera shutter sound)
- Manage temporary files and directories

## Requirements

- Ansible must be installed on the control node.
- The target machine should be running Arch btw

## Usage
Do not use it. It won't satisfy you and might break something since it's tailored to my use.

* You should use it as an example only.
