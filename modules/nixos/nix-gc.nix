{
  nix = {
    settings = {
      auto-optimise-store = true;
      keep-outputs = false;
      keep-derivations = false;
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };
}
