hs.loadSpoon("PomodoroTimer")
spoon.PomodoroTimer:init()

menu = hs.menubar.new()
postal = hs.image.imageFromPath('postal.pdf'):setSize({w=16,h=16})
postal_red = hs.image.imageFromPath('postal_red.pdf'):setSize({w=16,h=16})
menu:setIcon(postal, true)


-- redshift
redshiftWindowFilter = hs.window.filter.new({
  VLC={focused=true},
  Photos={focused=true},
  Skype={focused=true}, -- TODO fullscreen detection?
}, 'wf-redshift')
function enableRedshift()
  -- light temperature in K, midEvening, midMorning, transition, invertColor
  hs.redshift.start(2700, "21:30", "7:30",  "3h", false, redshiftWindowFilter)
  redshiftMode.checked = true
  redshiftMode.fn = disableRedshift
  menu:setMenu(menuState)
end
function disableRedshift()
  hs.redshift.stop()
  redshiftMode.checked = false
  redshiftMode.fn = enableRedshift
  menu:setMenu(menuState)
end
redshiftMode =
  { title = "Redshift", checked = false, fn = enableRedshift }

-- darkroom
-- TODO change solarized preset for iterm
function enableDarkroom()
  hs.redshift.stop()
  hs.redshift.start(1000,"0:01","0:00",0,true)
  hs.osascript.applescript([[
    tell application "System Events"
      tell appearance preferences
        set dark mode to false
      end tell
    end tell
  ]])
  darkroomMode.checked = true
  darkroomMode.fn = disableDarkroom
  menu:setMenu(menuState)
end
function disableDarkroom()
  hs.redshift.stop()
  if redshiftMode.checked then
    enableRedshift()
  end
  -- TODO reset instead
  hs.osascript.applescript([[
    tell application "System Events"
      tell appearance preferences
        set dark mode to false
      end tell
    end tell
  ]])
  darkroomMode.checked = false
  darkroomMode.fn = enableDarkroom
  menu:setMenu(menuState)
end
darkroomMode =
  { title = "Darkroom", checked = false, fn = enableDarkroom }

-- PomodoroTimer menu item
spoon.PomodoroTimer.display:removeFromMenuBar() -- todo save state
function togglePomodoro()
  if pomodoroState.checked then
    spoon.PomodoroTimer:toggleOff()
    spoon.PomodoroTimer.display:removeFromMenuBar()
  else
    spoon.PomodoroTimer.display:returnToMenuBar()
  end
  pomodoroState.checked = not pomodoroState.checked
  menu:setMenu(menuState)
end
pomodoroState =
  { title = "Pomodoro Timer", checked = false, fn = togglePomodoro }

-- Travel Mode, disable everything which sends a lot of data (but not mail)
dataIntensiveApps = { Dropbox=1, Tresorit=1, Skype=1, Telegram=1 }
function turnAppOff(name)
  local app = hs.application.get(name)
  if app then
    app:kill()
  end
end
function toggleTravelMode()
  local fn = nil
  if travelMode.checked then
    fn = function(name) hs.application.open(name) end
    local function watch(appName, eventType, appObject)
      if dataIntensiveApps[appName] then
        appObject:hide()
      end
    end
    local appWatcher = hs.application.watcher.new(watch)
    appWatcher:start()
    hs.timer.doAfter(3, function() appWatcher:stop() end)
    menu:setIcon(postal, true)
  else
    fn = turnAppOff
    menu:setIcon(postal_red, false)
  end
  for app,_ in pairs(dataIntensiveApps) do
    fn(app)
  end
  travelMode.checked = not travelMode.checked
  menu:setMenu(menuState)
end
travelMode =
  { title = "Travel Mode", checked = false, fn = toggleTravelMode }


menuState = {
  pomodoroState,
  { title = '-' },
  travelMode,
  { title = '-' },
  redshiftMode,
  darkroomMode,
}
menu:setMenu(menuState)
