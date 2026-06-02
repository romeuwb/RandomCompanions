----------------------------------------------------------------------
-- RandomCompanions
-- Addon para WoW 12.0.5 (Midnight)
-- Um botão no minimapa para configurações
-- Dois botões na tela (montaria + pet) movíveis
-- Pet aleatório invocado automaticamente ao entrar/relogar/instância
----------------------------------------------------------------------

local addonName, ns = ...

local defaults = {
    mountMode = "favorites",
    mountType = "all",         -- "all", "ground", "flying"
    petMode = "favorites",
    autoPet = true,
    showButtons = true,
    buttonScale = 1.0,
    lockButtons = false,
    mountButtonPos = nil,
    petButtonPos = nil,
    minimapPos = 220,
    minimapHide = false,
    locale = nil,              -- nil = auto-detect, "enUS" or "ptBR"
}

----------------------------------------------------------------------
-- UTILIDADES
----------------------------------------------------------------------

local function GetUsableMounts(excludeActive)
    local mounts = {}
    local mountIDs = C_MountJournal.GetMountIDs()
    local db = RandomCompanionsDB

    -- No WoW 12.0+ quase todas as montarias podem voar (dynamic flight)
    -- mountType 230 = originalmente terrestre
    -- mountType 248/247 = originalmente voadora
    -- Mas com dynamic flight, a maioria voa independente do mountType
    -- Usamos mountType apenas para filtrar as EXCLUSIVAMENTE terrestres (230)
    -- "ground" = apenas mountType 230 (terrestres clássicas)
    -- "flying" = tudo EXCETO mountType 230 (voadoras + aquáticas + especiais)
    local groundOnly = { [230] = true }

    local favOnly = (db.mountMode == "favorites")
    local typeFilter = db.mountType or "all" -- "all", "ground", "flying"

    for _, mountID in ipairs(mountIDs) do
        local name, spellID, icon, isActive, isUsable, sourceType,
              isFavorite, isFactionSpecific, faction, shouldHideOnChar,
              isCollected = C_MountJournal.GetMountInfoByID(mountID)

        if isCollected and isUsable and not shouldHideOnChar then
            if not (excludeActive and isActive) then
                -- Filtro de favoritas
                if favOnly and not isFavorite then
                    -- pula
                elseif typeFilter ~= "all" then
                    local _, _, _, _, mountType = C_MountJournal.GetMountInfoExtraByID(mountID)
                    if typeFilter == "ground" and groundOnly[mountType] then
                        table.insert(mounts, mountID)
                    elseif typeFilter == "flying" and not groundOnly[mountType] then
                        table.insert(mounts, mountID)
                    end
                else
                    table.insert(mounts, mountID)
                end
            end
        end
    end
    return mounts
end

local function SummonRandomMount()
    local mounts = GetUsableMounts(true)

    -- Se não encontrou, avisa mas NÃO ignora os filtros silenciosamente
    if #mounts == 0 then
        print("|cffff6600[RandomCompanions]|r " .. ns.Loc("NO_MOUNT"))
        return
    end

    C_MountJournal.SummonByID(mounts[math.random(#mounts)])
end

local function SummonRandomPet()
    local db = RandomCompanionsDB
    local favoritesOnly = (db.petMode == "favorites")
    local currentPet = C_PetJournal.GetSummonedPetGUID()
    local numPets = C_PetJournal.GetNumPets()
    local candidates = {}

    for i = 1, numPets do
        local petID, speciesID, owned, customName, level, favorite,
              isRevoked = C_PetJournal.GetPetInfoByIndex(i)
        if petID and owned and not isRevoked then
            if not favoritesOnly or favorite then
                if petID ~= currentPet then
                    table.insert(candidates, petID)
                end
            end
        end
    end

    -- Fallback: se modo favoritos não tem candidatos, usa todos
    if #candidates == 0 and favoritesOnly then
        for i = 1, numPets do
            local petID, speciesID, owned, customName, level, favorite,
                  isRevoked = C_PetJournal.GetPetInfoByIndex(i)
            if petID and owned and not isRevoked and petID ~= currentPet then
                table.insert(candidates, petID)
            end
        end
    end

    if #candidates > 0 then
        C_PetJournal.SummonPetByGUID(candidates[math.random(#candidates)])
    end
end

----------------------------------------------------------------------
-- BOTÕES NA TELA (Montaria + Pet)
----------------------------------------------------------------------

local function SaveButtonPosition(button, key)
    local point, _, relativePoint, x, y = button:GetPoint()
    RandomCompanionsDB[key] = { point, relativePoint, x, y }
end

local function RestoreButtonPosition(button, key, defaultX, defaultY)
    local pos = RandomCompanionsDB[key]
    if pos then
        button:ClearAllPoints()
        button:SetPoint(pos[1], UIParent, pos[2], pos[3], pos[4])
    else
        button:ClearAllPoints()
        button:SetPoint("CENTER", UIParent, "CENTER", defaultX, defaultY)
    end
end

local function CreateStyledButton(name, iconPath, defaultX, defaultY)
    local btn = CreateFrame("Button", name, UIParent)
    btn:SetSize(40, 40)
    btn:SetPoint("CENTER", UIParent, "CENTER", defaultX, defaultY)
    btn:SetMovable(true)
    btn:EnableMouse(true)
    btn:RegisterForDrag("LeftButton")
    btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    btn:SetClampedToScreen(true)
    btn:SetFrameStrata("MEDIUM")

    -- Ícone quadrado limpo
    local icon = btn:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints()
    icon:SetTexture(iconPath)
    icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    btn.icon = icon

    -- Borda quadrada estilo action button
    local border = btn:CreateTexture(nil, "OVERLAY")
    border:SetSize(62, 62)
    border:SetPoint("CENTER")
    border:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
    border:SetBlendMode("ADD")
    border:SetAlpha(0.5)

    -- Highlight ao passar o mouse
    local highlight = btn:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetAllPoints()
    highlight:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
    highlight:SetBlendMode("ADD")
    highlight:SetAlpha(0.4)

    local flash = btn:CreateAnimationGroup()
    local a1 = flash:CreateAnimation("Alpha")
    a1:SetFromAlpha(1)
    a1:SetToAlpha(0.4)
    a1:SetDuration(0.15)
    a1:SetOrder(1)
    local a2 = flash:CreateAnimation("Alpha")
    a2:SetFromAlpha(0.4)
    a2:SetToAlpha(1)
    a2:SetDuration(0.15)
    a2:SetOrder(2)
    btn.flash = flash

    btn:SetScript("OnDragStart", function(self)
        if not RandomCompanionsDB.lockButtons then
            self:StartMoving()
        end
    end)
    btn:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    return btn
end

-- Botão de Montaria
local mountButton = CreateStyledButton(
    "RandomCompanionsMountButton",
    "Interface\\Icons\\Ability_Mount_RidingHorse",
    -30, -200
)

mountButton:SetScript("OnClick", function(self, button)
    if button == "RightButton" then
        local db = RandomCompanionsDB
        if db.mountMode == "favorites" then
            db.mountMode = "all"
            print("|cff00ff00[RandomCompanions]|r " .. ns.Loc("MOUNTS_ALL"))
        else
            db.mountMode = "favorites"
            print("|cff00ff00[RandomCompanions]|r " .. ns.Loc("MOUNTS_FAVORITES"))
        end
    else
        self.flash:Play()
        SummonRandomMount()
    end
end)

mountButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine("|cff00ccff" .. ns.Loc("TT_MOUNT_TITLE") .. "|r")
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(ns.Loc("TT_LEFT_MOUNT"))
    GameTooltip:AddLine(ns.Loc("TT_RIGHT_MOUNT"))
    if not RandomCompanionsDB.lockButtons then
        GameTooltip:AddLine(ns.Loc("TT_DRAG"))
    end
    local mode = ns.Loc("MODE_" .. string.upper(RandomCompanionsDB.mountMode or "all"))
    local mtype = ns.Loc("TYPE_" .. string.upper(RandomCompanionsDB.mountType or "all"))
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(ns.Loc("TT_SELECTION") .. " |cffffd100" .. mode .. "|r")
    GameTooltip:AddLine(ns.Loc("TT_TYPE") .. " |cffffd100" .. mtype .. "|r")
    GameTooltip:Show()
end)
mountButton:SetScript("OnLeave", function() GameTooltip:Hide() end)

-- Botão de Pet
local petButton = CreateStyledButton(
    "RandomCompanionsPetButton",
    "Interface\\Icons\\INV_Box_PetCarrier_01",
    30, -200
)

petButton:SetScript("OnClick", function(self, button)
    if button == "RightButton" then
        local db = RandomCompanionsDB
        if db.petMode == "favorites" then
            db.petMode = "all"
            print("|cff00ff00[RandomCompanions]|r " .. ns.Loc("PETS_ALL"))
        else
            db.petMode = "favorites"
            print("|cff00ff00[RandomCompanions]|r " .. ns.Loc("PETS_FAVORITES"))
        end
    else
        self.flash:Play()
        SummonRandomPet()
    end
end)

petButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine("|cff00ccff" .. ns.Loc("TT_PET_TITLE") .. "|r")
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(ns.Loc("TT_LEFT_PET"))
    GameTooltip:AddLine(ns.Loc("TT_RIGHT_PET"))
    if not RandomCompanionsDB.lockButtons then
        GameTooltip:AddLine(ns.Loc("TT_DRAG"))
    end
    local mode = ns.Loc("MODE_" .. string.upper(RandomCompanionsDB.petMode or "all"))
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(ns.Loc("TT_SELECTION") .. " |cffffd100" .. mode .. "|r")
    GameTooltip:Show()
end)
petButton:SetScript("OnLeave", function() GameTooltip:Hide() end)

local function UpdateButtonScale()
    local scale = RandomCompanionsDB.buttonScale or 1.0
    mountButton:SetScale(scale)
    petButton:SetScale(scale)
end

local function UpdateButtonVisibility()
    if RandomCompanionsDB.showButtons then
        mountButton:Show()
        petButton:Show()
    else
        mountButton:Hide()
        petButton:Hide()
    end
end

-- Ocultar botões durante pet battles, cinematics e quando a UI é escondida
local visibilityFrame = CreateFrame("Frame")
visibilityFrame:RegisterEvent("PET_BATTLE_OPENING_START")
visibilityFrame:RegisterEvent("PET_BATTLE_CLOSE")
visibilityFrame:RegisterEvent("CINEMATIC_START")
visibilityFrame:RegisterEvent("CINEMATIC_STOP")
visibilityFrame:RegisterEvent("PLAY_MOVIE")
visibilityFrame:RegisterEvent("STOP_MOVIE")

visibilityFrame:SetScript("OnEvent", function(self, event)
    if event == "PET_BATTLE_OPENING_START" or event == "CINEMATIC_START" or event == "PLAY_MOVIE" then
        mountButton:Hide()
        petButton:Hide()
    elseif event == "PET_BATTLE_CLOSE" or event == "CINEMATIC_STOP" or event == "STOP_MOVIE" then
        if RandomCompanionsDB.showButtons then
            mountButton:Show()
            petButton:Show()
        end
    end
end)

-- Respeitar UIParent hide/show (minigames, veículos, etc.)
mountButton:SetParent(UIParent)
petButton:SetParent(UIParent)

----------------------------------------------------------------------
-- BOTÃO DO MINIMAPA (apenas abre configurações)
----------------------------------------------------------------------

local function CreateMinimapButton()
    local LDB = LibStub("LibDataBroker-1.1")
    local LDBIcon = LibStub("LibDBIcon-1.0")

    local dataObj = LDB:NewDataObject("RandomCompanions", {
        type = "launcher",
        text = "RandomCompanions",
        icon = "Interface\\Icons\\PetJournalPortrait",
        OnClick = function(...)
            -- Detectar o botão independente da assinatura do LibDBIcon
            local button
            for i = 1, select("#", ...) do
                local arg = select(i, ...)
                if arg == "LeftButton" or arg == "RightButton" or arg == "MiddleButton" then
                    button = arg
                    break
                end
            end
            if button == "LeftButton" then
                if Settings and Settings.OpenToCategory and ns.settingsCategory then
                    Settings.OpenToCategory(ns.settingsCategory:GetID())
                end
            elseif button == "RightButton" then
                RandomCompanionsDB.showButtons = not RandomCompanionsDB.showButtons
                UpdateButtonVisibility()
                local s = RandomCompanionsDB.showButtons and ns.Loc("BUTTONS_VISIBLE") or ns.Loc("BUTTONS_HIDDEN")
                print("|cff00ff00[RandomCompanions]|r " .. s)
            end
        end,
        OnTooltipShow = function(tooltip)
            tooltip:AddLine("|cff00ccff" .. ns.Loc("TT_MINIMAP_TITLE") .. "|r")
            tooltip:AddLine(" ")
            tooltip:AddLine(ns.Loc("TT_MINIMAP_LEFT"))
            tooltip:AddLine(ns.Loc("TT_MINIMAP_RIGHT"))
        end,
    })

    if not RandomCompanionsDB.minimap then
        RandomCompanionsDB.minimap = { hide = false, minimapPos = 220 }
    end
    LDBIcon:Register("RandomCompanions", dataObj, RandomCompanionsDB.minimap)
    ns.LDBIcon = LDBIcon
end

----------------------------------------------------------------------
-- PAINEL DE OPÇÕES (Interface > Addons > RandomCompanions)
----------------------------------------------------------------------

local function CreateOptionsPanel()
    local panel = CreateFrame("Frame")
    panel.name = "RandomCompanions"

    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("|cff00ccffRandomCompanions|r")

    local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    subtitle:SetText("Configurações de montarias e pets aleatórios")

    local sep1 = panel:CreateTexture(nil, "ARTWORK")
    sep1:SetSize(600, 1)
    sep1:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -12)
    sep1:SetColorTexture(0.4, 0.4, 0.4, 0.8)

    -- MONTARIAS
    local mountHeader = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    mountHeader:SetPoint("TOPLEFT", sep1, "BOTTOMLEFT", 0, -12)
    mountHeader:SetText("|cffffd100Montarias|r")

    local mountModeLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    mountModeLabel:SetPoint("TOPLEFT", mountHeader, "BOTTOMLEFT", 0, -12)
    mountModeLabel:SetText("Modo de seleção:")

    local mountDropdown = CreateFrame("Frame", "RCMountModeDropdown", panel, "UIDropDownMenuTemplate")
    mountDropdown:SetPoint("TOPLEFT", mountModeLabel, "TOPLEFT", 100, 8)
    UIDropDownMenu_SetWidth(mountDropdown, 150)
    UIDropDownMenu_Initialize(mountDropdown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()

        info.text = "Apenas Favoritas"
        info.value = "favorites"
        info.checked = (RandomCompanionsDB.mountMode == "favorites")
        info.func = function()
            RandomCompanionsDB.mountMode = "favorites"
            UIDropDownMenu_SetText(mountDropdown, "Apenas Favoritas")
        end
        UIDropDownMenu_AddButton(info, level)

        info.text = "Todas as Montarias"
        info.value = "all"
        info.checked = (RandomCompanionsDB.mountMode == "all")
        info.func = function()
            RandomCompanionsDB.mountMode = "all"
            UIDropDownMenu_SetText(mountDropdown, "Todas as Montarias")
        end
        UIDropDownMenu_AddButton(info, level)
    end)

    -- Dropdown: Tipo de montaria
    local mountTypeLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    mountTypeLabel:SetPoint("TOPLEFT", mountModeLabel, "BOTTOMLEFT", 0, -30)
    mountTypeLabel:SetText("Tipo:")

    local mountTypeDropdown = CreateFrame("Frame", "RCMountTypeDropdown", panel, "UIDropDownMenuTemplate")
    mountTypeDropdown:SetPoint("TOPLEFT", mountTypeLabel, "TOPLEFT", 100, 8)
    UIDropDownMenu_SetWidth(mountTypeDropdown, 150)
    UIDropDownMenu_Initialize(mountTypeDropdown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()

        info.text = "Todas (sem filtro)"
        info.value = "all"
        info.checked = (RandomCompanionsDB.mountType == "all")
        info.func = function()
            RandomCompanionsDB.mountType = "all"
            UIDropDownMenu_SetText(mountTypeDropdown, "Todas (sem filtro)")
        end
        UIDropDownMenu_AddButton(info, level)

        info.text = "Apenas Terrestres"
        info.value = "ground"
        info.checked = (RandomCompanionsDB.mountType == "ground")
        info.func = function()
            RandomCompanionsDB.mountType = "ground"
            UIDropDownMenu_SetText(mountTypeDropdown, "Apenas Terrestres")
        end
        UIDropDownMenu_AddButton(info, level)

        info.text = "Apenas Voadoras"
        info.value = "flying"
        info.checked = (RandomCompanionsDB.mountType == "flying")
        info.func = function()
            RandomCompanionsDB.mountType = "flying"
            UIDropDownMenu_SetText(mountTypeDropdown, "Apenas Voadoras")
        end
        UIDropDownMenu_AddButton(info, level)
    end)

    -- PETS
    local sep2 = panel:CreateTexture(nil, "ARTWORK")
    sep2:SetSize(600, 1)
    sep2:SetPoint("TOPLEFT", mountTypeLabel, "BOTTOMLEFT", 0, -30)
    sep2:SetColorTexture(0.4, 0.4, 0.4, 0.4)

    local petHeader = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    petHeader:SetPoint("TOPLEFT", sep2, "BOTTOMLEFT", 0, -12)
    petHeader:SetText("|cffffd100Pets|r")

    local petModeLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    petModeLabel:SetPoint("TOPLEFT", petHeader, "BOTTOMLEFT", 0, -12)
    petModeLabel:SetText("Modo de seleção:")

    local petDropdown = CreateFrame("Frame", "RCPetModeDropdown", panel, "UIDropDownMenuTemplate")
    petDropdown:SetPoint("TOPLEFT", petModeLabel, "TOPLEFT", 100, 8)
    UIDropDownMenu_SetWidth(petDropdown, 150)
    UIDropDownMenu_Initialize(petDropdown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()
        info.text = "Apenas Favoritos"
        info.value = "favorites"
        info.checked = (RandomCompanionsDB.petMode == "favorites")
        info.func = function()
            RandomCompanionsDB.petMode = "favorites"
            UIDropDownMenu_SetText(petDropdown, "Apenas Favoritos")
        end
        UIDropDownMenu_AddButton(info, level)
        info.text = "Todos os Pets"
        info.value = "all"
        info.checked = (RandomCompanionsDB.petMode == "all")
        info.func = function()
            RandomCompanionsDB.petMode = "all"
            UIDropDownMenu_SetText(petDropdown, "Todos os Pets")
        end
        UIDropDownMenu_AddButton(info, level)
    end)

    -- Auto-pet
    local autoPetCheck = CreateFrame("CheckButton", "RCAutoPetCheck", panel, "InterfaceOptionsCheckButtonTemplate")
    autoPetCheck:SetPoint("TOPLEFT", petModeLabel, "BOTTOMLEFT", -2, -30)
    autoPetCheck.Text:SetText("Invocar pet automaticamente ao entrar/relogar/instância")
    autoPetCheck:SetChecked(RandomCompanionsDB.autoPet)
    autoPetCheck:SetScript("OnClick", function(self)
        RandomCompanionsDB.autoPet = self:GetChecked()
    end)

    -- APARÊNCIA
    local sep3 = panel:CreateTexture(nil, "ARTWORK")
    sep3:SetSize(600, 1)
    sep3:SetPoint("TOPLEFT", autoPetCheck, "BOTTOMLEFT", 2, -16)
    sep3:SetColorTexture(0.4, 0.4, 0.4, 0.4)

    local appearHeader = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    appearHeader:SetPoint("TOPLEFT", sep3, "BOTTOMLEFT", 0, -12)
    appearHeader:SetText("|cffffd100Aparência|r")

    local showBtnCheck = CreateFrame("CheckButton", "RCShowBtnCheck", panel, "InterfaceOptionsCheckButtonTemplate")
    showBtnCheck:SetPoint("TOPLEFT", appearHeader, "BOTTOMLEFT", -2, -8)
    showBtnCheck.Text:SetText("Mostrar botões na tela")
    showBtnCheck:SetChecked(RandomCompanionsDB.showButtons)
    showBtnCheck:SetScript("OnClick", function(self)
        RandomCompanionsDB.showButtons = self:GetChecked()
        UpdateButtonVisibility()
    end)

    local lockBtnCheck = CreateFrame("CheckButton", "RCLockBtnCheck", panel, "InterfaceOptionsCheckButtonTemplate")
    lockBtnCheck:SetPoint("TOPLEFT", showBtnCheck, "BOTTOMLEFT", 0, -4)
    lockBtnCheck.Text:SetText("Travar posição dos botões")
    lockBtnCheck:SetChecked(RandomCompanionsDB.lockButtons)
    lockBtnCheck:SetScript("OnClick", function(self)
        RandomCompanionsDB.lockButtons = self:GetChecked()
    end)

    local scaleLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    scaleLabel:SetPoint("TOPLEFT", lockBtnCheck, "BOTTOMLEFT", 2, -16)
    scaleLabel:SetText("Tamanho dos botões:")

    local scaleSlider = CreateFrame("Slider", "RCScaleSlider", panel, "OptionsSliderTemplate")
    scaleSlider:SetPoint("TOPLEFT", scaleLabel, "BOTTOMLEFT", 0, -12)
    scaleSlider:SetWidth(200)
    scaleSlider:SetMinMaxValues(0.5, 2.0)
    scaleSlider:SetValueStep(0.1)
    scaleSlider:SetObeyStepOnDrag(true)
    scaleSlider.Low:SetText("50%")
    scaleSlider.High:SetText("200%")
    scaleSlider:SetValue(RandomCompanionsDB.buttonScale or 1.0)

    local scaleValue = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    scaleValue:SetPoint("TOP", scaleSlider, "BOTTOM", 0, -2)
    scaleValue:SetText(math.floor((RandomCompanionsDB.buttonScale or 1.0) * 100) .. "%")

    scaleSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value * 10 + 0.5) / 10
        RandomCompanionsDB.buttonScale = value
        scaleValue:SetText(math.floor(value * 100) .. "%")
        UpdateButtonScale()
    end)

    local resetBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    resetBtn:SetSize(160, 24)
    resetBtn:SetPoint("TOPLEFT", scaleSlider, "BOTTOMLEFT", 0, -24)
    resetBtn:SetText("Resetar Posição")
    resetBtn:SetScript("OnClick", function()
        RandomCompanionsDB.mountButtonPos = nil
        RandomCompanionsDB.petButtonPos = nil
        RestoreButtonPosition(mountButton, "mountButtonPos", -30, -200)
        RestoreButtonPosition(petButton, "petButtonPos", 30, -200)
        print("|cff00ff00[RandomCompanions]|r Posição dos botões resetada.")
    end)

    -- MINIMAPA
    local sep4 = panel:CreateTexture(nil, "ARTWORK")
    sep4:SetSize(600, 1)
    sep4:SetPoint("TOPLEFT", resetBtn, "BOTTOMLEFT", 0, -16)
    sep4:SetColorTexture(0.4, 0.4, 0.4, 0.4)

    local minimapHeader = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    minimapHeader:SetPoint("TOPLEFT", sep4, "BOTTOMLEFT", 0, -12)
    minimapHeader:SetText("|cffffd100Minimapa|r")

    local minimapCheck = CreateFrame("CheckButton", "RCMinimapCheck", panel, "InterfaceOptionsCheckButtonTemplate")
    minimapCheck:SetPoint("TOPLEFT", minimapHeader, "BOTTOMLEFT", -2, -8)
    minimapCheck.Text:SetText(ns.Loc("OPT_SHOW_MINIMAP"))
    local mmHidden = RandomCompanionsDB.minimap and RandomCompanionsDB.minimap.hide
    minimapCheck:SetChecked(not mmHidden)
    minimapCheck:SetScript("OnClick", function(self)
        if self:GetChecked() then
            RandomCompanionsDB.minimap.hide = false
            if ns.LDBIcon then ns.LDBIcon:Show("RandomCompanions") end
        else
            RandomCompanionsDB.minimap.hide = true
            if ns.LDBIcon then ns.LDBIcon:Hide("RandomCompanions") end
        end
    end)

    -- === SEÇÃO: IDIOMA ===
    local sep5 = panel:CreateTexture(nil, "ARTWORK")
    sep5:SetSize(600, 1)
    sep5:SetPoint("TOPLEFT", minimapCheck, "BOTTOMLEFT", 2, -16)
    sep5:SetColorTexture(0.4, 0.4, 0.4, 0.4)

    local langHeader = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    langHeader:SetPoint("TOPLEFT", sep5, "BOTTOMLEFT", 0, -12)
    langHeader:SetText("|cffffd100" .. ns.Loc("OPT_LANGUAGE") .. "|r")

    local langLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    langLabel:SetPoint("TOPLEFT", langHeader, "BOTTOMLEFT", 0, -12)
    langLabel:SetText(ns.Loc("OPT_LANG_LABEL"))

    local langDropdown = CreateFrame("Frame", "RCLangDropdown", panel, "UIDropDownMenuTemplate")
    langDropdown:SetPoint("TOPLEFT", langLabel, "TOPLEFT", 180, 8)
    UIDropDownMenu_SetWidth(langDropdown, 120)
    UIDropDownMenu_Initialize(langDropdown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()

        info.text = "English"
        info.value = "enUS"
        info.checked = (RandomCompanionsDB.locale == "enUS" or (RandomCompanionsDB.locale == nil and GetLocale() ~= "ptBR"))
        info.func = function()
            RandomCompanionsDB.locale = "enUS"
            UIDropDownMenu_SetText(langDropdown, "English")
            print("|cff00ff00[RandomCompanions]|r Language set to English. /reload to apply.")
        end
        UIDropDownMenu_AddButton(info, level)

        info.text = "Português"
        info.value = "ptBR"
        info.checked = (RandomCompanionsDB.locale == "ptBR" or (RandomCompanionsDB.locale == nil and GetLocale() == "ptBR"))
        info.func = function()
            RandomCompanionsDB.locale = "ptBR"
            UIDropDownMenu_SetText(langDropdown, "Português")
            print("|cff00ff00[RandomCompanions]|r Idioma definido para Português. /reload para aplicar.")
        end
        UIDropDownMenu_AddButton(info, level)
    end)

    -- OnShow refresh
    panel:SetScript("OnShow", function()
        local db = RandomCompanionsDB
        autoPetCheck:SetChecked(db.autoPet)
        showBtnCheck:SetChecked(db.showButtons)
        lockBtnCheck:SetChecked(db.lockButtons)
        scaleSlider:SetValue(db.buttonScale or 1.0)
        minimapCheck:SetChecked(not (db.minimap and db.minimap.hide))

        -- Language dropdown text
        local currentLocale = ns.GetAddonLocale()
        if currentLocale == "ptBR" then
            UIDropDownMenu_SetText(langDropdown, "Português")
        else
            UIDropDownMenu_SetText(langDropdown, "English")
        end

        if db.mountMode == "favorites" then
            UIDropDownMenu_SetText(mountDropdown, ns.Loc("OPT_ONLY_FAVORITES"))
        else
            UIDropDownMenu_SetText(mountDropdown, ns.Loc("OPT_ALL_MOUNTS"))
        end

        local typeNames = { all = ns.Loc("OPT_TYPE_ALL"), ground = ns.Loc("OPT_TYPE_GROUND"), flying = ns.Loc("OPT_TYPE_FLYING") }
        UIDropDownMenu_SetText(mountTypeDropdown, typeNames[db.mountType] or ns.Loc("OPT_TYPE_ALL"))
        if db.petMode == "favorites" then
            UIDropDownMenu_SetText(petDropdown, ns.Loc("OPT_ONLY_FAV_PETS"))
        else
            UIDropDownMenu_SetText(petDropdown, ns.Loc("OPT_ALL_PETS"))
        end
    end)

    -- Registrar no painel de Interface
    if Settings and Settings.RegisterCanvasLayoutCategory then
        local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
        Settings.RegisterAddOnCategory(category)
        ns.settingsCategory = category
    else
        InterfaceOptions_AddCategory(panel)
    end
    ns.optionsPanel = panel
end

----------------------------------------------------------------------
-- EVENTOS: INICIALIZAÇÃO + AUTO-PET
----------------------------------------------------------------------

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_LOGOUT")

eventFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        if not RandomCompanionsDB then
            RandomCompanionsDB = {}
        end
        for k, v in pairs(defaults) do
            if RandomCompanionsDB[k] == nil then
                RandomCompanionsDB[k] = v
            end
        end

        RestoreButtonPosition(mountButton, "mountButtonPos", -30, -200)
        RestoreButtonPosition(petButton, "petButtonPos", 30, -200)
        UpdateButtonScale()
        UpdateButtonVisibility()
        CreateMinimapButton()
        CreateOptionsPanel()

        print("|cff00ccff[RandomCompanions]|r " .. ns.Loc("LOADED"))

    elseif event == "PLAYER_ENTERING_WORLD" then
        -- Auto-pet ao entrar no mundo, relogar, trocar instância
        if RandomCompanionsDB.autoPet then
            C_Timer.After(2, function()
                if not C_PetJournal.GetSummonedPetGUID() then
                    SummonRandomPet()
                end
            end)
        end

    elseif event == "PLAYER_LOGOUT" then
        SaveButtonPosition(mountButton, "mountButtonPos")
        SaveButtonPosition(petButton, "petButtonPos")
    end
end)

----------------------------------------------------------------------
-- SLASH COMMANDS
----------------------------------------------------------------------

SLASH_RANDOMCOMPANIONS1 = "/rc"
SLASH_RANDOMCOMPANIONS2 = "/randomcompanions"

SlashCmdList["RANDOMCOMPANIONS"] = function(msg)
    local cmd = msg:lower():trim()

    if cmd == "mount" then
        SummonRandomMount()
    elseif cmd == "pet" then
        SummonRandomPet()
    elseif cmd == "mf" then
        RandomCompanionsDB.mountMode = "favorites"
        print("|cff00ff00[RandomCompanions]|r " .. ns.Loc("MOUNTS_FAVORITES"))
    elseif cmd == "ma" then
        RandomCompanionsDB.mountMode = "all"
        print("|cff00ff00[RandomCompanions]|r " .. ns.Loc("MOUNTS_ALL"))
    elseif cmd == "mg" then
        RandomCompanionsDB.mountType = "ground"
        print("|cff00ff00[RandomCompanions]|r " .. ns.Loc("MOUNTS_GROUND"))
    elseif cmd == "mv" then
        RandomCompanionsDB.mountType = "flying"
        print("|cff00ff00[RandomCompanions]|r " .. ns.Loc("MOUNTS_FLYING"))
    elseif cmd == "mt" then
        RandomCompanionsDB.mountType = "all"
        print("|cff00ff00[RandomCompanions]|r " .. ns.Loc("MOUNTS_TYPE_ALL"))
    elseif cmd == "pf" then
        RandomCompanionsDB.petMode = "favorites"
        print("|cff00ff00[RandomCompanions]|r " .. ns.Loc("PETS_FAVORITES"))
    elseif cmd == "pa" then
        RandomCompanionsDB.petMode = "all"
        print("|cff00ff00[RandomCompanions]|r " .. ns.Loc("PETS_ALL"))
    elseif cmd == "autopet on" then
        RandomCompanionsDB.autoPet = true
        print("|cff00ff00[RandomCompanions]|r " .. ns.Loc("AUTOPET_ON"))
    elseif cmd == "autopet off" then
        RandomCompanionsDB.autoPet = false
        print("|cff00ff00[RandomCompanions]|r " .. ns.Loc("AUTOPET_OFF"))
    elseif cmd == "toggle" then
        RandomCompanionsDB.showButtons = not RandomCompanionsDB.showButtons
        UpdateButtonVisibility()
        local s = RandomCompanionsDB.showButtons and ns.Loc("BUTTONS_VISIBLE") or ns.Loc("BUTTONS_HIDDEN")
        print("|cff00ff00[RandomCompanions]|r " .. s)
    elseif cmd == "lock" then
        RandomCompanionsDB.lockButtons = not RandomCompanionsDB.lockButtons
        local s = RandomCompanionsDB.lockButtons and ns.Loc("BUTTONS_LOCKED") or ns.Loc("BUTTONS_UNLOCKED")
        print("|cff00ff00[RandomCompanions]|r " .. s)
    elseif cmd == "config" or cmd == "options" or cmd == "opt" then
        if ns.settingsCategory then
            Settings.OpenToCategory(ns.settingsCategory:GetID())
        elseif InterfaceOptionsFrame_OpenToCategory then
            InterfaceOptionsFrame_OpenToCategory(ns.optionsPanel)
            InterfaceOptionsFrame_OpenToCategory(ns.optionsPanel)
        end
    elseif cmd == "reset" then
        RandomCompanionsDB.mountButtonPos = nil
        RandomCompanionsDB.petButtonPos = nil
        RestoreButtonPosition(mountButton, "mountButtonPos", -30, -200)
        RestoreButtonPosition(petButton, "petButtonPos", 30, -200)
        print("|cff00ff00[RandomCompanions]|r " .. ns.Loc("POSITION_RESET"))
    else
        print("|cff00ccff[RandomCompanions]|r " .. ns.Loc("HELP_TITLE"))
        print(ns.Loc("HELP_MOUNT"))
        print(ns.Loc("HELP_PET"))
        print(ns.Loc("HELP_MF"))
        print(ns.Loc("HELP_TYPE"))
        print(ns.Loc("HELP_PF"))
        print(ns.Loc("HELP_AUTOPET"))
        print(ns.Loc("HELP_TOGGLE"))
        print(ns.Loc("HELP_LOCK"))
        print(ns.Loc("HELP_CONFIG"))
        print(ns.Loc("HELP_RESET"))
    end
end

----------------------------------------------------------------------
-- KEYBINDINGS
----------------------------------------------------------------------

BINDING_HEADER_RANDOMCOMPANIONS = "RandomCompanions"
BINDING_NAME_RANDOMCOMPANIONS_MOUNT = "Invocar Montaria Aleatória"
BINDING_NAME_RANDOMCOMPANIONS_PET = "Invocar Pet Aleatório"
