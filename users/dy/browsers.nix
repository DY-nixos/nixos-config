# 把 Firefox 锁为默认浏览器(用户层)。配合 modules/pkgs/default-browser.nix 使用。
#
#   1. ~/.config/mimeapps.list 由 home-manager 生成, 每次 home-manager switch
#      (即 nixos-rebuild switch) 都会重新声明一次。
#   2. xdg-settings / xdg-mime 被 shim 拦截: 任何程序想改默认浏览器/默认邮件
#      客户端, 都会在 journal 里留一条 default-browser-lock 日志, 命令本身
#      返回 0, 所以调用方(比如 Firefox 的"设为默认"检查)不会报错也不会弹窗。
#
# 为什么 shim 有效: useUserPackages = true 时 home.packages 会装进
# /etc/profiles/per-user/<user>/bin, 而它在会话 PATH 里排在
# /run/current-system/sw/bin 前面, 所以 shim 会盖掉系统自带的同名命令。
#
# 已知绕不过去的口子: 直接用 GIO/GSettings 写 ~/.config/mimeapps.list 的程序
# (GLib 系应用) 不走 xdg-settings, 只能靠下次 home-manager switch 恢复。

{ config, pkgs, lib, ... }:

let
  browser = "firefox.desktop";

  # 和 modules/pkgs/default-browser.nix 的兜底表保持一致
  mimeTypes = [
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "text/html"
    "application/xhtml+xml"
    "application/x-extension-html"
    "application/x-extension-htm"
    "application/x-extension-shtml"
    "application/x-extension-xhtml"
    "application/x-extension-xht"
  ];

  # 拒绝 `xdg-settings set default-web-browser ...`(以及 set default-email-client),
  # 其余子命令原样转发给真正的 xdg-utils。
  locked = command: pkgs.writeShellScriptBin command ''
    real="${pkgs.xdg-utils}/bin/${command}"

    blocked() {
      logger -t default-browser-lock \
        -- "已拒绝 \`$(basename "$0") $*\`, 默认浏览器锁定为 ${browser}" \
        || true
      # 返回 0 而不是 1: 让调用方以为设置成功, 免得弹错误框
      exit 0
    }

    case "$1" in
      set)
        case "$2" in
          default-web-browser | default-email-client) blocked ;;
        esac
        ;;
      default)
        # xdg-mime default <desktop> <mimetype>
        blocked
        ;;
    esac

    exec "$real" "$@"
  '';
in
{
  xdg.mimeApps.defaultApplications = lib.genAttrs mimeTypes (_: [ browser ]);

  home.packages = [
    (locked "xdg-settings")
    (locked "xdg-mime")
  ];
}
