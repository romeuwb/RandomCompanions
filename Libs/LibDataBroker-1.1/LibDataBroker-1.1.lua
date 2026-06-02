-- LibDataBroker-1.1 (minimal embedded version)
-- License: Public Domain

local MAJOR, MINOR = "LibDataBroker-1.1", 4
local lib = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

lib.callbacks = lib.callbacks or LibStub("CallbackHandler-1.0"):New(lib)
lib.attributestorage = lib.attributestorage or {}
lib.namestorage = lib.namestorage or {}
lib.proxystorage = lib.proxystorage or {}

local attributestorage = lib.attributestorage
local namestorage = lib.namestorage
local proxystorage = lib.proxystorage
local callbacks = lib.callbacks

function lib:NewDataObject(name, dataobj)
    if proxystorage[name] then return end

    if dataobj then
        assert(type(dataobj) == "table", "Invalid dataobj")
    end

    local dataobj = dataobj or {}
    attributestorage[name] = {}

    for k, v in pairs(dataobj) do
        attributestorage[name][k] = v
    end

    local proxy = setmetatable({}, {
        __index = function(self, key)
            return attributestorage[name][key]
        end,
        __newindex = function(self, key, value)
            attributestorage[name][key] = value
            callbacks:Fire("LibDataBroker_AttributeChanged_" .. name .. "_" .. key, name, key, value, self)
            callbacks:Fire("LibDataBroker_AttributeChanged__" .. key, name, key, value, self)
            callbacks:Fire("LibDataBroker_AttributeChanged", name, key, value, self)
        end,
    })

    proxystorage[name] = proxy
    namestorage[name] = name
    callbacks:Fire("LibDataBroker_DataObjectCreated", name, proxy)
    return proxy
end

function lib:DataObjectIterator()
    return pairs(proxystorage)
end

function lib:GetDataObjectByName(name)
    return proxystorage[name]
end

function lib:GetNameByDataObject(dataobj)
    for name, proxy in pairs(proxystorage) do
        if proxy == dataobj then return name end
    end
end
