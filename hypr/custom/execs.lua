-- kded6 registers StatusNotifierWatcher and fights Quickshell's tray.
-- Keep the kded package (needed by plasma-nm / xdg-desktop-portal-kde) but
-- do not let the daemon run in this Hyprland session.
hl.on("hyprland.start", function()
	hl.exec_cmd("killall -q kded6 kded5 xembedsniproxy gmenudbusmenuproxy plasmashell nm-applet || true")
end)
