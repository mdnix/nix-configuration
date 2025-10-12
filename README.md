# ❄️ NixOS Configuration

Personal NixOS configuration using flakes and modular system organization, primarily focused on creating an optimal development environment.

[![Built with Nix](https://img.shields.io/badge/Built%20with-Nix-5277C3.svg?logo=nixos&logoColor=white)](https://nixos.org)

## Features

- **Modular Architecture** - Clean separation of concerns with reusable modules
- **Hyprland Desktop** - Modern Wayland compositor with beautiful animations
- **Development Ready** - Go, Rust, Zig, Node.js with Docker & devcontainer support
- **Flake-based** - Reproducible builds and dependency management
- **Home Manager** - Declarative dotfile management

## Structure

```
├── hosts/          # Machine-specific configurations
├── modules/        # Reusable system & home-manager modules
├── files/          # Dotfiles and static configuration files
├── overlays/       # Package overlays and modifications
└── Makefile        # Build automation scripts
```

## Quick Start

```bash
# Update all flake inputs
make update

# Build and activate configuration
make switch

# Clean old system generations
make gc

# Show all available commands
make help
```

## Profiles

| Profile | Description | Key Packages |
|---------|-------------|--------------|
| 🖥️ **Desktop** | Hyprland, multimedia, utilities | `hyprland` `ghostty` `nautilus` `spotify` |
| 👨‍💻 **Development** | Languages, tools, containers | `go` `rust` `zig` `nodejs` `docker` |
| 📄 **Office** | Productivity and communication | `libreoffice` `discord` `mullvad-vpn` |
| 🔧 **Tools** | System utilities and monitoring | `btop` `ripgrep` `wireshark` |

## Desktop Environment

- **WM**: Hyprland with custom animations
- **Bar**: HyprPanel with system monitoring
- **Terminal**: Ghostty with Zsh and Starship
- **File Manager**: Nautilus
- **Theme**: Custom dark theme with purple accents