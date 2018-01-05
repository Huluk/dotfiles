--- === PomodoroTimer ===
---
--- Adds a pomodoro timer to the menu bar, defaulting to 25 minutes.
--- After the end of the runtime, flashes the screen.
---

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "PomodoroTimer"
obj.version = "0.1"
obj.author = "Lars Hansen <LarsHuluk@gmail.com>"
obj.homepage = "https://github.com/Huluk/hammerspoon-pomodoro-timer" -- TODO create
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.pomodoro = hs.menubar.new()
obj.startTime = false
obj.defaultDuration = 25*60 -- seconds
obj.duration = defaultDuration
-- https://en.wikipedia.org/wiki/Web_colors#X11_color_names in lowercase
obj.flashColor = "chartreuse"
obj.flashAlpha = 0.5
obj.flashDuration = 0.4

local function timeFormat(time)
  return string.format(
    "%s:%02s",
    tostring(math.floor(time / 60)),
    tostring(math.floor(time % 60)))
end

local function flashScreen(frame)
  local flash = hs.drawing.rectangle(frame)
  flash:setFillColor(hs.drawing.color.lists()["x11"][obj.flashColor])
  flash:setAlpha(obj.flashAlpha)
  flash:show()
  flash:hide(obj.flashDuration)
  hs.timer.doAfter(obj.flashDuration, function() flash:delete() end)
end

local function flashScreens(n)
  for _,screen in pairs(hs.screen.allScreens()) do
    flashScreen(screen:frame())
  end
  if n > 1 then
    hs.timer.doAfter(obj.flashDuration, function() flashScreens(n - 1) end)
  end
end

local function endPomo()
  flashScreens(3)
  obj:toggleOff()
end

local function updateDisplay()
  if obj.startTime then
    local runTime = hs.timer.secondsSinceEpoch() - obj.startTime
    local timeRemaining = math.max(0, obj.duration - runTime)
    obj.pomodoro:setTitle(timeFormat(timeRemaining))
    if runTime >= obj.duration then
      endPomo()
    else
      hs.timer.doAfter(1, updateDisplay)
    end
  end
end

function obj:toggle()
  if self.startTime then
    self:toggleOff()
  else
    self:toggleOn()
  end
end

function obj:toggleOn()
  self.startTime = hs.timer.secondsSinceEpoch()
  updateDisplay()
end

function obj:toggleOff()
  self.startTime = false
  self.duration = self.defaultDuration
  self.pomodoro:setTitle(timeFormat(self.duration))
end

function obj:registerUrlListener(name)
  hs.urlevent.bind(name, function(eventName, params)
    if params["duration"] then
      obj.duration = params["duration"] * 60
      obj:toggleOn()
    else
      obj:toggle()
    end
  end)
end

function obj:init()
  self:toggleOff()
  self.pomodoro:setClickCallback(function() self:toggle() end)
  self:registerUrlListener("pomodoro")
end

return obj
