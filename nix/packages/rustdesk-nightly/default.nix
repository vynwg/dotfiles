with import <nixpkgs> { config.allowUnfree = true; };

rustPlatform.buildRustPackage rec {
  pname = "rustdesk";
  version = "d8cf18e";

  src = fetchFromGitHub {
    owner = "rustdesk";
    repo = "rustdesk";
    rev = version;
    sha256 = "sha256-apLK1O60EbN84w67qCAaPVrJ7/N+yqDuksRPQYqYwlA=";
  };

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "confy-0.4.0-2" = "sha256-vHdXdJlAK7l+Gsp7W2/OpJz9KKD9PYx6AGONDuqtsZw=";
      "evdev-0.11.5" = "sha256-aoPmjGi/PftnH6ClEWXHvIj0X3oh15ZC1q7wPC1XPr0=";
      "hwcodec-0.1.0" = "sha256-u/+J2dVSHmvYSp2cd2y5rW5gWTf6JhIjvxh2xS9x01A=";
      "impersonate_system-0.1.0" = "sha256-qbaTw9gxMKDjX5pKdUrKlmIxCxWwb99YuWPDvD2A3kY=";
      "keepawake-0.4.3" = "sha256-1zui2955rYzYAtKrs7pTJf0ETJGKvf8zNvcg0SCZk8Q=";
      "magnum-opus-0.4.0" = "sha256-U5uuN4YolOYDnFNbtPpwYefcBDTUUyioui0UCcW8dyo=";
      "mouce-0.2.1" = "sha256-3PtNEmVMXgqKV4r3KiKTkk4oyCt4BKynniJREE+RyFk=";
      "pam-0.7.0" = "sha256-qe2GH6sfGEUnqLiQucYLB5rD/GyAaVtm9pAxWRb1H3Q=";
      "parity-tokio-ipc-0.7.3-2" = "sha256-WXDKcDBaJuq4K9gjzOKMozePOFiVX0EqYAFamAz/Yvw=";
      "rdev-0.5.0-2" = "sha256-O1d3klGVnXhzb5rj2sH9u+z+iPmqVqkaHdxYiMiD+GA=";
      "rust-pulsectl-0.2.12" = "sha256-8jXTspWvjONFcvw9/Z8C43g4BuGZ3rsG32tvLMQbtbM=";
      "sciter-rs-0.5.57" = "sha256-ZZnZDhMjK0LjgmK0da1yvB0uoKueLhhhQtzmjoN+1R0=";
      "tao-0.19.1" = "sha256-Rnj4JC3u7avB9mvpRZMO9iq7Icb2HsGdQg3ZRYhsC08=";
      "tfc-0.6.1" = "sha256-ukxJl7Z+pUXCjvTsG5Q0RiXocPERWGsnAyh3SIWm0HU=";
      "tokio-socks-0.5.1-2" = "sha256-x3aFJKo0XLaCGkZLtG9GYA+A/cGGedVZ8gOztWiYVUY=";
      "tray-icon-0.5.1" = "sha256-1VyUg8V4omgdRIYyXhfn8kUvhV5ef6D2cr2Djz2uQyc=";
      "x11-2.19.0" = "sha256-GDCeKzUtvaLeBDmPQdyr499EjEfT6y4diBMzZVEptzc=";
    };
  };

  # Change magnus-opus version to upstream so that it does not use
  # vcpkg for libopus since it does not work.
  cargoPatches = [
    ./cargo.patch
  ];

  # Manually simulate a vcpkg installation so that it can link the libaries
  # properly.
  postUnpack =
    let
      vcpkg_target = "x64-linux";

      updates_vcpkg_file = writeText "update_vcpkg_rustdesk"
        ''
          Package : libyuv
          Architecture : ${vcpkg_target}
          Version : 1787
          Status : is installed

          Package : libvpx
          Architecture : ${vcpkg_target}
          Version : 8.0.0
          Status : is installed

          Package : libaom
          Architecture : ${vcpkg_target}
          Version : 3.6.0
          Status : is installed
        '';
    in
    ''
      export VCPKG_ROOT="$TMP/vcpkg";

      mkdir -p $VCPKG_ROOT/.vcpkg-root
      mkdir -p $VCPKG_ROOT/installed/${vcpkg_target}/lib
      mkdir -p $VCPKG_ROOT/installed/vcpkg/updates
      ln -s ${updates_vcpkg_file} $VCPKG_ROOT/installed/vcpkg/status
      mkdir -p $VCPKG_ROOT/installed/vcpkg/info
      touch $VCPKG_ROOT/installed/vcpkg/info/libyuv_1787_${vcpkg_target}.list
      touch $VCPKG_ROOT/installed/vcpkg/info/libvpx_8.0.0_${vcpkg_target}.list
      touch $VCPKG_ROOT/installed/vcpkg/info/libaom_3.6.0_${vcpkg_target}.list

      ln -s ${libvpx.out}/lib/* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
      ln -s ${libyuv.out}/lib/* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
      ln -s ${(import ../libaom).out}/lib/* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
    '';
    

  nativeBuildInputs = [ pkg-config cmake makeWrapper copyDesktopItems yasm nasm clang wrapGAppsHook ];
  buildInputs = [ (import ../libaom) ] ++ [ libxkbcommon alsa-lib pulseaudio xorg.libXfixes xorg.libxcb xdotool gtk3 libvpx libopus xorg.libXtst libyuv gst_all_1.gstreamer gst_all_1.gst-plugins-good gst_all_1.gst-plugins-base ];

  # Checks require an active X display.
  doCheck = false;

  desktopItems = [
    (makeDesktopItem {
      name = "rustdesk";
      exec = meta.mainProgram;
      icon = "rustdesk";
      desktopName = "RustDesk";
      comment = meta.description;
      genericName = "Remote Desktop";
      categories = [ "Network" ];
    })
  ];

  postPatch = ''
    rm Cargo.lock
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  # Add static ui resources and libsciter to same folder as binary so that it
  # can find them.
  postInstall = ''
    mkdir -p $out/{share/src,lib/rustdesk}

    # so needs to be next to the executable
    mv $out/bin/rustdesk $out/lib/rustdesk
    ln -s ${libsciter}/lib/libsciter-gtk.so $out/lib/rustdesk

    makeWrapper $out/lib/rustdesk/rustdesk $out/bin/rustdesk \
      --chdir "$out/share"

    cp -a $src/src/ui $out/share/src

    install -Dm0644 $src/res/logo.svg $out/share/icons/hicolor/scalable/apps/rustdesk.svg
  '';

  meta = with lib; {
    description = "Yet another remote desktop software";
    homepage = "https://rustdesk.com";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "rustdesk";
  };
}
