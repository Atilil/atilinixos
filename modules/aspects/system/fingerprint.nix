_: {
  den.aspects.fingerprint = {
    os = _: {
      services.fprintd.enable = true;
      security.pam.services.login.fprintAuth = false;
    };
  };
}
