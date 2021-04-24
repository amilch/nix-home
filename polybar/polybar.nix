{ pkgs, ... }:

let
  POLYBAR_SCRIPTS = pkgs.fetchgit {
    url = "https://github.com/polybar/polybar-scripts";
    sha256 = "02grwrah7vk6ahbssxbmbml88804dykgvvv2vc33gyi69aj5zv93";
  };
  POLYBAR_SPOTIFY = pkgs.fetchgit {
    url = "https://github.com/Jvanrhijn/polybar-spotify";
    sha256 = "036z2w52a6a13jvyvxzr320fj3w1shgs0b1gkvnm6rp3ir3h288y";
  };


in {
  home.file.".config/polybar/info-hlwm-workspaces.sh" = {
    text = builtins.replaceStrings ["# TODO Add your formatting tags for focused workspaces"] ["echo '%{F#ef6b7b}'"] (builtins.readFile "${POLYBAR_SCRIPTS}/polybar-scripts/info-hlwm-workspaces/info-hlwm-workspaces.sh");
    executable = true;
  };

  home.file.".config/polybar/spotify_status.py".source = "${POLYBAR_SPOTIFY}/spotify_status.py";

  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;
    script = "";
    config =  {
      "bar/main" = {
        background = "#333333";
        foreground = "#fafafa";
        border-left-size = 1;
        border-left-color = "#333333";
        border-right-size = 1;
        border-right-color = "#333333";
        border-top-size = 5;
        border-top-color = "#333333";
        border-bottom-size = 2;
        border-bottom-color = "#333333";
        font-0 = "Inter:size=10";
        font-1 = "Material Design Icons Desktop:size=13";
        modules-left = "info-hlwm-workspaces";
        modules-right = "pulseaudio bat0 bat1 date";
        tray-position = "right";
      };
      "module/info-hlwm-workspaces" = {
        type = "custom/script";
        exec = "~/.config/polybar/info-hlwm-workspaces.sh";
        tail = true;
        scroll-up = "herbstclient use_index -1 --skip-visible &";
        scroll-down = "herbstclient use_index +1 --skip-visible &";
      };
      "module/pulseaudio" = {
        type = "internal/pulseaudio";
        use-ui-max = true;
        format-volume-padding = 3;
        format-muted-padding = 3;
        label-muted = "󰝟";
        label-volume = "󰕾 %percentage%%";
      };
      "module/bat0" = {
        type = "internal/battery";
        battery = "BAT0";
        format-full = "<ramp-capacity>";
        format-discharging = "<ramp-capacity>";
        format-charging = "<ramp-capacity>󱐥";
        format-full-padding = 3;
        format-charging-padding = 3;
        format-discharging-padding = 3;
        ramp-capacity-0 = "󱃍";
        ramp-capacity-0-foreground = "#ff0000";
        ramp-capacity-1 = "󰁼";
        ramp-capacity-2 = "󰁾";
        ramp-capacity-3 = "󰂀";
        ramp-capacity-4 = "󰁹";
      };
      "module/bat1" = {
        type = "internal/battery";
        battery = "BAT1";
        format-full = "<ramp-capacity>";
        format-discharging = "<ramp-capacity>";
        format-charging = "<ramp-capacity>󱐥";
        format-full-padding = 3;
        format-charging-padding = 3;
        format-discharging-padding = 3;
        ramp-capacity-0 = "󱃍";
        ramp-capacity-0-foreground = "#ff0000";
        ramp-capacity-1 = "󰁼";
        ramp-capacity-2 = "󰁾";
        ramp-capacity-3 = "󰂀";
        ramp-capacity-4 = "󰁹";
      };
      "module/date" =
        let
          calnotify = pkgs.writeShellScript "calnotify.sh" ''
            day="$(${pkgs.coreutils}/bin/date +'%-d ' | ${pkgs.gnused}/bin/sed 's/\b[0-9]\b/ &/g')"
            cal="$(${pkgs.utillinux}/bin/cal | ${pkgs.gnused}/bin/sed -e 's/^/ /g' -e 's/$/ /g' -e "s/$day/\<span color=\'#555555\'\>\<b\>$day\<\/b\>\<\/span\>/" -e '1d')"
            top="$(${pkgs.utillinux}/bin/cal | ${pkgs.gnused}/bin/sed '1!d')"
            ${pkgs.libnotify}/bin/notify-send "$top" "$cal"
          '';
        in
        {
          type = "internal/date";
          date = "󰅐 %H:%M      󰸘 %a %b %d   ";
          label = "%{A1:${calnotify}:}%date%%{A}";
          format = "<label>";
          label-padding = 3;
        };
    };
  };
}
