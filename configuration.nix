# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  # TODO Make backspace work on my machine
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "dk";
    xkb.variant = "";
    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome = {
      enable = true;
    };
  };
    
  programs = {
    dconf = {
      enable = true;
      profiles.user.databases = [
        {
          lockAll = true;
          settings = {
            # Got this from https://gitlab.com/engmark/root/-/merge_requests/446/diffs
            "org/gnome/desktop/wm/keybindings" = {
              # Got this from https://askubuntu.com/a/1107542
              switch-windows = ["<Alt>Tab"];
              switch-windows-backward = ["<Shift><Alt>Tab"];
              switch-applications = ["<Super>Tab"];
              switch-applications-backward = ["<Shift><Super>Tab"];
            };

           # "org/gnome/settings-daemon/plugins/media-keys" = {
           #   terminal = ["<Alt><Ctrl>t"];
           # };

            "org/gnome/desktop/default-applications/terminal" = {
              exec = "alacritty";
            };

            "org/gnome/settings-daemon/plugins/media-keys" = {
              custom-keybindings=[
                "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
              ];
            };
            
            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
              binding="<Ctrl><Alt>t";
              command="alacritty";
              name="Terminal";
            };
          };
        }
      ];
    };
  };

  # Configure console keymap
  console.keyMap = "dk-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.robbingdahood = {
    isNormalUser = true;
    description = "Daniel";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "robbingdahood";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
        # TODO This is depricated: https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/vim.section.md
    	vim_configurable # https://nixos.wiki/wiki/Vim
        discord
        jetbrains.idea-ultimate
        # https://nixos.wiki/wiki/Fish
        fish # hos to be defined here because setting it as default shell requires root access: https://www.reddit.com/r/NixOS/comments/z16mt8/comment/ix9r4b2/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
  ];


  programs.fish.enable = true;
  users.extraUsers.robbingdahood = {
      shell = pkgs.fish;
  };

  # Also read https://nixos.wiki/wiki/GNOME  
  environment.gnome.excludePackages = [ 
    pkgs.gnome-tour 
    pkgs.baobab
    pkgs.epiphany
    pkgs.evince
    pkgs.yelp # help viewer
    pkgs.gnome.geary # email client
    pkgs.gnome.totem
    pkgs.gnome.simple-scan
    pkgs.gnome.gnome-characters
    pkgs.gnome.gnome-calculator
    pkgs.gnome.gnome-contacts
    pkgs.gnome.gnome-logs
    pkgs.gnome.gnome-maps
    pkgs.gnome.gnome-music
    pkgs.gnome.gnome-screenshot
    pkgs.gnome.gnome-system-monitor
    pkgs.gnome-text-editor
    pkgs.gnome-connections
    pkgs.gnome-console
    pkgs.xterm
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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
  system.stateVersion = "23.11"; # Did you read the comment?

}
