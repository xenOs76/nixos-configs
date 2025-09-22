{pkgs, ...}: {
  home.packages = with pkgs; [
    kubectl
    kubectl-node-shell
    kubectl-images
    kubectl-ktop
    kubectl-view-secret
    kubectl-explore
    kubectl-example
    kubectl-doctor
    krew
    kubectx
    istioctl
    k9s
    kubecolor
    velero
    kubecolor
    (wrapHelm kubernetes-helm {
      plugins = [
        kubernetes-helmPlugins.helm-diff
        kubernetes-helmPlugins.helm-s3
      ];
    })
  ];

  programs.k9s.enable = true;
  catppuccin.k9s.enable = true;

  home.file = {
    # https://kubecolor.github.io/reference/config/
    # https://github.com/vkhitrin/kubecolor-catppuccin
    # https://github.com/vkhitrin/kubecolor-catppuccin/blob/main/catppuccin-frappe.yaml
    ".kube/color.yaml".text = ''
      preset: "dark"
      theme:
        base:
          info: fg=#c6d0f5
          primary: fg=#ca9ee6
          secondary: fg=#99d1db
          success: fg=#a6d189:bold
          warning: fg=#e5c890:bold
          danger: fg=#e78284:bold
          muted: fg=#838ba7
          key: fg=#babbf1:bold
        default: fg=#c6d0f5
        data:
          key: fg=#babbf1:bold
          string: fg=#c6d0f5
          "true": fg=#a6d189:bold
          "false": fg=#e78284:bold
          number: fg=#ca9ee6
          "null": fg=#838ba7
          quantity: fg=#ca9ee6
          duration: fg=#ef9f76
          durationfresh: fg=#a6d189
          ratio:
            zero: fg=#838ba7
            equal: fg=#a6d189
            unequal: fg=#e5c890
        status:
          success: fg=#a6d189:bold
          warning: fg=#e5c890:bold
          error: fg=#e78284:bold
        table:
          header: fg=#c6d0f5:bold
          columns: fg=#c6d0f5
        stderr:
          default: fg=#c6d0f5
          error: fg=#e78284:bold
        describe:
          key: fg=#babbf1:bold
        apply:
          created: fg=#a6d189
          configured: fg=#e5c890
          unchanged: fg=#c6d0f5
          dryrun: fg=#99d1db
          fallback: fg=#c6d0f5
        explain:
          key: fg=#babbf1:bold
          required: fg=#303446:bold
        options:
          flag: fg=#babbf1:bold
        version:
          key: fg=#babbf1:bold
    '';

    # Fetch k9s skin from https://github.com/catppuccin/k9s
    # ".config/k9s/skins/catppuccin-frappe-transparent.yaml".text = builtins.readFile (
    #   builtins.fetchurl {
    #     url = "https://raw.githubusercontent.com/catppuccin/k9s/refs/heads/main/dist/catppuccin-frappe-transparent.yaml";
    #     sha256 = "sha256:0jl7ny00s2db4h3zlimayyaivrnwy06rn348s5hhkkypkzjcm2kp";
    #   }
    # );
    #
    # Create a list of plugins. Ref. https://github.com/derailed/k9s/tree/master/plugins
    ".config/k9s/plugins.yaml".text = ''
      plugins:
        # --- Create debug container for selected pod in current namespace
        # See https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/#ephemeral-container
        debug:
          shortCut: Shift-D
          description: Add debug container
          dangerous: true
          scopes:
            - containers
          command: bash
          background: false
          confirm: true
          args:
            - -c
            - "kubectl --kubeconfig=$KUBECONFIG debug -it --context $CONTEXT -n=$NAMESPACE $POD --target=$NAME --image=nicolaka/netshoot:v0.13 --share-processes -- bash"
        ###############################################################################
        # Requires helm-diff plugin installed: https://github.com/databus23/helm-diff
        # In helm view: <Shift-D> Diff with Previous Revision
        # In helm-history view: <Shift-Q> Diff with Current Revision
        helm-diff-previous:
          shortCut: Shift-D
          confirm: false
          description: Diff with Previous Revision
          scopes:
            - helm
          command: bash
          background: false
          args:
            - -c
            - >-
              LAST_REVISION=$(($COL-REVISION-1)); helm diff revision $COL-NAME $COL-REVISION $LAST_REVISION --kube-context $CONTEXT --namespace $NAMESPACE --color | less -RK
        helm-diff-current:
          shortCut: Shift-Q
          confirm: false
          description: Diff with Current Revision
          scopes:
            - history
          command: bash
          background: false
          args:
            - -c
            - >-
              RELEASE_NAME=$(echo $NAME | cut -d':' -f1); LATEST_REVISION=$(helm history -n $NAMESPACE --kube-context $CONTEXT $RELEASE_NAME | grep deployed | cut -d$'\t' -f1 | tr -d ' \t'); helm diff revision $RELEASE_NAME $LATEST_REVISION $COL-REVISION --kube-context $CONTEXT --namespace $NAMESPACE --color | less -RK
        ###############################################################################
        # watch events on selected resources
        # requires linux "watch" command
        # change '-n' to adjust refresh time in seconds
        watch-events:
          shortCut: Shift-E
          confirm: false
          description: Get Events
          scopes:
            - all
          command: sh
          background: false
          args:
            - -c
            - "kubectl events --context $CONTEXT --namespace $NAMESPACE --for $RESOURCE_NAME.$RESOURCE_GROUP/$NAME --watch"
        ###############################################################################
        helm-default-values:
          shortCut: Shift-V
          confirm: false
          description: Chart Default Values
          scopes:
            - helm
          command: sh
          background: false
          args:
            - -c
            - >-
              revision=$(helm history -n $NAMESPACE --kube-context $CONTEXT $COL-NAME | grep deployed | cut -d$'\t' -f1 | tr -d ' \t'); kubectl get secrets --context $CONTEXT -n $NAMESPACE sh.helm.release.v1.$COL-NAME.v$revision -o yaml | yq e '.data.release' - | base64 -d | base64 -d | gunzip | jq -r '.chart.values' | yq -P | less -K
    '';
  };
}
