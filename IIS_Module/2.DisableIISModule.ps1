try {
    Invoke-Command -ComputerName 'Server' -ScriptBlock {
        # Import WebAdministration module
        Import-Module WebAdministration -ErrorAction Stop

        # Set module parameters
        $moduleName = "LoggingModule"

        # Check if the module exists
        $existingModule = Get-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/modules" -name "." | Where-Object { $_.Name -eq $moduleName }

        if ($existingModule) {
            # Check if the module is already disabled
            $moduleIsDisabled = Get-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/modules" -name "." | 
            Where-Object { $_.Name -eq $moduleName -and $_.PreCondition -like "disabled*" }

            if (-not $moduleIsDisabled) {
                Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/modules/add[@name='$moduleName']" -name "preCondition" -value "disabledManagedHandler"
                Write-Output "Module $moduleName has been disabled."
            }
            else {
                Write-Output "Module $moduleName is already disabled."
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
