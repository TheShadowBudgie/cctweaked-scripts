-----------------------------------------------------------------------------
--                                 Functions                               --
-----------------------------------------------------------------------------
local function saveFile(filePath, fileData)
	if fs.exists(filePath) then
		fs.delete(filePath)
	end

	local f = fs.open(filePath, "w")
	f.write(fileData)
	f.close()
end


local function downloadFile(filePath)
	local url = git.."/"..filePath
	print("downloading", filePath)

	local file = http.get(url)
	local fileData = file.readAll()
	return fileData
end
-----------------------------------------------------------------------------
--                                 Variables                               --
-----------------------------------------------------------------------------
CId = os.getComputerID()
CLabel = os.getComputerLabel



if (CLabel == nil) then
    if (CId < 9) then
        CLabel = "shadow-pc-00" .. CId
    elseif (CId < 99) then
        CLabel = "shadow-pc-0" .. CId
    else
        CLabel = "shadow-pc-" .. CId
    end
    os.setComputerLabel(CLabel)
end

-- installation using github for the host computer

local git = "https://raw.githubusercontent.com/TheShadowBudgie/cctweaked-scripts/refs/heads/main"


local files, folders

local allFolders = {
	["BloodMagic"] = { 
		name = "BloodMagic",
		files = {
            --"File.lua",
			"SlateAutomation.lua",
		}
	},
	["EnderIO"] = { 
		name = "EnderIO",
		files = {
			--"ExampleFile.lua",
			"grainsofinfinity.lua",
		}
	},
}

if not (turtle) then
    	-- host computer
	files = {
		--"startup.lua"
	}
	folders = allFolders
else
    --[[ download turtle files, will be updated by host anyways
	files = {
		-- "turtle/startup.lua",
	}
	folders = {
		["turtle"] = {
		name = "turtle",
		files = {
			"startup.lua",
			"update.lua",
			}
		}
		,
		["general"] = {
		name = "general",
		files = {
			"bluenet.lua",
			"classBluenetNode.lua",
			"classList.lua",
			}
		}
	}]]
end



-- download folders
for _,folder in pairs(folders) do
	print("downloading folder", folder.name)
	if not fs.exists(folder.name) then
		fs.makeDir(folder.name)
	end
	
	for _,fileName in pairs(folder.files) do
		local filePath = folder.name.."/"..fileName
		local data = downloadFile(filePath)
		if turtle then
			if fileName == "startup.lua" then
				saveFile(fileName, data) -- save to root folder
			else
				saveFile("runtime/"..fileName, data)
			end
		else
			saveFile(filePath, data)
		end
	end
end

-- download single files
for _,fileName in pairs(files) do
	local data = downloadFile(fileName)
	saveFile(fileName, data)
end


os.reboot()