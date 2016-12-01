﻿<#
.Synopsis
   Sets the API key
.DESCRIPTION
   Sets the API key, and optionally saves it
.EXAMPLE
   Set-SDPAPIKey -Save
#>
function Set-SDPAPIKey
{
    [CmdletBinding()]
    [Alias()]
    Param
    (
        # Whether or not to save the API key to the disk
        [Parameter()]
        [switch]
        $Save
    )

    Process
    {
        Write-Verbose "SDPAPIKey is $SDPAPIKey"

        # Prompt the user for the API key
        $script:SDPAPIKey = Read-Host -Prompt "Please provide ServiceDeskPlus API key" -AsSecureString

        Write-Verbose "SDPAPIKey is $SDPAPIKey"

        # Optionally save the API key to disk
        if ($save)
        {
            # Check for a configuration folder
            if (!(Test-Path -Path $ConfigRoot))
            {
                # Configuration folder does not exist, try to create it
                try
                {
                    New-Item -Path $ConfigRoot -ItemType Directory -ErrorAction Stop
                }
                catch
                {
                    throw "Failed to create configuration directory: $_"
                }
            }

            # Update the configuration file
            try
            {
                $SDPAPIKey | Export-Clixml -Path "$ConfigRoot\PSServiceDeskPlus-SDPAPIKey.xml" -Force -ErrorAction Stop
            }
            catch
            {
                throw "Failed to update the configuration file: $_"
            }
        }
    }
}