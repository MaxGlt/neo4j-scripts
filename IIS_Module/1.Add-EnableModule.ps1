try {
    Invoke-Command -ComputerName 'Server' -ScriptBlock {
        # Import WebAdministration module
        Import-Module WebAdministration -ErrorAction Stop

        # Set module parameters
        $moduleName = "LoggingModule"
        $moduleType = "Neo4jLoggingModule.LoggingModule, Neo4jLoggingModule"

        # Check if the module is already added
        $existingModule = Get-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/modules" -name "." | Where-Object { $_.Name -eq $moduleName }

        if (-not $existingModule) {
            # Add IIS module with option for ASP.NET only
            Add-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/modules" -name "." -value @{
                name         = $moduleName; 
                type         = $moduleType; 
                preCondition = "managedHandler"
            }
            Write-Output "Module $moduleName has been added."
        }
        else {
            Write-Output "Module $moduleName is already added."
        }
    }
}
catch {
    Write-Host "Error: [$($_.Exception.Message)]"
    Exit 1
}
