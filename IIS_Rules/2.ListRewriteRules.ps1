try {
    Invoke-Command -ComputerName 'Server' -ScriptBlock {
        # Import WebAdministration module
        Import-Module WebAdministration

        # Retrieve all global rewrite rules
        $globalRules = Get-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/rewrite/globalRules/rule" -name "."

        # Create list to store rule details
        $rulesList = @()

        # Browse each rule and retrieve details
        foreach ($rule in $globalRules) {
            $ruleName = $rule.GetAttributeValue("name")
            $enabled = $rule.GetAttributeValue("enabled")
            $matchUrl = $rule.ChildElements["match"].GetAttributeValue("url")
            $ignoreCase = $rule.ChildElements["match"].GetAttributeValue("ignoreCase")
            $serverVariables = $rule.ChildElements["serverVariables"].Collection

            # Create object to store the rule information
            $ruleDetails = New-Object PSObject -Property @{
                Name            = $ruleName
                Enabled         = $enabled
                MatchUrl        = $matchUrl
                IgnoreCase      = $ignoreCase
                ServerVariables = @()
            }

            # Loop through server variables and add headers to rule object
            foreach ($variable in $serverVariables) {
                $variableName = $variable.GetAttributeValue("name")
                $variableValue = $variable.GetAttributeValue("value")

                $ruleDetails.ServerVariables += @{ Name = $variableName; Value = $variableValue }
            }

            # Add rule object to the list
            $rulesList += $ruleDetails
        }

        # Show rules
        $rulesList | Format-Table -Property Name, Enabled, MatchUrl, IgnoreCase

        # Show server variable details for each rule
        foreach ($rule in $rulesList) {
            Write-Output "`nRule: $($rule.Name)"
            Write-Output "Server Variables:"
            $rule.ServerVariables | Format-Table -Property Name, Value
        }
    }
}
catch {
    Write-Host "[$($_.Exception.Message)]"
    Exit 1
}
