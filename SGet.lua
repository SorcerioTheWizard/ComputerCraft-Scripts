-- Sorcerio's Comptuer Craft Script Installer
-- A utility script for installing and updating Computer Craft scripts.

-- TODO: support custom names for installed scripts

-- MARK: Constants
local PROG_NAME = "sget"

local ACTION_INSTALL = "install"
local ACTION_UPDATE = "update"
local ACTION_UPGRADE = "upgrade"
local ACTION_LIST = "list"

local PROG_REGISTRY_LINK = "https://raw.githubusercontent.com/SorcerioTheWizard/ComputerCraft-Scripts/master/sgetRegistry.json"
local PROG_REGISTRY = nil

-- MARK: Functions
-- Fetches the script registry from the remote url.
function fetchRegistry()
    -- Check if the registry is already fetched
    if PROG_REGISTRY then
        return
    end

    -- Check if the url is accessible
    if not http.checkURL(PROG_REGISTRY_LINK) then
        error("Could not connect to the script registry.\nThe URL may not be whitelisted on this Minecraft server: " .. PROG_REGISTRY_LINK)
        return
    end

    -- Fetch the registry
    local resp = http.get(PROG_REGISTRY_LINK)

    if not resp then
        error("Failed to fetch the script registry.")
        return
    elseif resp.getResponseCode() ~= 200 then
        error("Failed to fetch the script registry. Response code: " .. resp.getResponseCode())
        return
    end

    -- Parse the registry
    PROG_REGISTRY = textutils.unserializeJSON(resp.readAll())
    resp.close()

    -- Check if the registry is valid
    if not PROG_REGISTRY then
        error("Failed to parse the script registry.")
    else
        print("Fetched the script registry.")
    end
end

-- Prints the script registry in a tabulated format.
function tabulateRegistry()
    -- Fetch the registry
    fetchRegistry()

    -- Build the display table
    local displayStr = ""
    for scriptName, scriptData in pairs(PROG_REGISTRY["progs"]) do
        -- Add the row data
        displayStr = (displayStr .. "\n" .. scriptName .. ":\n" .. scriptData["desc"] .. "\n")
    end

    -- Print the registry
    print("\nAvailable scripts:")
    textutils.pagedPrint(displayStr, 5)
end

-- Checks if the specified script is in the script registry.
-- Fetches the registry if it is not already fetched.
-- scriptName: The name of the script to check.
-- Returns true if the script is in the registry, false otherwise.
function isScriptInRegistry(scriptName)
    -- Fetch the registry
    fetchRegistry()

    -- Check if the script is in the registry
    if not PROG_REGISTRY["progs"][scriptName] then
        return false
    end

    return true
end

-- Installs the specified script if it is within the script registry.
-- scriptName: The name of the script to install.
function installScript(scriptName)
    -- Check if the script is not in the registry
    if not isScriptInRegistry(scriptName) then
        print("Script not found in the registry: " .. scriptName)
        print("Try running '" .. PROG_NAME .. " " .. ACTION_LIST .. "' to see all available scripts and their function.")
        return
    end

    -- Get the url of the script
    local scriptUrl = PROG_REGISTRY["progs"][scriptName]["url"]

    -- Fetch the script
    local resp = http.get(scriptUrl)

    if not resp then
        print("Failed to fetch " .. scriptName .. ".")
        return
    elseif resp.getResponseCode() ~= 200 then
        print("Failed to fetch " .. scriptName .. ". Response code: " .. resp.getResponseCode())
        return
    end

    -- Save the script and close
    local scriptFile = fs.open(scriptName, "w")
    scriptFile.write(resp.readAll())

    scriptFile.close()
    resp.close()

    -- Report
    print("Installed " .. scriptName .. ".")
end

-- Installs the specified script if it is already installed and within the script registry.
-- scriptName: The name of the script to install.
function updateScript(scriptName)
    -- Check if the script is not in the registry
    if not isScriptInRegistry(scriptName) then
        print("Script not found in the registry: " .. scriptName)
        print("Try running '" .. PROG_NAME .. " " .. ACTION_LIST .. "' to see all available scripts and their function.")
        return
    end

    -- Check if the script is installed
    local installedScripts = shell.programs()
    if not installedScripts[scriptName] then
        print(scriptName .. "is not installed.")
        print("Try running '" .. PROG_NAME .. " " .. ACTION_INSTALL .. " " .. scriptName .. "' to install it.")
        return
    end

    -- Remove the script
    fs.delete(scriptName)

    -- Install the script
    installScript(scriptName)
end

-- Function to handle command line arguments.
-- action: The action to perform as a string.
-- ...: The arguments for the action.
function handleCli(action, ...)
    -- Check if action is provided
    if not action then
        print("Usage: " .. PROG_NAME .. " <action> <scriptName>")
        print("Actions:")
        print("  " .. ACTION_INSTALL .. " <scriptName> - Install a script")
        print("  " .. ACTION_UPDATE .. " <scriptName> - Update a script")
        -- print("  " .. ACTION_UPGRADE .. " - Upgrade SGet to the latest version")
        print("  " .. ACTION_LIST .. " - List all available scripts")
        return
    end

    -- Lowercase the action
    action = string.lower(action)

    -- Make arguments a table
    local args = {...}

    -- Perform action based on the provided command line arguments
    if (action == ACTION_INSTALL) or (action == ACTION_UPDATE) then
        -- Extract the script name
        local scriptName = args[1]
        if not scriptName then
            print("Usage: " .. PROG_NAME .. " " .. action .. " <scriptName>")
            return
        end

        -- Call the appropriate action
        if action == ACTION_INSTALL then
            -- Install the script
            installScript(scriptName)
        elseif action == ACTION_UPDATE then
            -- Update the script
            updateScript(scriptName)
        end
    -- elseif action == ACTION_UPGRADE then
    --     -- Upgrade action
    --     -- TODO: How do you even do this since this script is running?
    elseif action == ACTION_LIST then
        -- List action
        tabulateRegistry()
    else
        print("Invalid action:", action)
    end
end

-- MARK: Execution
-- Get command line arguments
local args = {...}
local action = args[1]

-- Execute on arguments
handleCli(action, select(2, ...))
