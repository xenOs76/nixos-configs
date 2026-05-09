{
  pkgs,
  pkgsUnstable,
  antigravity,
  ...
}: {
  home.packages = with pkgs; [
    # IDE
    antigravity.packages.${pkgs.stdenv.hostPlatform.system}.default

    # CLIs
    opencode
    pkgsUnstable.gemini-cli

    # MCP servers
    gitea-mcp-server
    github-mcp-server
    mcp-k8s-go
    mcp-nixos
    terraform-mcp-server
    # mcp-grafana
  ];
}
