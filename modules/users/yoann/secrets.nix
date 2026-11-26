_: {
  # User secrets (API tokens); yoann_password lives in sops.nix (neededForUsers)
  den.aspects.yoann.provides.to-hosts.os = _: let
    mkUserSecret = _: {
      sopsFile = ./sops/secrets.yaml;
      owner = "yoann";
      mode = "0400";
    };
  in {
    sops.secrets = {
      github_token_yoann = mkUserSecret "github_token_yoann";
      github_classic_token_yoann = mkUserSecret "github_classic_token_yoann";
      codestral_api_key_yoann = mkUserSecret "codestral_api_key_yoann";
    };
  };
}
