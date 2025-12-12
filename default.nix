{
	stdenv,
	rename,
	lib,
}: let
	types' = [
		"inplace_vector"
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
		"extents"
		#strings
		"basic_string"
		"basic_string_view"

		"initializer_list"

		#numeric
		"numeric_limits"
		#<random>
		# engines and distributions, too many to name
		"[a-z_]+?_engine"
		"[a-z_]+?_distribution"

		"coroutine_handle"

		"generator"

		"pair"

		"tuple"

		"optional"

		"expected"

		"variant"

		"basic_stacktrace"

		"complex"

		"codecvt"

		"layout_left::mapping"
		"layout_right::mapping"
		"layout_stride::mapping"

		"bitset"
		# <functional>
		"function"
		"reference_wrapper"
		# <regex>
		"basic_regex"
		"sub_match"
		"match_results"
		"regex_traits"
		"regex_iterator"
		"regex_token_iterator"
		# concurrency
		"atomic_ref"
		"unique_lock"
		"scoped_lock"
		"lock_guard"
		"shared_lock"
		"counting_semaphore"
		"barrier"
		# <future>
		"promise"
		"packaged_task"
		"future"
		"shared_future"
		# memory related
		"shared_ptr"
		"unique_ptr"
		"weak_ptr"
		"auto_ptr"
		"enable_shared_from_this"
		"inout_ptr_t"
		"out_ptr_t"
		"allocator"
		"allocator_traits"
		"scoped_allocator_adaptor"
		"polymorphic_allocator"
		"indirect"
		"polymorphic"
		"pointer_traits"
		"raw_storage_iterator"
		# <ranges>
		"ranges::view_interface"
		"ranges::subrange"
		# too many to name
		"ranges::[a-z_]+?_view"
		#<locale>
		"num_get"
		"num_put"
		"numpunct"
		"collate"
		"time_get"
		"time_put"
		"money_get"
		"money_put"
		"moneypunct"
		"messages"
		"wbuffer_convert"
		"wstring_convert"
		#streams
		"basic_ios"
		"basic_streambuf"
		"basic_[io]stream"
		"basic_iostream"
		"basic_filebuf"
		"basic_[io]?fstream"
		"basic_stringbuf"
		"basic_[io]?stringstream"
		"basic_spanbuf"
		"basic_[io]?spanstream"
		"basic_syncbuf"
		"basic_osyncstream"
		"fpos"
		#<iterator>
		"[io]stream(?:buf)?_iterator"
		"reverse_iterator"
		"move_iterator"
		"insert_iterator"
		"front_insert_iterator"
		"counted_iterator"
		"common_iterator"
		"basic_const_iterator"
		"back_insert_iterator"
		"move_sentinel"
		# only experimental
		"unique_resource"
		"simd"
		"simd_mask"
		"scope_fail"
		"scope_exit"
		"scope_success"
		"ranges::tagged"
		"propagate_const"
		"atomic_shared_ptr"
		"atomic_weak_ptr"
		"observer_ptr"
		"ostream_joiner"
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
		basic_regex = [
			"regex"
			"wregex"
		];
		sub_match = [
			"csub_match"
			"wcsub_match"
			"ssub_match"
			"wssub_match"
		];
		match_results = [
			"cmatch"
			"wcmatch"
			"smatch"
			"wsmatch"
		];
		regex_iterator = [
			"cregex_iterator"
			"wcregex_iterator"
			"sregex_iterator"
			"wsregex_iterator"
		];
		regex_token_iterator = [
			"cregex_token_iterator"
			"wcregex_token_iterator"
			"sregex_token_iterator"
			"wsregex_token_iterator"
		];
		basic_ios = [
			"ios"
			"wios"
		];
		basic_streambuf = [
			"streambuf"
			"wstreambuf"
		];
		basic_istream = [
			"istream"
			"wistream"
		];
		basic_iostream = [
			"iostream"
			"wiostream"
		];
		basic_ostream = [
			"ostream"
			"wostream"
		];
		basic_filebuf = [
			"filebuf"
			"wfilebuf"
		];
		basic_ifstream = [
			"ifstream"
			"wifstream"
		];
		basic_ofstream = [
			"ofstream"
			"wofstream"
		];
		basic_fstream = [
			"fstream"
			"wfstream"
		];
		basic_stringbuf = [
			"stringbuf"
			"wstringbuf"
		];
		basic_istringstream = [
			"istringstream"
			"wistringstream"
		];
		basic_ostringstream = [
			"ostringstream"
			"wostringstream"
		];
		basic_stringstream = [
			"stringstream"
			"wstringstream"
		];
		basic_spanbuf = [
			"spanbuf"
			"wspanbuf"
		];
		basic_ispanstream = [
			"ispanstream"
			"wispanstream"
		];
		basic_ospanstream = [
			"ospanstream"
			"wospanstream"
		];
		basic_spanstream = [
			"spanstream"
			"wspanstream"
		];
		basic_syncbuf = [
			"syncbuf"
			"wsyncbuf"
		];
		basic_osyncstream = [
			"osyncstream"
			"wosyncstream"
		];
		fpos = [
			"streampos"
			"wstreampos"
			"u8streampos"
			"u16streampos"
			"u32streampos"
		];
	};
	# TODO: there are a lot of range adaptors under ranges::views::xxx(drop_view), link those?
	# TODO: add entries for predefined rng engines?
	types = lib.strings.concatStringsSep "|" types';
	NBSP = " ";
	# rename does not support the unicode flag, which is needed for PCRE to match NBSP with `\h`
	s = "(?:${NBSP}|\s)";
	p = "$out/share/man/man3/";
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
                rename 's/C\+\+ keyword: (\w+)\.(.*?)$/cpp_kw_$1.$2/' ${p}*
                # headers
                rename 's/(?:Standard|Experimental) library header (<\w+>)\.(.*?)$/$1.$2/' ${p}*
                # TODO: rename deduction guides to not have spaces
                # headers with a version eg <unordered_map><NBSP>(C++11)
                # TODO: handle headers with more than one version eg: <codecvt><NBSP>(C++11)(deprecated in C++17)
                # for some ungodly reason, they have NBSP's (probably a remanant from the scrape)
                rename 's/(?:Standard|Experimental) library header (<\w+>)${s}*?\(C\+\+(\d{2})\)\.(.*?)$/$1(c++$2).$3/' ${p}*
                # TODO: some member pairs (eg: begin, cbegin) are written like this `std::foo<T>::begin(), std::foo<T>::cbegin()`
                # separate them into separate files
                # remove templates
                rename 's/(std::(?:experimental::)?(?:pmr::)?(?:${types}))<[^<]*?>(.*)/$1$2/' ${p}*
				# second pass for range iterator types
				rename 's/(std::ranges::[a-z_]+?_view::(?:iterator|sentinel))<Const>(.*)/$1$2/' ${p}*
                # std::vector<bool> has separate docs and is a special case
                rename 's/(std::vector)<(?!bool)[^<]*?>(.*)/$1$2/' ${p}*
                # we still want to remove the Allocator template arg tho
                rename 's/(std::vector<bool),Allocator(>.*)/$1$2/' ${p}*
				# owner_less<void> specialization
				rename 's/(std::owner_less) \(owner_less.html\)(.3.gz)/$1$2/' ${p}*
				rename 's/(std::owner_less) \(owner_less_void.html\)(.3.gz)/$1<void>$2/' ${p}*
				# atomic specialization
                rename 's/(std::atomic)<T>(.*)/$1$2/' ${p}*
				# ctype specialization
                rename 's/(std::ctype)<CharT>(.*)/$1$2/' ${p}*
				# swap and move were moved to <utility>
				rm "${p}/std::swap (algorithm).3.gz"
				rm "${p}/std::move (algorithm).3.gz"
				rename 's/(std::(?:swap|move)) \(utility\)(.3.gz)/$1$2/' ${p}*
				rename 's/(std::swap)\((std::.*?)\)(.3.gz)/$1<$2>$3/' ${p}*
                # std::to_string
                rename 's/(?<=std::to_string) \(string_basic_string\)(?=\.3\.gz)//' ${p}*
                rename 's/(?<=std::to_string) \([a-z]+?_([a-z_]+?)\)(?=\.3\.gz)/<std::$1>/' ${p}*

				# std::isspace(std::locale) std::toupper(std::locale) etc...
				rename 's/(std::[^<>:()]+)\((std::.*?)\)(.3.gz)/$1<$2>$3/' ${p}*
                # std::hash<Key>
                rename 's/(std::hash)<Key>(.*)/$1$2/' ${p}*
                # some of the std::hash funcs have a space after them, idk why
                rename 's/(?<=std::hash) //' ${p}*
			'';
		})
