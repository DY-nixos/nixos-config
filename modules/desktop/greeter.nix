{config, lib, pkgs, ...}: 

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
        command = "${lib.getExe pkgs.tuigreet} --sessions /run/current-system/sw/share/wayland-sessions --time --time-format '%Y-%m-%d %H:%M' --asterisks --remember --remember-session";
      };
    };
  };
}