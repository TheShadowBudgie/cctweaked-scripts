PeripheralNames = peripheral.getNames()
SlateTypes = {}
--Custom Slate Objects
BlankSlate = { name = "bloodmagic:blankslate", inventoryslot = 2, lpcost = 1000, altarTier = 1, keepinstock = 64 };
ReinforcedSlate = { name = "bloodmagic:reinforcedslate", inventoryslot = 3, lpcost = BlankSlate.lpcost + 2000, altarTier = 2, keepinstock = 48 };
ImbuedSlate = { name = "bloodmagic:infusedslate", inventoryslot = 4, lpcost = ReinforcedSlate.lpcost + 5000, altarTier = 3, keepinstock = 32 };
DemonicSlate = { name = "bloodmagic:demonslate", inventoryslot = 5, lpcost = ImbuedSlate.lpcost + 15000, altarTier = 4, keepinstock = 16 };
EtherealSlate = { name = "bloodmagic:etherealslate", inventoryslot = 6, lpcost = DemonicSlate.lpcost + 30000, altarTier = 5, keepinstock = 8 }

--Function for processing the Stone into Slates
local function Slates(altar, storage, slate)
    --Checking for Stone in Storage Slot 1
    if (storage.getItemDetail(1) == nil or not(storage.getItemDetail(1).name == "minecraft:stone")) then
        term.setTextColor(colors.red)
        print("No Stone in Slot 1 available")
        term.setTextColor(colors.yellow)
        sleep(5)
    --Checking if enough Life Essence is Available
    elseif (altar.tanks()[1] == nil or (altar.tanks()[1].amount < slate.lpcost)) then
        term.setTextColor(colors.red)
        print("Not enough Life Essence available")
        term.setTextColor(colors.yellow)
        sleep(5)
    --Crafting Process of the Slate
    else
        if altar.getItemDetail(1) == nil and (storage.getItemDetail(slate.inventoryslot) == nil or storage.getItemDetail(slate.inventoryslot).count < slate.keepinstock) then
            SlateReady = false
            storage.pushItems(AltarSide, 1, 1, 1)
            while (SlateReady == false) do
                if altar.getItemDetail(1).name == slate.name then
                    SlateReady = true
                    storage.pullItems(AltarSide, 1, 1, slate.inventoryslot)
                end
            end
        end
    end
end

--Adding the Slate Objects to the SlateTypes table
table.insert(SlateTypes, BlankSlate)
table.insert(SlateTypes, ReinforcedSlate)
table.insert(SlateTypes, ImbuedSlate)
table.insert(SlateTypes, DemonicSlate)
table.insert(SlateTypes, EtherealSlate)

--Searching for the Altar and Storage, and adding them as peripherals
for index, side in ipairs(PeripheralNames) do
    local peripheralType = peripheral.getType(side)
    if peripheralType == "bloodmagic:altar" then
        Altar = peripheral.wrap(side)
        AltarSide = side
    elseif peripheralType == "minecraft:chest" or "ae2:interface" then
        Storage = peripheral.wrap(side)
        StorageSide = side
    end
end


term.setTextColor(colors.yellow)
print("Input your Altar Tier (1-5)") -- or 'cancel' to continue")
term.setTextColor(colors.lightBlue)
AltarTier = read()
term.setTextColor(colors.yellow)
print("Selected Altar Tier is " .. AltarTier)

repeat
    if AltarTier < "1" then
        term.setTextColor(colors.red)
        print("Please set an Altar Tier from 1 - 5")
        Loop = false
    end
    if AltarTier == "1" then
        while true do
            Slates(Altar, Storage, BlankSlate)
        end
    end
    if AltarTier == "2" then
        while true do
            Slates(Altar, Storage, BlankSlate)
            Slates(Altar, Storage, ReinforcedSlate)
        end
    end
    if AltarTier == "3" then
        while true do
            Slates(Altar, Storage, BlankSlate)
            Slates(Altar, Storage, ReinforcedSlate)
            Slates(Altar, Storage, ImbuedSlate)
        end
    end
    if AltarTier == "4" then
        Slates(Altar, Storage, BlankSlate)
        Slates(Altar, Storage, ReinforcedSlate)
        Slates(Altar, Storage, ImbuedSlate)
        Slates(Altar, Storage, DemonicSlate)
    end
    if AltarTier == "5" then
        Slates(Altar, Storage, BlankSlate)
        Slates(Altar, Storage, ReinforcedSlate)
        Slates(Altar, Storage, ImbuedSlate)
        Slates(Altar, Storage, DemonicSlate)
        Slates(Altar, Storage, EtherealSlate)
    end
    if AltarTier > "5" then
        term.setTextColor(colors.red)
        print("Please set an Altar Tier from 1 - 5")
        Loop = false
    end
until Loop == false
