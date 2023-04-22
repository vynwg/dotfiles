{pkgs, ...}:
{
  systemd.services.rustdesk = {
    enable = true;
    description = "RustDesk";
    after = [ "systemd-user-sessions.service" ];
    requires = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.rustdesk}/bin/rustdesk --service";
      KillMode = "mixed";
      TimeoutStopSec = 30;
      User = "vynwg";
    };
  };
}
