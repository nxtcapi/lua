task.spawn(function()
    while task.wait() do
        pcall(function()
            for i,v in next, getconnections(game:GetService("Players").LocalPlayer.Character.Humanoid.Changed) do v:Disable() end
            for i,v in next, getconnections(game:GetService("Players").LocalPlayer.Character.DescendantAdded) do v:Disable() end
            for i,v in next, getconnections(game:GetService("Players").LocalPlayer.PlayerGui.ChildAdded) do v:Disable() end
        end)
    end
end)
