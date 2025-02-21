{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  python3,
  runCommand,
  wprs,
}:
rustPlatform.buildRustPackage {
  pname = "wprs";
  version = "0-unstable-2025-02-06";

  src = fetchFromGitHub {
    owner = "wayland-transpositor";
    repo = "wprs";
    rev = "7095d5e4ee663fe7b930c197ede886791c27a943";
    hash = "sha256-E7k93LqYOLb17IA7o3qXiFcFeknyOk+71lBtHNZ/Z2M=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxkbcommon
    (python3.withPackages (pp: with pp; [ psutil ]))
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;

    outputHashes = {
      "smithay-0.3.0" = "sha256-dA4jXU82FNbo8X5Hp56GIB7y+r1Ug1Kb8aaEs/K2L0E=";
      "smithay-client-toolkit-0.19.2" = "sha256-wwfX5zJis8CwtJA9YjFKLQvb8pPwU+QP9zrvz/Jasls=";
    };
  };

  preFixup = ''
    cp  wprs "$out/bin/wprs"
  '';

  passthru.tests.sanity = runCommand "wprs-sanity" { nativeBuildInputs = [ wprs ]; } ''
    ${wprs}/bin/wprs -h > /dev/null && touch $out
  '';

  meta = with lib; {
    description = "rootless remote desktop access for remote Wayland";
    license = licenses.asl20;
    maintainers = with maintainers; [ mksafavi ];
    platforms = [ "x86_64-linux" ]; # The aarch64-linux support is not implemented in upstream yet. Also, the darwin platform is not supported as it requires wayland.
    homepage = "https://github.com/wayland-transpositor/wprs";
    mainProgram = "wprs";
  };
}
