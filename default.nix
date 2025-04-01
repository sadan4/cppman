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
    # Lib keywords
    rename 's/C\+\+ keyword: (\w+)\.(.*?)$/cpp_kw_$1.$2/' $out/share/man/man3/*
    # headers
    rename 's/(?:Standard|Experimental) library header (<\w+>)\.(.*?)$/$1.$2/' $out/share/man/man3/*
    # remove templates
    rename 's/(std::(?:(?:unordered_)?(?:multi)?(?:map|set)|vector|list|unique_lock|unique_ptr|shared_ptr|shared_lock))<.*?>(.*)/$1$2/' $out/share/man/man3/*
  '';
})
