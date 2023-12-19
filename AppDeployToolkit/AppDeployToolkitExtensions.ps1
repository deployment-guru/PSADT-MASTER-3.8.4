<#
.SYNOPSIS
	This script is a template that allows you to extend the toolkit with your own custom functions.
    # LICENSE #
    PowerShell App Deployment Toolkit - Provides a set of functions to perform common application deployment tasks on Windows.
    Copyright (C) 2017 - Sean Lillis, Dan Cunningham, Muhammad Mashwani, Aman Motazedian.
    This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
    You should have received a copy of the GNU Lesser General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
.DESCRIPTION
	The script is automatically dot-sourced by the AppDeployToolkitMain.ps1 script.
.NOTES
    Toolkit Exit Code Ranges:
    60000 - 68999: Reserved for built-in exit codes in Deploy-Application.ps1, Deploy-Application.exe, and AppDeployToolkitMain.ps1
    69000 - 69999: Recommended for user customized exit codes in Deploy-Application.ps1
    70000 - 79999: Recommended for user customized exit codes in AppDeployToolkitExtensions.ps1
.LINK
	http://psappdeploytoolkit.com
#>
[CmdletBinding()]
Param (
)

##*===============================================
##* VARIABLE DECLARATION
##*===============================================

# Variables: Script
[string]$appDeployToolkitExtName = 'PSAppDeployToolkitExt'
[string]$appDeployExtScriptFriendlyName = 'App Deploy Toolkit Extensions'
[version]$appDeployExtScriptVersion = [version]'3.8.4'
[string]$appDeployExtScriptDate = '26/01/2021'
[hashtable]$appDeployExtScriptParameters = $PSBoundParameters

##*===============================================
##* FUNCTION LISTINGS
##*===============================================

function Set-SCCMAppDetectRegistryKey {
    <#
    .SYNOPSIS
    This Function Record a Value in the registry that can be used for Application Detection in SCCM
    .EXAMPLE
    Set-SCCMAppDetectRegistryKey -AppName 'Application' -Value '1'
    .PARAMETER AppName
    Application Name
    .PARAMETER Value
    Value of Registry Entry
    #>
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $AppDeployReg,
        [Parameter(Mandatory=$true)]
        [string]
        $AppName,
        [Parameter(Mandatory=$true)]
        [string]
        $Value
    )
    if ($PSBoundParameters['AppDeployReg']) {
        $AppDeployReg = $AppDeployReg
    }
    else {
        $AppDeployReg = "HKLM:\SOFTWARE\PSADT\Application Detection"
    }

    if (!(Test-Path $AppDeployReg)) {
        New-Item $AppDeployReg -Force | Out-Null
        Write-Log "Create $AppDeployReg"
    }

    New-ItemProperty $AppDeployReg -Name $AppName -Value $Value -Force | Out-Null
    Write-Log "Create $AppDeployReg\$AppName with a value of $Value"
}

function Remove-SCCMAppDetectRegistryKey {
    <#
    .SYNOPSIS
    This Function Remove a Value in the registry that can be used for Application Detection in SCCM
    .EXAMPLE
    Remove-SCCMAppDetectRegistryKey -AppName 'Application'
    .PARAMETER AppName
    Application Name
    #>
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $AppDeployReg,
        [Parameter(Mandatory=$true)]
        [string]
        $AppName
    )
    if ($PSBoundParameters['AppDeployReg']) {
        $AppDeployReg = $AppDeployReg
    }
    else {
        $AppDeployReg = "HKLM:\SOFTWARE\PSADT\Application Detection"
    }
    Remove-ItemProperty $AppDeployReg -Name $AppName -Force | Out-Null
    Write-Log "Remove $AppDeployReg\$AppName"
}

##*===============================================
##* END FUNCTION LISTINGS
##*===============================================

##*===============================================
##* SCRIPT BODY
##*===============================================

If ($scriptParentPath) {
	Write-Log -Message "Script [$($MyInvocation.MyCommand.Definition)] dot-source invoked by [$(((Get-Variable -Name MyInvocation).Value).ScriptName)]" -Source $appDeployToolkitExtName
} Else {
	Write-Log -Message "Script [$($MyInvocation.MyCommand.Definition)] invoked directly" -Source $appDeployToolkitExtName
}

##*===============================================
##* END SCRIPT BODY
##*===============================================
