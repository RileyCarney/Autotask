﻿#Requires -Version 4.0
#Version 1.6.2.13
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Set-AtwsOpportunity
{


<#
.SYNOPSIS
This function sets parameters on the Opportunity specified by the -InputObject parameter or pipeline through the use of the Autotask Web Services API. Any property of the Opportunity that is not marked as READ ONLY by Autotask can be speficied with a parameter. You can specify multiple paramters.
.DESCRIPTION
This function one or more objects of type [Autotask.Opportunity] as input. You can pipe the objects to the function or pass them using the -InputObject parameter. You specify the property you want to set and the value you want to set it to using parameters. The function modifies all objects and updates the online data through the Autotask Web Services API. The function supports all properties of an [Autotask.Opportunity] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values.

Entities that have fields that refer to the base entity of this CmdLet:

AccountNote
 AccountToDo
 AttachmentInfo
 Contract
 NotificationHistory
 Quote
 SalesOrder
 Ticket

.INPUTS
[Autotask.Opportunity[]]. This function takes one or more objects as input. Pipeline is supported.
.OUTPUTS
Nothing or [Autotask.Opportunity]. This function optionally returns the updated objects if you use the -PassThru parameter.
.EXAMPLE
Set-AtwsOpportunity -InputObject $Opportunity [-ParameterName] [Parameter value]
Passes one or more [Autotask.Opportunity] object(s) as a variable to the function and sets the property by name 'ParameterName' on ALL the objects before they are passed to the Autotask Web Service API and updated.
 .EXAMPLE
$Opportunity | Set-AtwsOpportunity -ParameterName <Parameter value>
Same as the first example, but now the objects are passed to the funtion through the pipeline, not passed as a parameter. The end result is identical.
 .EXAMPLE
Get-AtwsOpportunity -Id 0 | Set-AtwsOpportunity -ParameterName <Parameter value>
Gets the instance with Id 0 directly from the Web Services API, modifies a parameter and updates Autotask. This approach works with all valid parameters for the Get function.
 .EXAMPLE
Get-AtwsOpportunity -Id 0,4,8 | Set-AtwsOpportunity -ParameterName <Parameter value>
Gets multiple instances by Id, modifies them all and updates Autotask.
 .EXAMPLE
$Result = Get-AtwsOpportunity -Id 0,4,8 | Set-AtwsOpportunity -ParameterName <Parameter value> -PassThru
Gets multiple instances by Id, modifies them all, updates Autotask and returns the updated objects.

.LINK
New-AtwsOpportunity
 .LINK
Get-AtwsOpportunity

#>

  [CmdLetBinding(SupportsShouldProcess = $True, DefaultParameterSetName='InputObject', ConfirmImpact='Low')]
  Param
  (
# An object that will be modified by any parameters and updated in Autotask
    [Parameter(
      ParameterSetName = 'Input_Object',
      ValueFromPipeline = $true
    )]
    [ValidateNotNullOrEmpty()]
    [Autotask.Opportunity[]]
    $InputObject,

# The object.ids of objects that should be modified by any parameters and updated in Autotask
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [long[]]
    $Id,

# Return any updated objects through the pipeline
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Switch]
    $PassThru,

# AccountObjectID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int]]
    $AccountID,

# NumberOfUsers
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[decimal]]
    $AdvancedField1,

# SetupFee
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[decimal]]
    $AdvancedField2,

# HourlyCost
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[decimal]]
    $AdvancedField3,

# DailyCost
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[decimal]]
    $AdvancedField4,

# MonthlyCost
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[decimal]]
    $AdvancedField5,

# Amount
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[decimal]]
    $Amount,

# Barriers
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(0,500)]
    [string]
    $Barriers,

# ContactObjectID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[Int]]
    $ContactID,

# Cost
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[decimal]]
    $Cost,

# CreateDate
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime]]
    $CreateDate,

# HelpNeeded
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(0,500)]
    [string]
    $HelpNeeded,

# LeadReferralObjectID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [String]
    $LeadReferral,

# Market
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(0,500)]
    [string]
    $Market,

# NextStep
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(0,500)]
    [string]
    $NextStep,

# CreatorObjectID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int]]
    $OwnerResourceID,

# ProductObjectID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[Int]]
    $ProductID,

# ProjClose
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[datetime]]
    $ProjectedCloseDate,

# StartDate
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[datetime]]
    $ProjectedLiveDate,

# promotion_name
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(0,50)]
    [string]
    $PromotionName,

# spread_revenue_recognition_unit
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [String]
    $RevenueSpreadUnit,

# StageObjectID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [String]
    $Stage,

# Status
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [String]
    $Status,

# ThroughDate
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[datetime]]
    $ThroughDate,

# Description
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,128)]
    [string]
    $Title,

# opportunity_rating_id
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [String]
    $Rating,

# Closed Date
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[datetime]]
    $ClosedDate,

# Primary Competitor
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [String]
    $PrimaryCompetitor,

# Win Reason
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [String]
    $WinReason,

# Loss Reason
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [String]
    $LossReason,

# Win Reason Detail
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(0,500)]
    [string]
    $WinReasonDetail,

# Loss Reason Detail
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateLength(0,500)]
    [string]
    $LossReasonDetail,

# Probability
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[Int]]
    $Probability,

# Revenue Spread
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[Int]]
    $RevenueSpread,

# Use Quote Totals
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      Mandatory = $true,
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean]]
    $UseQuoteTotals,

# Total Amount Months
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[Int]]
    $TotalAmountMonths,

# One-Time Cost
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[decimal]]
    $OnetimeCost,

# One-Time Revenue
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[decimal]]
    $OnetimeRevenue,

# Monthly Cost
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[decimal]]
    $MonthlyCost,

# Monthly Revenue
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[decimal]]
    $MonthlyRevenue,

# Quarterly Cost
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[decimal]]
    $QuarterlyCost,

# Quarterly Revenue
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[decimal]]
    $QuarterlyRevenue,

# Semi-Annual Cost
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[decimal]]
    $SemiannualCost,

# Semi-Annual Revenue
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[decimal]]
    $SemiannualRevenue,

# Yearly Cost
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[decimal]]
    $YearlyCost,

# Yearly Revenue
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[decimal]]
    $YearlyRevenue,

# Business Division Subdivision ID
    [Parameter(
      ParameterSetName = 'Input_Object'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Parameter(
      ParameterSetName = 'By_Id'
    )]
    [Nullable[Int]]
    $BusinessDivisionSubdivisionID
  )
 
  Begin
  { 
    $EntityName = 'Opportunity'
    
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        
    # Set up TimeZone offset handling
    If (-not($script:LocalToEST))
    {
      $Now = Get-Date
      $ESTzone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Eastern Standard Time")
      $ESTtime = [System.TimeZoneInfo]::ConvertTimeFromUtc($Now.ToUniversalTime(), $ESTzone)

      # Time difference in hours from localtime to API time
      $script:LocalToEST = (New-TimeSpan -Start $Now -End $ESTtime).TotalHours
    }
    
    # Collect fresh copies of InputObject if passed any IDs
    If ($Id.Count -gt 0 -and $Id.Count -le 200) {
      $Filter = 'Id -eq {0}' -F ($Id -join ' -or Id -eq ')
      $InputObject = Get-AtwsData -Entity $EntityName -Filter $Filter
      
      # Remove the ID parameter so we do not try to set it on every object
      $Null = $PSBoundParameters.Remove('id')
    }
    ElseIf ($Id.Count -gt 200) {
      Throw [ApplicationException] 'Too many objects, the module can process a maximum of 200 objects when using the Id parameter.'
    }
  }

  Process
  {
    $Fields = Get-AtwsFieldInfo -Entity $EntityName
    
    # Loop through parameters and update any inputobjects with the given parameter values    
    Foreach ($Parameter in $PSBoundParameters.GetEnumerator())
    {
      $Field = $Fields | Where-Object {$_.Name -eq $Parameter.Key}
      If (($Field) -or $Parameter.Key -eq 'UserDefinedFields')
      { 
        If ($Field.IsPickList)
        {
          $PickListValue = $Field.PickListValues | Where-Object {$_.Label -eq $Parameter.Value}
          $Value = $PickListValue.Value
        }
        Else
        {
          $Value = $Parameter.Value
        }  
        Foreach ($Object in $InputObject) 
        { 
          $Object.$($Parameter.Key) = $Value
        }
      }
    }

    $Caption = $MyInvocation.MyCommand.Name
    $VerboseDescrition = '{0}: About to modify {1} {2}(s). This action cannot be undone.' -F $Caption, $InputObject.Count, $EntityName
    $VerboseWarning = '{0}: About to modify {1} {2}(s). This action cannot be undone. Do you want to continue?' -F $Caption, $InputObject.Count, $EntityName

    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
  
      # Normalize dates, i.e. set them to CEST. The .Update() method of the API reads all datetime fields as CEST
      # We can safely ignore readonly fields, even if we have modified them previously. The API ignores them.
      $DateTimeParams = $Fields.Where({$_.Type -eq 'datetime' -and -not $_.IsReadOnly}).Name
    
      # Do Picklists more human readable
      $Picklists = $Fields.Where{$_.IsPickList}
    
      # Adjust TimeZone on all DateTime properties
      Foreach ($Object in $InputObject) 
      { 
        Foreach ($DateTimeParam in $DateTimeParams) {
      
          # Get the datetime value
          $Value = $Object.$DateTimeParam
                
          # Skip if parameter is empty
          If (-not ($Value)) {
            Continue
          }
          # Convert the datetime back to CEST
          $Object.$DateTimeParam = $Value.AddHours($script:LocalToEST)
        }
      
        # Revert picklist labels to their values
        Foreach ($Field in $Picklists)
        {
          If ($Object.$($Field.Name) -in $Field.PicklistValues.Label) {
            $Object.$($Field.Name) = ($Field.PickListValues.Where{$_.Label -eq $Object.$($Field.Name)}).Value
          }
        }
      }

      $ModifiedObjects = Set-AtwsData -Entity $InputObject
    
      # Revert changes back on any inputobject
      Foreach ($Object in $InputObject) 
      { 
        Foreach ($DateTimeParam in $DateTimeParams) {
      
          # Get the datetime value
          $Value = $Object.$DateTimeParam
                
          # Skip if parameter is empty
          If (-not ($Value)) {
            Continue
          }
          # Revert the datetime back from CEST
          $Object.$DateTimeParam = $Value.AddHours($script:LocalToEST * -1)
        }
      
        If ($Script:UsePickListLabels) { 
          # Restore picklist labels
          Foreach ($Field in $Picklists)
          {
            If ($Object.$($Field.Name) -in $Field.PicklistValues.Value) {
              $Object.$($Field.Name) = ($Field.PickListValues.Where{$_.Value -eq $Object.$($Field.Name)}).Label
            }
          }
        }
      }
    }
    
  }

  End
  {
    Write-Debug ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $ModifiedObjects.count, $EntityName)
    If ($PassThru.IsPresent) { 
      Return $ModifiedObjects
    }
  }

}
