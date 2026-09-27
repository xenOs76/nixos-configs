{
  pkgs,
  pkgsUnstable,
  ...
}:
{
  home.packages = with pkgs; [
    # CLIs
    opencode
    pkgsUnstable.antigravity-cli
    # pkgsUnstable.cursor-cli
    # pkgsUnstable.cursor-clip

    # IDE
    pkgsUnstable.antigravity-ide-fhs
    # pkgsUnstable.code-cursor-fhs

    # MCP servers
    gitea-mcp-server
    github-mcp-server
    mcp-grafana
    mcp-k8s-go
    mcp-nixos
    mcp-proxy
    playwright-mcp
    terraform-mcp-server
  ];
}
