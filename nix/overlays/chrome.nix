self: super: {
   google-chrome = super.google-chrome.override {
     commandLineArgs =
       "--enable-features=WebUIDarkMode --force-dark-mode --force-device-scale-factor=1";
   };
}
