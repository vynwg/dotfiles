self: super: {
   ciscoPacketTracer8 = self.ciscoPacketTracer8.overrideAttrs(e: rec {
        desktopItem = e.desktopItem.override (d: {
            exec = "QT_PLUGIN_PATH="" ${d.exec} --no-sandbox";
        });

        installPhase = builtins.replaceStrings [ "${e.desktopItem}" ] [ "${desktopItem}" ] e.installPhase;
   });
}

