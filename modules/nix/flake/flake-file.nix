{inputs, ...}: {
  # renovate: datasource=github-tags depName=vic/flake-file
  flake-file.inputs.flake-file.url = "github:vic/flake-file/v0.7.0";
  imports = [inputs.flake-file.flakeModules.default];
  flake-file.outputs = ''
    inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ (inputs.import-tree ./modules) ];
    }
  '';
}
