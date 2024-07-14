loadstring(game:HttpGet("https://raw.githubusercontent.com/Drop56796/Andazx/main/UI%20Lib.lua"))()

local window1 = UILib:CreateWindow("win")
local tab1 = window1:Tab("Tab 1")

UILib:CreateTextBox(tab1, "text", function(text) 
print("TextBox 1: " .. text) 
end)

UILib:CreateButton(tab1, "Click me", function() 
print("a") 
end)

UILib:CreateToggle(tab1, "toggle", function(state)
    if state then
        print("Toggle 1 open")
    else
        print("Toggle 1 close")
    end
end)

UILib:CreateSlider(tab1, 5, 0, 100, function(v)
print(v)
end)
