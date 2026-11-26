{inputs, ...}: {
  # renovate: datasource=github-tags depName=denful/den
  flake-file.inputs.den.url = "github:denful/den/v0.20.0";
  imports = [(inputs.den.flakeModule or {})];
}
