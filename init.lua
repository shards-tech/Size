-- Services --
local RunService = game:GetService("RunService")

-- Types --
type ScriptTypes = Script | LocalScript | ModuleScript
type UnitTypes = "bytes" | "KB" | "MB" | "GB"
type Sizeable = {
    Bytes: number, -- As bytes
    Convert: {
        Absolute: string,
        Rounded: string,
        Unit: UnitTypes
    }
}

-- Module --

--[=[
    Define the Size class
]=]
local Size = {
    ScriptTypes = {"Script", "LocalScript", "ModuleScript"}
}

function Size.convertBytes(bytes: number): (number, UnitTypes)
    assert(typeof(bytes) == "number", "Bytes must be a number!")
    if bytes >= 1024 * 1024 * 1024 then
        return bytes / (1024 * 1024 * 1024), "GB"
    elseif bytes >= 1024 * 1024 then
        return bytes / (1024 * 1024), "MB"
    elseif bytes >= 1024 then
        return bytes / 1024, "KB"
    else
        return bytes, "bytes"
    end
end
--[=[
    Calculate the sizes scripts on Folder or Instance.
]=]
function Size.at(Instance: Instance): Sizeable
    local Descendants = Instance:GetDescendants()
    local Bytes = 0

    for _, descendant in ipairs(Descendants) do
        if descendant:IsA("Script") or descendant:IsA("LocalScript") or descendant:IsA("ModuleScript") then
            if descendant:IsA("Script") and RunService:IsClient() then
                error("Prohibited reading ServerScript from the client side.")
            end
            
            Bytes += #descendant.Source
        end
    end

    local Absolute, Unit = Size.convertBytes(Bytes)

    return {
        Bytes = Bytes,
        Convert = {
            Absolute = tostring(Absolute),
            Rounded = string.format("%.2f", Absolute),
            Unit = Unit :: UnitTypes
        }
    }
end

--[=[
    Calculate the sizes of the Script given.

    ---
    Example:

    ```lua
    local SignalSize = Size.from(Packages.Signal)
    
    print(SignalSize.Convert.Rounded, SignalSize.Convert.Unit)
    ```
]=]
function Size.from(Script: ScriptTypes): Sizeable
    assert(table.find(Size.ScriptTypes, typeof(Script)), "Script must be a ScriptType!")
    if typeof(Script) == "Script" and RunService:IsClient() then
        error("Prohibited reading ServerScript from the client side.")
    end

    local Source = Script.Source
    local Bytes = #Source
    local Absolute, Unit = Size.convertBytes(Bytes)

    return {
        Bytes = Bytes,
        Convert = {
            Absolute = tostring(Absolute),
            Rounded = string.format("%.2f", Absolute),
            Unit = Unit :: UnitTypes
        }
    }
end

return Size