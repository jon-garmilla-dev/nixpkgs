{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "arity";
  version = "0.32.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jolars";
    repo = "arity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-94xRf0VDEs7UL/acsksDiMB+bbCxSLn4TvIXIEyqHE4=";
  };

  cargoHash = "sha256-5VNG0lo74PaMW4acNQH9fzLX71VlXDB57gMrBAGcxOQ=";

  nativeBuildInputs = [
    installShellFiles
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  postInstall = ''
    installShellCompletion --cmd arity \
      --bash target/completions/arity.bash \
      --fish target/completions/arity.fish \
      --zsh target/completions/_arity

    installManPage target/man/*
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server, formatter, and linter for R";
    homepage = "https://arity.cc";
    changelog = "https://github.com/jolars/arity/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jolars ];
    mainProgram = "arity";
  };
})
