# ✨ Size

Returns the size of dependencies or scripts on a Folder or Instance.

Install using wally: 

```toml
Size = "shards-tech/size@0.1.0"
```

## 📃 Documentation

Types:
```lua
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
```

1. Using `Size.from(Script: ScriptTypes)` returns `Sizeable`

For example:

```lua
local SignalSize = Size.from(script.Parent.Signal)

print(SignalSize.Rounded, SignalSize.Unit) --> 15.59 KB
```

2. Using `Size.at(Instance: Instance)` returns `Sizeable`

For example:

```lua
local InstanceSize = Size.at(script.Parent.Packages)

print(InstanceSize.Convert.Rounded, InstanceSize.Convert.Unit) --> 15.98712 mb
```

3. Using `Size.convertBytes(bytes: number)` returns `(number, UnitTypes)`

For example:

```lua
local SignalSize, Unit = Size.convertBytes(#script.Parent.Signal.Source)

print(SignalSize, Unit) --> 15.5981 KB
```
