﻿<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Remove-HolidaySet
{


<#
.SYNOPSIS
This function deletes a HolidaySet through the Autotask Web Services API.
.DESCRIPTION
This function deletes a HolidaySet through the Autotask Web Services API.

Entities that have fields that refer to the base entity of this CmdLet:

Holiday
 BusinessLocation

.INPUTS
[Autotask.HolidaySet[]]. This function takes objects as input. Pipeline is supported.
.OUTPUTS
Nothing. This fuction just deletes the Autotask.HolidaySet that was passed to the function.
.EXAMPLE
Remove-HolidaySet  [-ParameterName] [Parameter value]

.LINK
New-HolidaySet
 .LINK
Get-HolidaySet
 .LINK
Set-HolidaySet

#>

  [CmdLetBinding(DefaultParameterSetName='Input_Object', ConfirmImpact='Low')]
  Param
  (
# Any objects that should be deleted
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.HolidaySet[]]
    $InputObject,

# The unique id of an object to delete
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.HolidaySet[]]
    $Id
  )
 
  Begin
  { 
    $EntityName = 'HolidaySet'
    
    Write-Verbose ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

  }

  Process
  {
    If ($Id.Count -gt 0)
    {
      $Filter = 'id -eq {0}' -F ($Id -join ' -or id -eq ')
      $InputObject = Get-AtwsData -Entity $EntityName -Filter $Filter
    }

    If ($InputObject)
    { 
      Remove-AtwsData -Entity $InputObject
    }
  }

  End
  {
    Write-Verbose ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
  }


}
