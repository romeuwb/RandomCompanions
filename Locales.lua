----------------------------------------------------------------------
-- RandomCompanions - Localization
----------------------------------------------------------------------

local _, ns = ...

local L = {}
ns.L = L

-- Detectar idioma do cliente ou usar configuração manual
local function GetAddonLocale()
    if RandomCompanionsDB and RandomCompanionsDB.locale then
        return RandomCompanionsDB.locale
    end
    local clientLocale = GetLocale()
    if clientLocale == "ptBR" then
        return "ptBR"
    end
    return "enUS"
end

ns.GetAddonLocale = GetAddonLocale

----------------------------------------------------------------------
-- ENGLISH (default)
----------------------------------------------------------------------

L["enUS"] = {
    -- General
    ["LOADED"] = "Loaded! /rc config for options.",
    ["NO_MOUNT"] = "No mount available!",

    -- Mount modes
    ["MOUNTS_FAVORITES"] = "Mounts: FAVORITES mode.",
    ["MOUNTS_ALL"] = "Mounts: ALL mode.",
    ["MOUNTS_GROUND"] = "Mounts: type GROUND.",
    ["MOUNTS_FLYING"] = "Mounts: type FLYING.",
    ["MOUNTS_TYPE_ALL"] = "Mounts: type ALL.",

    -- Pet modes
    ["PETS_FAVORITES"] = "Pets: FAVORITES mode.",
    ["PETS_ALL"] = "Pets: ALL mode.",
    ["AUTOPET_ON"] = "Auto-pet ENABLED.",
    ["AUTOPET_OFF"] = "Auto-pet DISABLED.",

    -- Buttons
    ["BUTTONS_VISIBLE"] = "Buttons visible.",
    ["BUTTONS_HIDDEN"] = "Buttons hidden.",
    ["BUTTONS_LOCKED"] = "Buttons LOCKED.",
    ["BUTTONS_UNLOCKED"] = "Buttons UNLOCKED.",
    ["POSITION_RESET"] = "Button position reset.",

    -- Tooltips - Mount
    ["TT_MOUNT_TITLE"] = "RandomCompanions - Mount",
    ["TT_LEFT_MOUNT"] = "|cff00ff00Left:|r Summon random mount",
    ["TT_RIGHT_MOUNT"] = "|cff00ff00Right:|r Toggle Favorites/All",
    ["TT_DRAG"] = "|cff00ff00Drag:|r Move button",
    ["TT_SELECTION"] = "Selection:",
    ["TT_TYPE"] = "Type:",

    -- Tooltips - Pet
    ["TT_PET_TITLE"] = "RandomCompanions - Pet",
    ["TT_LEFT_PET"] = "|cff00ff00Left:|r Summon random pet",
    ["TT_RIGHT_PET"] = "|cff00ff00Right:|r Toggle Favorites/All",

    -- Tooltips - Minimap
    ["TT_MINIMAP_TITLE"] = "RandomCompanions",
    ["TT_MINIMAP_LEFT"] = "|cff00ff00Left:|r Open settings",
    ["TT_MINIMAP_RIGHT"] = "|cff00ff00Right:|r Show/hide buttons",

    -- Mode names
    ["MODE_FAVORITES"] = "Favorites",
    ["MODE_ALL"] = "All",
    ["TYPE_ALL"] = "All",
    ["TYPE_GROUND"] = "Ground",
    ["TYPE_FLYING"] = "Flying",

    -- Options panel
    ["OPT_TITLE"] = "RandomCompanions",
    ["OPT_SUBTITLE"] = "Random mount and pet settings",
    ["OPT_MOUNTS"] = "Mounts",
    ["OPT_PETS"] = "Pets",
    ["OPT_APPEARANCE"] = "Appearance",
    ["OPT_MINIMAP"] = "Minimap",
    ["OPT_LANGUAGE"] = "Language",
    ["OPT_SELECTION_MODE"] = "Selection mode:",
    ["OPT_TYPE"] = "Type:",
    ["OPT_ONLY_FAVORITES"] = "Only Favorites",
    ["OPT_ALL_MOUNTS"] = "All Mounts",
    ["OPT_TYPE_ALL"] = "All (no filter)",
    ["OPT_TYPE_GROUND"] = "Ground Only",
    ["OPT_TYPE_FLYING"] = "Flying Only",
    ["OPT_ONLY_FAV_PETS"] = "Only Favorites",
    ["OPT_ALL_PETS"] = "All Pets",
    ["OPT_AUTOPET"] = "Auto-summon pet on login/reload/instance",
    ["OPT_SHOW_BUTTONS"] = "Show on-screen buttons",
    ["OPT_LOCK_BUTTONS"] = "Lock button position",
    ["OPT_BUTTON_SIZE"] = "Button size:",
    ["OPT_RESET_POS"] = "Reset Position",
    ["OPT_SHOW_MINIMAP"] = "Show minimap icon",
    ["OPT_LANG_EN"] = "English",
    ["OPT_LANG_PT"] = "Português",
    ["OPT_LANG_LABEL"] = "Language (requires /reload):",

    -- Slash help
    ["HELP_TITLE"] = "Commands:",
    ["HELP_MOUNT"] = "  /rc mount - Summon random mount",
    ["HELP_PET"] = "  /rc pet - Summon random pet",
    ["HELP_MF"] = "  /rc mf/ma - Mounts favorites/all",
    ["HELP_TYPE"] = "  /rc mg/mv/mt - Type: ground/flying/all",
    ["HELP_PF"] = "  /rc pf/pa - Pets favorites/all",
    ["HELP_AUTOPET"] = "  /rc autopet on/off - Auto-pet",
    ["HELP_TOGGLE"] = "  /rc toggle - Show/hide buttons",
    ["HELP_LOCK"] = "  /rc lock - Lock/unlock buttons",
    ["HELP_CONFIG"] = "  /rc config - Open settings",
    ["HELP_RESET"] = "  /rc reset - Reset position",
}

----------------------------------------------------------------------
-- PORTUGUÊS
----------------------------------------------------------------------

L["ptBR"] = {
    -- General
    ["LOADED"] = "Carregado! /rc config para opções.",
    ["NO_MOUNT"] = "Nenhuma montaria disponível!",

    -- Mount modes
    ["MOUNTS_FAVORITES"] = "Montarias: modo FAVORITAS.",
    ["MOUNTS_ALL"] = "Montarias: modo TODAS.",
    ["MOUNTS_GROUND"] = "Montarias: tipo TERRESTRES.",
    ["MOUNTS_FLYING"] = "Montarias: tipo VOADORAS.",
    ["MOUNTS_TYPE_ALL"] = "Montarias: tipo TODAS.",

    -- Pet modes
    ["PETS_FAVORITES"] = "Pets: modo FAVORITOS.",
    ["PETS_ALL"] = "Pets: modo TODOS.",
    ["AUTOPET_ON"] = "Auto-pet ATIVADO.",
    ["AUTOPET_OFF"] = "Auto-pet DESATIVADO.",

    -- Buttons
    ["BUTTONS_VISIBLE"] = "Botões visíveis.",
    ["BUTTONS_HIDDEN"] = "Botões ocultos.",
    ["BUTTONS_LOCKED"] = "Botões TRAVADOS.",
    ["BUTTONS_UNLOCKED"] = "Botões DESTRAVADOS.",
    ["POSITION_RESET"] = "Posição dos botões resetada.",

    -- Tooltips - Mount
    ["TT_MOUNT_TITLE"] = "RandomCompanions - Montaria",
    ["TT_LEFT_MOUNT"] = "|cff00ff00Esquerdo:|r Invocar montaria aleatória",
    ["TT_RIGHT_MOUNT"] = "|cff00ff00Direito:|r Alternar Favoritas/Todas",
    ["TT_DRAG"] = "|cff00ff00Arrastar:|r Mover botão",
    ["TT_SELECTION"] = "Seleção:",
    ["TT_TYPE"] = "Tipo:",

    -- Tooltips - Pet
    ["TT_PET_TITLE"] = "RandomCompanions - Pet",
    ["TT_LEFT_PET"] = "|cff00ff00Esquerdo:|r Invocar pet aleatório",
    ["TT_RIGHT_PET"] = "|cff00ff00Direito:|r Alternar Favoritos/Todos",

    -- Tooltips - Minimap
    ["TT_MINIMAP_TITLE"] = "RandomCompanions",
    ["TT_MINIMAP_LEFT"] = "|cff00ff00Esquerdo:|r Abrir configurações",
    ["TT_MINIMAP_RIGHT"] = "|cff00ff00Direito:|r Mostrar/ocultar botões",

    -- Mode names
    ["MODE_FAVORITES"] = "Favoritas",
    ["MODE_ALL"] = "Todas",
    ["TYPE_ALL"] = "Todas",
    ["TYPE_GROUND"] = "Terrestres",
    ["TYPE_FLYING"] = "Voadoras",

    -- Options panel
    ["OPT_TITLE"] = "RandomCompanions",
    ["OPT_SUBTITLE"] = "Configurações de montarias e pets aleatórios",
    ["OPT_MOUNTS"] = "Montarias",
    ["OPT_PETS"] = "Pets",
    ["OPT_APPEARANCE"] = "Aparência",
    ["OPT_MINIMAP"] = "Minimapa",
    ["OPT_LANGUAGE"] = "Idioma",
    ["OPT_SELECTION_MODE"] = "Modo de seleção:",
    ["OPT_TYPE"] = "Tipo:",
    ["OPT_ONLY_FAVORITES"] = "Apenas Favoritas",
    ["OPT_ALL_MOUNTS"] = "Todas as Montarias",
    ["OPT_TYPE_ALL"] = "Todas (sem filtro)",
    ["OPT_TYPE_GROUND"] = "Apenas Terrestres",
    ["OPT_TYPE_FLYING"] = "Apenas Voadoras",
    ["OPT_ONLY_FAV_PETS"] = "Apenas Favoritos",
    ["OPT_ALL_PETS"] = "Todos os Pets",
    ["OPT_AUTOPET"] = "Invocar pet automaticamente ao entrar/relogar/instância",
    ["OPT_SHOW_BUTTONS"] = "Mostrar botões na tela",
    ["OPT_LOCK_BUTTONS"] = "Travar posição dos botões",
    ["OPT_BUTTON_SIZE"] = "Tamanho dos botões:",
    ["OPT_RESET_POS"] = "Resetar Posição",
    ["OPT_SHOW_MINIMAP"] = "Mostrar ícone no minimapa",
    ["OPT_LANG_EN"] = "English",
    ["OPT_LANG_PT"] = "Português",
    ["OPT_LANG_LABEL"] = "Idioma (requer /reload):",

    -- Slash help
    ["HELP_TITLE"] = "Comandos:",
    ["HELP_MOUNT"] = "  /rc mount - Invocar montaria",
    ["HELP_PET"] = "  /rc pet - Invocar pet",
    ["HELP_MF"] = "  /rc mf/ma - Montarias favoritas/todas",
    ["HELP_TYPE"] = "  /rc mg/mv/mt - Tipo: terrestres/voadoras/todas",
    ["HELP_PF"] = "  /rc pf/pa - Pets favoritos/todos",
    ["HELP_AUTOPET"] = "  /rc autopet on/off - Auto-pet",
    ["HELP_TOGGLE"] = "  /rc toggle - Mostrar/ocultar botões",
    ["HELP_LOCK"] = "  /rc lock - Travar/destravar botões",
    ["HELP_CONFIG"] = "  /rc config - Abrir configurações",
    ["HELP_RESET"] = "  /rc reset - Resetar posição",
}

-- Helper function to get localized string
function ns.Loc(key)
    local locale = GetAddonLocale()
    local strings = L[locale] or L["enUS"]
    return strings[key] or L["enUS"][key] or key
end
