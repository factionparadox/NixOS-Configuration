{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.resumeDevice = "/dev/nvme0n1p3";

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "i915.enable_psr=0"
    "i915.enable_fbc=1"
    "i915.fastboot=1"
  ];

  networking.hostName = "framework12";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.xkb.layout = "gb";

  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.tapping = true;
  services.xserver.libinput.touchpad.naturalScrolling = true;

  hardware.cpu.intel.updateMicrocode = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.printing.enable = true;
  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;

  powerManagement.cpuFreqGovernor = "schedutil";
  services.auto-cpufreq.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
      CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";
      CPU_SCALING_GOVERNOR = "ignore";
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  services.flatpak.enable = true;

  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    dejavu_fonts
    noto-fonts
    noto-fonts-emoji
    liberation_ttf
    terminus_font

    (stdenv.mkDerivation {
      pname = "maple-mono";
      version = "6.4";
      src = fetchzip {
        url = "https://github.com/subframe7536/Maple-font/releases/download/v6.4/MapleMono-ttf.zip";
        sha256 = "sha256-ealqkTF2PPhEs1xjLWaTtLAdsqooFLUkd3GEoUptHhM=";
        stripRoot = false;
      };
      installPhase = ''
        mkdir -p $out/share/fonts/truetype
        cp *.ttf $out/share/fonts/truetype/
      '';
    })

  ] ++ (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts));

  environment.systemPackages = with pkgs; [
    firefox vlc libreoffice-fresh thunderbird
    protonvpn-gui pkgs.protonmail-desktop
    pkgs.kdePackages.ktorrent pkgs.webcord-vencord
    mpv kitty nemo nautilus dconf dconf-editor
    wget curl git neovim htop unzip p7zip
    lm_sensors usbutils pciutils linux-firmware
    brightnessctl powertop auto-cpufreq mesa-demos glxinfo
    gparted neofetch
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.logind.extraConfig = ''
    HandleLidSwitch=hibernate
    HandleLidSwitchDocked=ignore
    IdleAction=hibernate
    IdleActionSec=30min
  '';

  system.stateVersion = "25.05";
}
