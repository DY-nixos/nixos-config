{
  description = "NixOS multi-host configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # 添加 zen-browser 的 flake 输入
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # 添加 nixpak 输入
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, ... }@inputs:
  let
    hostSystem = "x86_64-linux";
    lib = nixpkgs.lib;

    # 递归加载目录下所有 .nix 文件
    loadModulesFrom = path:
      if builtins.pathExists path then
        let
          entries = builtins.readDir path;
          names = builtins.attrNames entries;
          nixFiles = map (f: path + "/${f}")
            (builtins.filter (n: entries.${n} == "regular" && lib.hasSuffix ".nix" n) names);
          subDirs = builtins.filter (n: entries.${n} == "directory") names;
          subModules = builtins.concatMap (d: loadModulesFrom (path + "/${d}")) subDirs;
        in
        nixFiles ++ subModules
      else [];

    systemModules = loadModulesFrom ./modules;

    validUsers =
      if builtins.pathExists ./users then
        builtins.filter (name: builtins.pathExists (./users + "/${name}"))
          (builtins.attrNames (builtins.readDir ./users))
      else [];

    # 构建用户配置（修复：添加默认的 stateVersion）
    userConfigs = 
      if validUsers != [] then
        builtins.listToAttrs (map (username: {
          name = username;
          value = { config, pkgs, ... }: {
            imports = loadModulesFrom (./users + "/${username}");
            home.stateVersion = "24.11";
            programs.home-manager.enable = true;
          };
        }) validUsers)
      else {
        dy = { config, pkgs, ... }: {
          home.stateVersion = "24.11";
          programs.home-manager.enable = true;
        };
      };

    mkHost = hostName: hostConfig:
      lib.nixosSystem {
        specialArgs = { inherit inputs hostName; };
        modules = [
          stylix.nixosModules.stylix  # ← 添加这一行！
          { networking.hostName = hostName; }
          hostConfig
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users = userConfigs;
              # 可选：自动备份冲突文件
              backupFileExtension = "backup";
            };
          }
        ] ++ systemModules;
      };
  in
  {
    nixosConfigurations.dynx = mkHost "dynx" ./hosts/dynx/configuration.nix;
    nixosConfigurations.dynix = mkHost "dynix" ./hosts/dynix/configuration.nix;
  };
}