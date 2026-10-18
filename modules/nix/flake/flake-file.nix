{inputs, ...}: {
  flake-file.inputs.flake-file.url = "github:vic/flake-file";
  imports = [inputs.flake-file.flakeModules.default];
  flake-file.outputs = ''
    inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ (inputs.import-tree ./modules) ];
    }
  '';
}
