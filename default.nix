{
  stdenv,
  rename,
  lib,
}:
let
  types' = [
    # containers
    "array"
    "gslice_array"
    "indirect_array"
    "mask_array"
    "slice_array"
    "valarray"
    "deque"
    "list"
    "forward_list"
    "set"
    "map"
    "multiset"
    "multimap"
    "unordered_set"
    "unordered_map"
    "unordered_multiset"
    "unordered_multimap"
    "flat_set"
    "flat_map"
    "flat_multiset"
    "flat_multimap"
    "stack"
    "queue"
    "priority_queue"
    "span"
    "mdspan"
    #not really a collection, but close enough
    "initializer_list"
    #strings
    "basic_string"
    "basic_string_view"
    # "queue"
    # "tuple"
    # "sub_match"
    # "stack"
    # "span"
    # "scoped_lock"
    # "list"
    # "unique_lock"
    # "shared_lock"
    # smart pointers
    "shared_ptr"
    "unique_ptr"
    "weak_ptr"
    "auto_ptr"
    "(?:experimental::)?atomic_weak_ptr"
    "(?:experimental::)?atomic_shared_ptr"
    "(?:experimental::)?observer_ptr"
    "(?:experimental::)?shared_ptr"
    "(?:experimental::)?weak_ptr"
    "inout_ptr_t"
    "out_ptr_t"
  ];
  # TODO: use this info
  typedefs = {
    basic_string = [
      "string"
      "wstring"
      "u8string"
      "u16string"
      "u32string"
    ];
    basic_string_view = [
      "string_view"
      "wstring_view"
      "u8string_view"
      "u16string_view"
      "u32string_view"
    ];
  };
  types = lib.strings.concatStringsSep "|" types';
  NBSP = " ";
  # rename does not support the unicode flag, which is needed for PCRE to match NBSP with `\h`
  s = "(?:${NBSP}|\s)";
in
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
    # TODO: rename deduction guides to not have spaces
    # headers with a version eg <unordered_map><NBSP>(C++11)
    # TODO: handle headers with more than one version eg: <codecvt><NBSP>(C++11)(deprecated in C++17)
    # for some ungodly reason, they have NBSP's (probably a remanant from the scrape)
    rename 's/(?:Standard|Experimental) library header (<\w+>)${s}*?\(C\+\+(\d{2})\)\.(.*?)$/$1(c++$2).$3/' $out/share/man/man3/*
    # TODO: some member pairs (eg: begin, cbegin) are written like this `std::foo<T>::begin(), std::foo<T>::cbegin()`
    # separate them into separate files
    # remove templates
    rename 's/(std::${types})<[^<]*?>(.*)/$1$2/' $out/share/man/man3/*
    # std::vector<bool> has separate docs and is a special case
    rename 's/(std::vector)<(?!bool)[^<]*?>(.*)/$1$2/' $out/share/man/man3/*
    # we still want to remove the Allocator template arg tho
    rename 's/(std::vector<bool),Allocator(>.*)/$1$2/' $out/share/man/man3/*
  '';
})
