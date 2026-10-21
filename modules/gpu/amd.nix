{ config, lib, pkgs, ... }:

{
  # 启用图形加速（对 AMD 也适用）
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # 启用 AMDGPU 对老架构（HD 7000/8000 系列）的支持
  # 你的核显 HD 7640G 和独显 HD 8600/8700M 都需要这个
  hardware.amdgpu.legacySupport.enable = true;
}