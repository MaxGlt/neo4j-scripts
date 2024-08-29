try {
    Invoke-Command -ComputerName 'Server' -ScriptBlock {
        # Import WebAdministration module
        Import-Module WebAdministration

        # Completely dump global rewrite rules
        try {
            Clear-WebConfiguration -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/rewrite/globalRules"
            Write-Output "All global rewrite rules have been cleared."
        }
        catch {
            Write-Output "Failed to clear global rewrite rules. Error: $_"
        }
    }
}
catch {
    Write-Host "[$($_.Exception.Message)]"
    Exit 1
}
