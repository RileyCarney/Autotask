﻿<#

.COPYRIGHT
Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.

#>
Function Convert-AtwsDynamicFunctionToText {
     <#
      .SYNOPSIS

      .DESCRIPTION

      .INPUTS

      .OUTPUTS

      .EXAMPLE

      .NOTES
      NAME: 
      .LINK

  #>
    [CmdLetBinding()]
    Param
    (   
        [Parameter(Mandatory = $true)]
        [PSObject]
        $AtwsFunction
    )

    begin { 
 
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        
       # Value to insert in #Requires tag on top of every script file
        $requiredVersion = '4.0'

        # The current module version from the $My variable (initialized from the module manifest in autotask.psm1)
        $moduleVersion = $My.moduleVersion

        # The textframe with placeholders for all dynamic elements
        $textFrame = "#Requires -Version {0}`n#Version {1}`n{2}`nFunction {3}`n{{`n{4}`n  [CmdLetBinding(SupportsShouldProcess = `$true, DefaultParameterSetName='{5}', ConfirmImpact='{6}')]`n`n{7}`n}}"
    }
  
    process {
        # Generate the function text from $textframe with all placeholders replaced with the correct variable
        $functionText = $textFrame -F
        $requiredVersion,
        $moduleVersion,
        $AtwsFunction.Copyright,
        $AtwsFunction.FunctionName,
        $AtwsFunction.HelpText,
        $AtwsFunction.DefaultParameterSetName,
        $AtwsFunction.ConfirmImpact,
        $AtwsFunction.Definition
    }
  
    end {
        # return the function text
        Return $functionText
    }
}
