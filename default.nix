{
  lib,
  stdenv,
}:

stdenv.mkDerivation {
  name = "flake-start";

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cat >"$out/bin/flake-start" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
echo "Hello from flake-start"
EOF
    chmod +x "$out/bin/flake-start"

    runHook postInstall
  '';

  meta.mainProgram = "flake-start";
}
