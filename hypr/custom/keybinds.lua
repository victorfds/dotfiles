hl.bind("CTRL+SUPER+ALT+Slash", hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.lua"), {description = "Edit user keybinds"} )

-- Screenshots: upstream Print bind only copies to clipboard, and some boards
-- (Razer) emit SysRq / keycode 107 instead of Print. Replace with grimblast.
local shot = os.getenv("HOME") .. "/.config/hypr/custom/scripts/screenshot.sh"
hl.unbind("Print")
hl.unbind("CTRL + Print")
hl.unbind("SUPER + SHIFT + S")
hl.bind("Print", hl.dsp.exec_cmd("bash " .. shot .. " full"), {
  locked = true,
  description = "Utilities: Screenshot output >> clipboard & file",
})
hl.bind("code:107", hl.dsp.exec_cmd("bash " .. shot .. " full"), { locked = true })
hl.bind("CTRL + Print", hl.dsp.exec_cmd("bash " .. shot .. " full"), {
  locked = true,
  description = "Utilities: Screenshot output >> clipboard & file",
})
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("bash " .. shot .. " area"), {
  locked = true,
  description = "Utilities: Screen snip >> clipboard & file",
})
hl.bind("SUPER + Print", hl.dsp.exec_cmd("bash " .. shot .. " area"), { locked = true })

