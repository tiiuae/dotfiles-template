_: {
  programs.ssh = {
    extraConfig = ''
      host ghaf
           user ghaf
           hostname 192.168.10.149
      host vedenemo-builder
            user bmg
            hostname builder.vedenemo.dev
    '';
  };

  services = {
    ssh-agent.enable = true;
  };
}
