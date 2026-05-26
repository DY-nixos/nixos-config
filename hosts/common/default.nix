{ config, pkgs, ... }: {

  # --- Nix 配置 ---
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];
    download-buffer-size = 134217728;
  };

  time.timeZone = "Asia/Shanghai";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";

  # --- 引导 ---
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader = {
    grub = {
      enable = true;
      extraEntries = ''
        menuentry "Windows" {
            search --file --no-floppy --set=root /EFI/Microsoft/Boot/bootmgfw.efi
            chainloader (''${root})/EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
    };
  };

  boot.supportedFilesystems = [ "ntfs" "exfat" "vfat" "ext4" ];
  boot.loader.timeout = -1;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = false;



  # do not need to keep too much generations
  # boot.loader.systemd-boot.configurationLimit = 10;
   boot.loader.grub.configurationLimit = 10;

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Optimise storage
  # you can also optimise the store manually via:
  #    nix-store --optimise
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;


  # --- 桌面音频 ---
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # --- 用户 ---
  users.users.dy = {
    isNormalUser = true;
    description = "dy";
    extraGroups = [
      "networkmanager" "wheel" "libvirtd" "kvm"
      "storage" "disk" "video"
      "docker" "render"
    ];
  };
}
