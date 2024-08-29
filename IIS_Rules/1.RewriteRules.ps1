try {
    Invoke-Command -ComputerName 'Server' -ScriptBlock {
        # Import WebAdministration module
        Import-Module WebAdministration

        # List of applications/systems hosted on IIS
        $apps = @(
            "app1",
            "app2"
        )

        foreach ($fromApp in $apps) {
            foreach ($toApp in $apps) {
                if ($fromApp -ne $toApp) {
                    $ruleName = "AddCustomHeaders_${fromApp}_to_${toApp}"
            
                    # Check if the rule already exists
                    $existingRule = Get-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/rewrite/globalRules/rule[@name='$ruleName']" -name "."

                    if (-not $existingRule) {
                        # Add global rule
                        Add-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/rewrite/globalRules" -name "." -value @{name = $ruleName; enabled = "true" }
                
                        # Configure URL matching
                        Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/rewrite/globalRules/rule[@name='$ruleName']" -name "match" -value @{url = ".*" }
                
                        # Ignore case
                        Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/rewrite/globalRules/rule[@name='$ruleName']/match" -name "ignoreCase" -value "true"
                    }
                }

                # Add server variables for headers if they don't already exist
                $existingFromHeader = Get-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/rewrite/globalRules/rule[@name='$ruleName']/serverVariables/add[@name='X-From-App']" -name "."
                if (-not $existingFromHeader) {
                    Add-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/rewrite/globalRules/rule[@name='$ruleName']/serverVariables" -name "." -value @{name = "X-From-App"; value = $fromApp }
                }

                $existingToHeader = Get-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/rewrite/globalRules/rule[@name='$ruleName']/serverVariables/add[@name='X-To-App']" -name "."
                if (-not $existingToHeader) {
                    Add-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/rewrite/globalRules/rule[@name='$ruleName']/serverVariables" -name "." -value @{name = "X-To-App"; value = $toApp }
                }
            
                # Configure the action to do nothing
                Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/rewrite/globalRules/rule[@name='$ruleName']/action" -name "type" -value "None"
            }
        }
    }
}
catch {
    Write-Host "[$($_.Exception.Message)]"
    Exit 1
}
