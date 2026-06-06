{...}: {
  os76.nix.binaryCache.server.enable = true;

  networking.firewall.interfaces = {
    enp1s0.allowedTCPPorts = [5080];
    wlp3s0.allowedTCPPorts = [5080];
  };
}
