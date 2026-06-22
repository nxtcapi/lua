local rs = cloneref(game:GetService("ReplicatedStorage"))
local plrs = cloneref(game:GetService("Players"))
local lp = plrs.LocalPlayer

local canvas
for _, plot in workspace.AllAlbumCanvases:GetChildren() do
    if plot:GetAttribute("Owner") == lp.UserId then
        canvas = plot
        break
    end
end

local controller
for _, obj in getgc(true) do
    if type(obj) == "table" and rawget(obj, "pixelMap") and rawget(obj, "stateMap") then
        controller = obj
        break
    end
end

for index, color3 in controller.palette do
    local unpainted = {}
    for pixel = 0, 129599 do
        if buffer.readu8(controller.stateMap, pixel) == 0 and buffer.readu8(controller.pixelMap, pixel) == index then
            table.insert(unpainted, pixel)
        end
    end
    
    if #unpainted > 0 then
        for start_idx = 1, #unpainted, 1500 do
            local batch = {}
            for i = start_idx, math.min(start_idx + 1499, #unpainted) do
                table.insert(batch, unpainted[i])
            end
            rs.PaintTileEvent:FireServer(canvas, batch, color3, index)
            controller:syncPaintStroke(batch, color3)
            task.wait(0.05)
        end
    end
end
