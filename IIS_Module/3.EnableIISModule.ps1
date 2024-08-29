try {
    Invoke-Command -ComputerName 'Server' -ScriptBlock {
        # Import WebAdministration module
        Import-Module WebAdministration -ErrorAction Stop

        # Set module parameters
        $moduleName = "LoggingModule"

        # Check if the module exists
        $existingModule = Get-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/modules" -name "." | Where-Object { $_.Name -eq $moduleName }

        if ($existingModule) {
            $moduleIsActive = Get-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/modules" -name "." | 
            Where-Object { $_.Name -eq $moduleName -and $_.PreCondition -notlike "disabled*" }

            if (-not $moduleIsActive) {
                Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/modules/add[@name='$moduleName']" -name "preCondition" -value "managedHandler"
                Write-Output "Module $moduleName has been activated."
            }
            else {
                Write-Output "Module $moduleName is already active."
            }
        }
        else {
            Write-Output "Module $moduleName does not exist in the configuration."
        }
    }
}
catch {
    Write-Host "Error: [$($_.Exception.Message)]"
    Exit 1
}
