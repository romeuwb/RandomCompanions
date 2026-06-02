-- LibDBIcon-1.0 (minimal embedded version for minimap buttons)
-- Based on LibDBIcon by Rabbit - License: Ace3 Style BSD

local DBICON_MAJOR, DBICON_MINOR = "LibDBIcon-1.0", 46
local lib = LibStub:NewLibrary(DBICON_MAJOR, DBICON_MINOR)
if not lib then return end

lib.objects = lib.objects or {}
lib.callbackRegistered = lib.callbackRegistered or {}
lib.callbacks = lib.callbacks or LibStub("CallbackHandler-1.0"):New(lib)
lib.notCreated = lib.notCreated or {}

local minimapShapes = {
    ["ROUND"] = {true, true, true, true},
    ["SQUARE"] = {false, false, false, false},
    ["CORNER-TOPLEFT"] = {false, false, false, true},
    ["CORNER-TOPRIGHT"] = {false, false, true, false},
    ["CORNER-BOTTOMLEFT"] = {false, true, false, false},
    ["CORNER-BOTTOMRIGHT"] = {true, false, false, false},
    ["SIDE-LEFT"] = {false, true, false, true},
    ["SIDE-RIGHT"] = {true, false, true, false},
    ["SIDE-TOP"] = {false, false, true, true},
    ["SIDE-BOTTOM"] = {true, true, false, false},
    ["TRICORNER-TOPLEFT"] = {false, true, true, true},
    ["TRICORNER-TOPRIGHT"] = {true, false, true, true},
    ["TRICORNER-BOTTOMLEFT"] = {true, true, false, true},
    ["TRICORNER-BOTTOMRIGHT"] = {true, true, true, false},
}

local function getMinimapShape()
    return GetMinimapShape and GetMinimapShape() or "ROUND"
end

local function updatePosition(button, db)
    local angle = math.rad(db.minimapPos or 220)
    local x, y, q = math.cos(angle), math.sin(angle), 1
    if x < 0 then q = q + 1 end
    if y > 0 then q = q + 2 end
    local minimapShape = minimapShapes[getMinimapShape()]
    if minimapShape and minimapShape[q] then
        x = x * 80
        y = y * 80
    else
        local diagRadius = 103.13708
        x = math.max(-80, math.min(x * diagRadius, 80))
        y = math.max(-80, math.min(y * diagRadius, 80))
    end
    button:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

local function onDragStart(self)
    self:LockHighlight()
    self.isMouseDown = true
    self:SetScript("OnUpdate", function(self)
        local mx, my = Minimap:GetCenter()
        local px, py = GetCursorPosition()
        local scale = Minimap:GetEffectiveScale()
        px, py = px / scale, py / scale
        local angle = math.deg(math.atan2(py - my, px - mx)) % 360
        self.db.minimapPos = angle
        updatePosition(self, self.db)
    end)
end

local function onDragStop(self)
    self:SetScript("OnUpdate", nil)
    self.isMouseDown = false
    self:UnlockHighlight()
end

local function onClick(self, button)
    local obj = self.dataObject
    if obj.OnClick then
        obj.OnClick(obj, self, button)
    end
end

local function onEnter(self)
    if self.isMouseDown then return end
    local obj = self.dataObject
    if obj.OnTooltipShow then
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        obj.OnTooltipShow(GameTooltip)
        GameTooltip:Show()
    elseif obj.OnEnter then
        obj.OnEnter(self)
    end
end

local function onLeave(self)
    GameTooltip:Hide()
    local obj = self.dataObject
    if obj.OnLeave then
        obj.OnLeave(self)
    end
end

local function createButton(name, obj, db)
    local button = CreateFrame("Button", "LibDBIcon10_" .. name, Minimap)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(8)
    button:SetSize(32, 32)
    button:SetMovable(true)
    button:SetClampedToScreen(true)
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:RegisterForDrag("LeftButton")

    local overlay = button:CreateTexture(nil, "OVERLAY")
    overlay:SetSize(50, 50)
    overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    overlay:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)

    local background = button:CreateTexture(nil, "BACKGROUND")
    background:SetSize(24, 24)
    background:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    background:SetPoint("CENTER", button, "CENTER", 0, 1)

    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetSize(18, 18)
    icon:SetTexture(obj.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
    icon:SetPoint("CENTER", button, "CENTER", 0, 1)
    button.icon = icon

    local highlight = button:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    highlight:SetAllPoints(button)

    button:SetScript("OnClick", onClick)
    button:SetScript("OnEnter", onEnter)
    button:SetScript("OnLeave", onLeave)
    button:SetScript("OnDragStart", onDragStart)
    button:SetScript("OnDragStop", onDragStop)

    button.dataObject = obj
    button.db = db

    updatePosition(button, db)

    lib.objects[name] = button

    if db.hide then
        button:Hide()
    else
        button:Show()
    end

    return button
end

function lib:Register(name, obj, db)
    if not obj then error("LibDBIcon-1.0: No data object given.") end
    if not db then error("LibDBIcon-1.0: No db given.") end
    if not db.minimapPos then db.minimapPos = 220 end

    lib.notCreated[name] = nil
    createButton(name, obj, db)
end

function lib:Show(name)
    local button = lib.objects[name]
    if button then
        button.db.hide = false
        button:Show()
    end
end

function lib:Hide(name)
    local button = lib.objects[name]
    if button then
        button.db.hide = true
        button:Hide()
    end
end

function lib:IsRegistered(name)
    return lib.objects[name] and true or false
end

function lib:GetMinimapButton(name)
    return lib.objects[name]
end

function lib:Lock(name)
    local button = lib.objects[name]
    if button then
        button:SetScript("OnDragStart", nil)
        button:SetScript("OnDragStop", nil)
    end
end

function lib:Unlock(name)
    local button = lib.objects[name]
    if button then
        button:SetScript("OnDragStart", onDragStart)
        button:SetScript("OnDragStop", onDragStop)
    end
end
