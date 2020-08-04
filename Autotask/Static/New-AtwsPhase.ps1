﻿#Requires -Version 4.0
#Version 1.6.9
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function New-AtwsPhase
{


<#
.SYNOPSIS
This function creates a new Phase through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.Phase] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the Phase with Id number 0 you could write 'New-AtwsPhase -Id 0' or you could write 'New-AtwsPhase -Filter {Id -eq 0}.

'New-AtwsPhase -Id 0,4' could be written as 'New-AtwsPhase -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new Phase you need the following required fields:
 -ProjectID
 -Title

Entities that have fields that refer to the base entity of this CmdLet:

Phase
 Task

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.Phase]. This function outputs the Autotask.Phase that was created by the API.
.EXAMPLE
$result = New-AtwsPhase -ProjectID [Value] -Title [Value]
Creates a new [Autotask.Phase] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsPhase -Id 124 | New-AtwsPhase 
Copies [Autotask.Phase] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsPhase -Id 124 | New-AtwsPhase | Set-AtwsPhase -ParameterName <Parameter Value>
Copies [Autotask.Phase] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsPhase to modify the object.
 .EXAMPLE
$result = Get-AtwsPhase -Id 124 | New-AtwsPhase | Set-AtwsPhase -ParameterName <Parameter Value> -Passthru
Copies [Autotask.Phase] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsPhase to modify the object and returns the new object.

.LINK
Get-AtwsPhase
 .LINK
Set-AtwsPhase

#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='By_parameters', ConfirmImpact='Low')]
  Param
  (
# An array of objects to create
    [Parameter(
      ParametersetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.Phase[]]
    $InputObject,

# Phase Creation Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $CreateDate,

# Phase Creator
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $CreatorResourceID,

# Phase Description
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,8000)]
    [string]
    $Description,

# Phase End Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $DueDate,

# Phase Estimated Hours
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $EstimatedHours,

# Phase External ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $ExternalID,

# Phase Last Activity Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $LastActivityDateTime,

# Parent Phase
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ParentPhaseID,

# Phase Number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $PhaseNumber,

# Project
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $ProjectID,

# Is Scheduled
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $Scheduled,

# Phase Start Date
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [datetime]
    $StartDate,

# Phase Title
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,255)]
    [string]
    $Title
  )
 
    begin { 
        $entityName = 'Phase'
           
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {
            $DebugPreference = 'Continue' 
        }
        else {
            # Respect configured preference
            $DebugPreference = $Script:Atws.Configuration.DebugPref
        }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

        if (!($PSCmdlet.MyInvocation.BoundParameters['Verbose'].IsPresent)) {
            # No local override of central preference. Load central preference
            $VerbosePreference = $Script:Atws.Configuration.VerbosePref
        }
        
        $processObject = @()
    }

    process {
    
        if ($InputObject) {
            Write-Verbose -Message ('{0}: Copy Object mode: Setting ID property to zero' -F $MyInvocation.MyCommand.Name)  

            $fields = Get-AtwsFieldInfo -Entity $entityName
      
            $CopyNo = 1

            foreach ($object in $InputObject) { 
                # Create a new object and copy properties
                $newObject = New-Object -TypeName Autotask.$entityName
        
                # Copy every non readonly property
                $fieldNames = $fields.Where( { $_.Name -ne 'id' }).Name

                if ($PSBoundParameters.ContainsKey('UserDefinedFields')) { 
                    $fieldNames += 'UserDefinedFields' 
                }

                foreach ($field in $fieldNames) { 
                    $newObject.$field = $object.$field 
                }

                if ($newObject -is [Autotask.Ticket]) {
                    Write-Verbose -Message ('{0}: Copy Object mode: Object is a Ticket. Title must be modified to avoid duplicate detection.' -F $MyInvocation.MyCommand.Name)  
                    $title = '{0} (Copy {1})' -F $newObject.Title, $CopyNo
                    $copyNo++
                    $newObject.Title = $title
                }
                $processObject += $newObject
            }   
        }
        else {
            Write-Debug -Message ('{0}: Creating empty [Autotask.{1}]' -F $MyInvocation.MyCommand.Name, $entityName) 
            $processObject += New-Object -TypeName Autotask.$entityName    
        }
        
        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to create {1} {2}(s). This action cannot be undone.' -F $caption, $processObject.Count, $entityName
        $verboseWarning = '{0}: About to create {1} {2}(s). This action may not be undoable. Do you want to continue?' -F $caption, $processObject.Count, $entityName

        # Lets don't and say we did!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
            
            # Process parameters and update objects with their values
            $processObject = $processObject | Update-AtwsObjectsWithParameters -BoundParameters $PSBoundParameters -EntityName $EntityName
            
            $result = Set-AtwsData -Entity $processObject -Create
        }
    }

    end {
        Write-Debug -Message ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $result.count, $entityName)
        Return $result
    }

}
