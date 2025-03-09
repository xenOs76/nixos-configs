{pkgs, ...}: {
  home.packages = with pkgs; [
    # Editors
    vscode
    jetbrains.idea-community-bin
    thonny

    # Make / Iot
    circup
    esphome
    screen
    arduino
    fritzing
    mosquitto
    mqttx

    # Languages
    go

    (python3.withPackages (
      ps:
        with ps; [
          rsa
          boto3
          boto3-stubs
          botocore
          packaging
          pip
          pylint
          urllib3
          types-urllib3
          pipx
          twine
          distutils
        ]
    ))

    ansible
    ansible-lint
    poetry

    #terraform
    opentofu
    tfswitch

    # Format/Lint
    lua-language-server
    black
    stylua
    prettierd
    nil
    nixd
    yamlfix
    shellcheck
    shfmt
    terraform-ls
    terraform-docs
    tflint
    gopls
  ];
}
