﻿<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/OCH-Public/blob/master/LICENSE for license information.

#>

Function Global:Remove-AtwsInstalledProductType
{
  <#
      .SYNOPSIS
      This function deletes a InstalledProductType through the Autotask Web Services API.
      .DESCRIPTION
      This function deletes a InstalledProductType through the Autotask Web Services API.
      .EXAMPLE
      Remove-AtwsInstalledProductType [-ParameterName] [Parameter value]
      Use Get-Help Remove-AtwsInstalledProductType
      .NOTES
      NAME: Remove-AtwsInstalledProductType
  #>
	  [CmdLetBinding(DefaultParameterSetName='Input_Object')]
    Param
    (
                [Parameter(
          Mandatory = $True,
          ParameterSetName = 'Input_Object'
        )]
        [ValidateNotNullOrEmpty()]
        [Autotask.InstalledProductType]
        $InputObject
    )



          

  Begin
  { 
    If (-not($global:atws.Url))
    {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Run Connect-AutotaskWebAPI first.'
    }
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

  }   

  Process
  {   
  
    Remove-AtwsData -Entity $InputObject
 }   

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)

  }


        
}