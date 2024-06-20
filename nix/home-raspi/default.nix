{
  pkgs, ...
}: {
  config = {
    nix.settings.trusted-users = [ "root" ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nixpkgs.config.allowUnfree = true;
    time.timeZone = "Australia/Melbourne";
    sdImage.compressImage = false;
    users.users.root.password = "passwordSample";
    networking.firewall.enable = false;
    networking.hostName = "casper";
    system.stateVersion = "24.05";
    environment.systemPackages = with pkgs; [
      git
      gnupg
      fastfetch

      tailscale
      zellij
    ];
    
    services.openssh.enable = true;
    services.openssh.settings.PasswordAuthentication = true;
    services.openssh.settings.PermitRootLogin = "yes";

    programs.thefuck.enable = true;

  };
}
