# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hibernate / Resume
  boot.resumeDevice = "/dev/nvme0n1p3";

  # Kernel Boot Parameters
  boot.kernelParams = [
  "amd_pstate=active"    # better CPU scaling
  "amdgpu.runpm=0"       # keeps GPU powered to avoid black screen
];

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

 
  # --- Hyprland + Wayland session ---
  programs.hyprland.enable = true;

  # Portals (file pickers / screen share on Wayland)
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr ];

  # Simple Wayland login (no full DE): auto-start Hyprland for your user
  services.greetd = {
  enable = true;
  settings = {
    default_session = {
      command = "Hyprland";
      user = "nixos";
    };
  };
};

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # AMD GPU Enable
  services.xserver.videoDrivers = ["amdgpu"];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    #Use the example session manager?
    #media-session.enable = true;
  };

  #Bluetooth Support
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  #Redistributable Firmware [Bluetooth/WiFi/GPU]
  hardware.enableRedistributableFirmware = true;
 
  #Fonts
  fonts.packages = with pkgs; [
  dejavu_fonts
  noto-fonts
  noto-fonts-color-emoji
  liberation_ttf
  terminus_font

  (stdenv.mkDerivation {
    pname = "maple-mono";
    version = "6.4";
    src = fetchzip {
      url = "https://github.com/subframe7536/Maple-font/releases/download/v6.4/MapleMono-ttf.zip";
      sha256 = "sha256-ealqkTF2PPhEs1xjLWaTtLAdsqooFLUkd3GEoUptHhM="; # replace with your SRI hash
      stripRoot = false;
    };
    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      cp *.ttf $out/share/fonts/truetype/
    '';
  })
  ] ++ (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts));
 
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixos = {
    isNormalUser = true;
    description = "nixos";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # CPU governor and kernel tweaks
  powerManagement.cpuFreqGovernor = "schedutil";  # or "powersave" if you want maximum battery
  services.auto-cpufreq.enable = true;            # dynamic CPU scaling for laptops
  
  # Enable Steam
  programs.steam = {
  enable = true;

  # Extra libraries for Proton
  gamescopeSession.enable = true; # fullscreen compositor
};

  #Gamemode Enable to optimise games in Steam for Hardware + Software
  programs.gamemode.enable = true;

  # AMD-specific tweaks
  hardware.cpu.amd.updateMicrocode = true; # Ensure you have linux-firmware in systemPackages

  # TLP for power tuning
  # TLP still needs values, disable it's governor control
  # Disable TLP's CPU frequency control so auto-cpufreq can take over:
  services.tlp = {
  enable = true;
  settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
    CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";
    CPU_SCALING_GOVERNOR = "ignore";
  };
};  

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Flatpak for programs outside of nixpkgs/NUR
  services.flatpak.enable = true;

  #Enable ZRAM Swap
  zramSwap = {
  enable = true;
  memoryPercent = 25;
};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
  with pkgs; [
  # Hyprland Programs
  hyprpaper
  hyprshot
  hyprpaper

  # Apps
  nwg-look 
  vim 
  wget 
  neofetch 
  firefox 
  vlc 
  libreoffice-fresh
  pkgs.kdePackages.ktorrent
  pkgs.webcord-vencord

  # Utils
  waybar 
  eww
  wofi
  kitty
  nemo
  nautilus
  dconf
  dconf-editor

  # QoL
  git
  brightnessctl 
  pavucontrol 
  xdg-utils 
  unzip 
  curl 
  git 
  neovim 
  htop 
  lm_sensors 
  usbutils 
  pciutils 
  p7zip 
  unzip 
  gparted 
  thunderbird 
  mpv 
  linux-firmware 
  protonvpn-gui
  pkgs.protonmail-desktop
  
  # GPU/CPU tools
  mesa-demos 
  radeontop
  powertop 
  auto-cpufreq
];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
  enable = true;
  enableSSHSupport = true;
};


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
