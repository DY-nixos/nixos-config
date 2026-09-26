{ pkgs, ... }:

# Blender 固定在 5.0.1。
#
# 切换版本: 只改下面 version 和 hash 两行, 然后 sudo nixos-rebuild switch
# 新版本的 hash 这样拿:
#   nix store prefetch-file --json \
#     https://download.blender.org/release/Blender<主版本>/blender-<版本>-linux-x64.tar.xz \
#     | jq -r .hash
# 可用版本列表: https://download.blender.org/release/
#
# 为什么不用 nixpkgs 里的 blender:
# 1. nixpkgs 的 blender 是源码编译的, 改版本号会触发本地编译(几小时), 没法锁版本。
# 2. 更关键: nixpkgs 构建把 OpenImageIO 的 Python 绑定剔掉了, 而 MACHIN3tools
#    之类的插件顶层就 import OpenImageIO, 会导致插件装不上。官方包自带绑定。
let
  inherit (pkgs)
    lib
    stdenv
    stdenvNoCC
    fetchurl
    makeWrapper
    patchelf
    addDriverRunpath
    xorg
    libGL
    vulkan-loader
    libxkbcommon
    alsa-lib
    pipewire
    pulseaudio
    ;

  version = "5.0.1";
  hash = "sha256-gBlYDuG3Ji5QX0GWoAI3zPdDyI0gWzjTQgFRBnbmCwk=";

  dynamicLinker = stdenv.cc.bintools.dynamicLinker;

  # 官方包是给通用 Linux 编译的, 依赖的 X11/GL/vulkan 库得手动指过去
  glibc = lib.makeLibraryPath [
    xorg.libX11
    xorg.libXrender
    xorg.libXfixes
    xorg.libXi
    xorg.libXext
    xorg.libXxf86vm
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXdamage
    xorg.libXcomposite
    xorg.libSM
    xorg.libICE
    libGL
    vulkan-loader
    libxkbcommon
    stdenv.cc.cc
    alsa-lib
    pipewire
    pulseaudio
  ];
  blender = stdenvNoCC.mkDerivation {
    pname = "blender";
    inherit version;

    src = fetchurl {
      url = "https://download.blender.org/release/Blender${lib.versions.major version}/blender-${version}-linux-x64.tar.xz";
      inherit hash;
    };

    sourceRoot = "blender-${version}-linux-x64";
    nativeBuildInputs = [ makeWrapper patchelf addDriverRunpath ];
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      # 目录结构必须原样保留: blender 靠 /proc/self/exe 找同级的 lib/ 和 <版本>/ 目录
      mkdir -p $out/bin
      cp -a ./. $out/
      rm -f $out/blender-launcher $out/blender-thumbnailer $out/blender-softwaregl

      install -Dm644 $out/blender.desktop $out/share/applications/blender.desktop
      install -Dm644 $out/blender.svg $out/share/icons/hicolor/scalable/apps/blender.svg
      install -Dm644 $out/blender-symbolic.svg $out/share/icons/hicolor/scalable/apps/blender-symbolic.svg
      rm -f $out/blender.desktop $out/blender.svg $out/blender-symbolic.svg

      # 官方包的 ELF 解释器指向 /lib64/ld-linux-x86-64.so.2, NixOS 上不存在
      patchelf --set-interpreter ${dynamicLinker} $out/blender

      makeWrapper $out/blender $out/bin/blender \
        --prefix LD_LIBRARY_PATH : ${glibc}

      runHook postInstall
    '';

    meta = {
      description = "3D Creation/Animation/Publishing System (官方预编译包, 版本锁定)";
      homepage = "https://www.blender.org";
      license = lib.licenses.gpl2Plus;
      platforms = [ "x86_64-linux" ];
      mainProgram = "blender";
    };
  };
in
{
  environment.systemPackages = [ blender ];
}
