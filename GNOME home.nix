{ config, pkgs, lib, ... }:

{
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  programs.home-manager.enable = true;

  ########################################
  # GNOME dconf
  ########################################
  dconf.settings = {

    "org/gnome/shell" = {
      disable-user-extensions = false;

      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "Vitals@CoreCoding.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "GSConnect@andyholmes.github.io"
        "clipboard-indicator@tudmotu.com"
      ];

      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Nautilus.desktop"
        "kitty.desktop"
        "thunderbird.desktop"
      ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      text-scaling-factor = 1.2;
      enable-hot-corners = false;
    };

    "org/gnome/mutter" = {
      experimental-features = [
        "scale-monitor-framebuffer"
        "fractional-scaling"
        "variable-refresh-rate"
        "xwayland-grab-default"
      ];
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      natural-scroll = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/a11y/applications" = {
      screen-keyboard-enabled = true;
    };
  };

  ########################################
  # GNOME Extensions (actual ones in nixpkgs)
  ########################################
  home.packages = with pkgs; [
    gnomeExtensions.dash-to-dock
    gnomeExtensions.vitals
    gnomeExtensions.appindicator
    gnomeExtensions.gsconnect
    gnomeExtensions.clipboard-indicator

    gnome-tweaks
    gnome-extensions
  ];

  xdg.enable = true;

  home.stateVersion = "25.05";
}
