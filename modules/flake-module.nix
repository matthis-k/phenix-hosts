{ ... }: {
  phenix.overlays = [(final: prev: {
    phenix = (prev.phenix or {}) // {
      hello-hosts = final.writeShellScriptBin "hello-hosts" ''
        echo "hello from hosts"
      '';
    };
  })];
}
