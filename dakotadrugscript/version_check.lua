-------------------------------------------------------------
-- dakota-drugs Version Checker - Made by DakotaScripts --------------
-------------------------------------------------------------
----------------------------------------------------------------------------------------------
                  -- !WARNING! !WARNING! !WARNING! !WARNING! !WARNING! --
        -- DO NOT TOUCH THIS FILE OR YOU /WILL/ BREAK THE SCRIPT! --
----------------------------------------------------------------------------------------------

local label = 
[[ 
  //
  || 
  ||
  ||    __  __ ____   ____             ____                 
  ||   |  \/  |  _ \ |  _ \ ___  ___  |  _ \  ___  ___ ___  
  ||   | |\/| | | | || |_) / _ \/ __| | | | |/ _ \/ __/ __| 
  ||   | |  | | |_| ||  __/ (_) \__ \ | |_| |  __/\__ \__ \ 
  ||   |_|  |_|____/ |_|   \___/|___/ |____/ \___||___/___/ 
  ||                                                        
  ||
  ||                      -dakotaDrugs
  ||]]

Citizen.CreateThread(function()
    local CurrentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
    if not CurrentVersion then
        print('^1md-drugs Version Check Failed!^7')
        return
    end

    local function VersionCheckHTTPRequest()
        PerformHttpRequest('https://github.com/DakotaOhItxScripts/dakotaDrugs', VersionCheck, 'GET')
    end

    local function VersionCheck(err, response, headers)
        Citizen.Wait(3000)
        if err == 200 then
            local Data = json.decode(response)
            if not Data or not Data.NewestVersion then
                print(label)
                print('  ||    ^1Invalid version data received from server.^7\n  ||\n  \\\\\n')
                return
            end

            if CurrentVersion ~= Data.NewestVersion then
                print(label)
                print('  ||    \n  ||    Dakota-drugs is outdated!')
                print('  ||    Current version: ^2' .. Data.NewestVersion .. '^7')
                print('  ||    Your version: ^1' .. CurrentVersion .. '^7')
                print('  ||    Please download the latest version from ^5' .. Data.DownloadLocation .. '^7https://github.com/DakotaOhItxScripts/dakotaDrugs')
                if Data.Changes and Data.Changes ~= '' then
                    print('  ||    \n  ||    ^5Changes: ^7' .. Data.Changes .. "\n^0  \\\\\n")
                end
            else
                print(label)
                print('  ||    ^2Dakota-drugs is up to date!\n^0  ||\n  \\\\\n')
            end
        else
            print(label)
            print('  ||    ^1Error fetching version info. Check your internet or GitHub URL.^7\n  ||\n  \\\\\n')
        end

        -- Recheck every 1 hour (3600000 ms), change as needed
        SetTimeout(3600000, VersionCheckHTTPRequest)
    end

    VersionCheckHTTPRequest()
end)

