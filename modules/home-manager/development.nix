{pkgs, ...}: {
  home.packages = with pkgs; [
    devenv
    commitizen

    ### Editors
    jetbrains.idea-community-bin
    # jetbrains.pycharm-community-bin
    thonny

    # Make / Iot
    circup
    esphome
    screen
    arduino
    fritzing
    mosquitto
    mqttx
    bossa

    ### Languages
    go
    tinygo

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

    ### Format/Lint
    lua-language-server
    black
    stylua
    prettierd
    nil
    nixd
    yamlfmt
    shellcheck
    shfmt
    terraform-ls
    terraform-docs
    tflint

    gopls
    gotools
    golangci-lint
    gofumpt
    gomodifytags
    golines
    gci
    impl
    delve
  ];

  home.file = {
    # https://github.com/google/yamlfmt/blob/main/docs/config-file.md
    ".config/yamlfmt/.yamlfmt.yaml".text = ''
      formatter:
        type: basic
        include_document_start: true
        retain_line_breaks_single: true
    '';
  };
}
