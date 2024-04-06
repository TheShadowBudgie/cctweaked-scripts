--start
term.clear()
term.setTextColor(colors.yellow)
print("Initializing Program")
print("Initializing Variables")
local pcSides = redstone.getSides --get all six sides
local blockAir = "none"
local blockFire = "minecraft:fire"

--checking for BlockReader Peripheral
local periphReader = peripheral.find("blockReader")
if not (periphReader == nil) then
    term.setTextColor(colors.cyan)
    print("BlockReader found")
    print(periphReader.getBlockName())
    term.setTextColor(colors.yellow)
end

--disable redstoneoutput on all sides
for tableKey,tableValue in ipairs(pcSides())do
    redstone.setOutput(tableValue, false)
end
term.setTextColor(colors.green)
print()
print("Initializing Done")
print()

--body
--Select Redstone Output Side
term.setTextColor(colors.yellow)
print("Please select one of the following sides, where you want to output the redstone signal")
print()
term.setTextColor(colors.cyan)
for tableKey,tableValue in ipairs(pcSides())do
    print(tableValue)
end
print()
term.setTextColor(colors.green)
local rsSide = read()
print("Selected Side is " .. rsSide)
term.setTextColor(colors.yellow)
print()

--Select Inventory Side
term.setTextColor(colors.yellow)
print("Please select the side of the attached inventory")
print()
--table.remove(pcSides(), rsSide)
term.setTextColor(colors.cyan)

for tableKey,tableValue in ipairs(pcSides())do
    if tableValue == rsSide then
        term.setTextColor(colors.red)
        print(tableValue .. " - Redstoneoutput")
        term.setTextColor(colors.cyan)
        else
            print(tableValue)
    end

end
print()
term.setTextColor(colors.green)
local invSide = read()
print("Selected Side is " .. invSide)
term.setTextColor(colors.yellow)

redstone.setOutput(rsSide, true)

while true do
    if periphReader == nil then
        term.setTextColor(colors.red)
        print("Please place a BlockReader on any adjectant side")
        term.setTextColor(colors.yellow)
        break
    else
        local inv = peripheral.wrap(invSide)
        local itemCount = 0
        local itemTotal = 0

        for i = 1, inv.size() do
            itemTotal = itemTotal + inv.getItemLimit(i)
        end

        for slot, item in pairs(inv.list())do
            itemCount = item.count
        end

        local detectedBlock = periphReader.getBlockName()

        if itemCount==itemTotal then
            sleep(10)
            
        elseif detectedBlock == blockAir then
            redstone.setOutput(rsSide, false)
            sleep(0.5)
            redstone.setOutput(rsSide, true)
        end
    end
    sleep(5)
end