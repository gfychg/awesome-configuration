-- default is located in /etc/xdg/awesome
-- Setup display
local xrandr = {
   naruto = "--output VGA1 --auto --output DVI1 --auto --left-of VGA1",
   Everest = "--output VGA1 --mode 1280x720",
   neo    = "--output HDMI-0 --auto --output DVI-0 --auto --right-of HDMI-0",
   fermi    = "--output HDMI1 --auto --right-of VGA1",
   alucard = "--output DVI-0 --auto --primary --output DisplayPort-0 --auto --right-of DVI-0"
}
if xrandr[config.hostname] then
   os.execute("xrandr " .. xrandr[config.hostname])
end

-- Spawn a composoting manager
awful.util.spawn("xcompmgr", false)

-- Start idempotent commands
local execute = {
   -- Start PulseAudio
   "pulseaudio --check || pulseaudio -D",
   "xset -b",	-- Disable bell
   -- Enable numlock
   "numlockx on",
   -- Read resources
   "xrdb -merge " .. awful.util.getdir("config") .. "/Xresources",
   -- Default browser
   "xdg-mime default " .. config.browser .. ".desktop x-scheme-handler/http",
   "xdg-mime default " .. config.browser .. ".desktop x-scheme-handler/https",
   "xdg-mime default " .. config.browser .. ".desktop text/html",
   -- Default reader for PDF. See: https://wiki.archlinux.org/index.php/Default_Applications
   "xdg-mime default evince.desktop application/pdf"
}

-- Keyboard/Mouse configuration
if config.hostname == "Everest" then
   execute = awful.util.table.join(
      execute, {
	 -- Keyboard and mouse
	 -- "xset m 3 3",	-- Mouse acceleration
	 "setxkbmap us,fr '' ctrl:nocaps grp:rctrl_rshift_toggle",
	 "xmodmap -e 'keysym Pause = XF86ScreenSaver'",
	       })
elseif config.hostname == "fermi" then
   execute = awful.util.table.join(
      execute, {
	 -- Keyboard and mouse
	 -- "xset m 3 3",	-- Mouse acceleration
	 "setxkbmap us,fr,cz '' ctrl:nocaps grp:rctrl_rshift_toggle",
	 "xmodmap -e 'keysym Pause = XF86ScreenSaver'",
	       })
elseif config.hostname == "puydedome" then
   execute = awful.util.table.join(
      execute, {
	 -- Keyboard and mouse
	 -- "xset m 3 3",	-- Mouse acceleration
	 "setxkbmap us,fr '' ctrl:nocaps grp:rctrl_rshift_toggle",
	 "xmodmap -e 'keysym Pause = XF86ScreenSaver'",
	       })
end

os.execute(table.concat(execute, ";"))

-- Spawn various X programs
xrun("polkit-gnome-authentication-agent-1",
     "/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1")
xrun("pidgin", "pidgin -n")
xrun("u1sdtool", "u1sdtool --start")

-- Load Debian menu entries
require("debian.menu")

terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Debian", debian.menu.Debian_menu.Debian },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}
