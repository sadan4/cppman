{
  stdenv,
  rename,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cppman-pages";
  version = "0.0.1";
  nativeBuildInputs = [
    rename
  ];
  src = ./cache/cppreference.com;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/man/man3

    cp ./* $out/share/man/man3
    # only link instead of hard rename
    # Lib keywords
    rename -l 's/C\+\+ keyword: (\w+)\.(.*?)$/cpp_kw_$1.$2/' $out/share/man/man3/*
    # headers
    rename -l 's/(?:Standard|Experimental) library header (<\w+>)\.(.*?)$/$1.$2/' $out/share/man/man3/*
  '';
})
