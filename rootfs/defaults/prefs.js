// Default download directory
user_pref("browser.download.dir", "/config/downloads");
user_pref("browser.download.folderList", 2);

// Disable the privacy notice page.
user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);

// Turn off unused features
user_pref("extensions.pocket.enabled", false);
user_pref("extensions.screenshots.disabled", true);
user_pref("identity.fxaccounts.enabled", false);

// Reduce memory usage
user_pref("browser.sessionhistory.max_total_viewers", 0);
user_pref("browser.newtab.preload", false);
user_pref("dom.ipc.processPrelaunch.enabled", false);
user_pref("browser.cache.memory.enable", false);