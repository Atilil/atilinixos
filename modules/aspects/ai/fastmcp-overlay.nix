_: let
  # 3 flaky anyio cancel-scope tests break the build of fastmcp 3.2.3 (dependency of mcp-nixos)
  overlay = _: prev: {
    pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
      (_: pyPrev: {
        fastmcp =
          if pyPrev.fastmcp.version == "3.2.3"
          then
            pyPrev.fastmcp.overridePythonAttrs (old: {
              disabledTestPaths =
                (old.disabledTestPaths or [])
                ++ map (t: "tests/server/providers/proxy/test_stateful_proxy_client.py::TestStatefulProxyClient::${t}") [
                  "test_concurrent_log_requests_no_mixing"
                  "test_stateful_proxy"
                  "test_multi_proxies_no_mixing"
                ];
            })
          else if prev.lib.versionOlder pyPrev.fastmcp.version "3.2.3"
          then pyPrev.fastmcp
          else prev.lib.warn "fastmcp overlay is obsolete (fastmcp ${pyPrev.fastmcp.version}): remove modules/aspects/ai/fastmcp-overlay.nix" pyPrev.fastmcp;
      })
    ];
  };
in {
  den.aspects.ai = {
    os.nixpkgs.overlays = [overlay];
    # Integrated HM inherits the NixOS overlays; standalone HM needs its own
    homeManager = {
      config,
      lib,
      ...
    }: {
      nixpkgs.overlays = lib.mkIf (!config.submoduleSupport.enable) [overlay];
    };
  };
}
