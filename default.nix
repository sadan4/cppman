{stdenv}: stdenv.mkDerivation (finalAttrs: {
    pname = "cppman-pages";
    version = "0.0.1";
    src = ./cache/cppreference.com;
    installPhase = ''
        runHook preInstall

        mkdir -p $out/bin
        mkdir -p $out/share/man/man3

        cp ./* $out/share/man/man3
    '';
})
