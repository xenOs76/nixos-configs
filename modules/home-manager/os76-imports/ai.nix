{
  pkgs,
  pkgsUnstable,
  ...
}: {
  home.packages = with pkgs; [
    # CLIs
    opencode
    pkgsUnstable.cursor-cli
    pkgsUnstable.cursor-clip

    # IDE
    # pkgsUnstable.antigravity-fhs
    pkgsUnstable.code-cursor-fhs

    # MCP servers
    gitea-mcp-server
    github-mcp-server
    mcp-k8s-go
    mcp-nixos
    terraform-mcp-server
    # mcp-grafana
  ];
}
