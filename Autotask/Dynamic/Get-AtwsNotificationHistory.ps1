﻿#Requires -Version 4.0
#Version 1.6.2.17
<#

.COPYRIGHT
Copyright (c) Office Center Hønefoss AS. All rights reserved. Based on code from Jan Egil Ring (Crayon). Licensed under the MIT license.
See https://github.com/officecenter/Autotask/blob/master/LICENSE.md for license information.

#>
Function Get-AtwsNotificationHistory
{


<#
.SYNOPSIS
This function get one or more NotificationHistory through the Autotask Web Services API.
.DESCRIPTION
This function creates a query based on any parameters you give and returns any resulting objects from the Autotask Web Services Api. By default the function returns any objects with properties that are Equal (-eq) to the value of the parameter. To give you more flexibility you can modify the operator by using -NotEquals [ParameterName[]], -LessThan [ParameterName[]] and so on.

Possible operators for all parameters are:
 -NotEquals
 -GreaterThan
 -GreaterThanOrEqual
 -LessThan
 -LessThanOrEquals 

Additional operators for [String] parameters are:
 -Like (supports * or % as wildcards)
 -NotLike
 -BeginsWith
 -EndsWith
 -Contains

Properties with picklists are:

NotificationHistoryTypeID
 

EntityTitle
 

EntityNumber
 

Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.NotificationHistory[]]. This function outputs the Autotask.NotificationHistory that was returned by the API.
.EXAMPLE
Get-AtwsNotificationHistory -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsNotificationHistory -NotificationHistoryName SomeName
Returns the object with NotificationHistoryName 'SomeName', if any.
 .EXAMPLE
Get-AtwsNotificationHistory -NotificationHistoryName 'Some Name'
Returns the object with NotificationHistoryName 'Some Name', if any.
 .EXAMPLE
Get-AtwsNotificationHistory -NotificationHistoryName 'Some Name' -NotEquals NotificationHistoryName
Returns any objects with a NotificationHistoryName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsNotificationHistory -NotificationHistoryName SomeName* -Like NotificationHistoryName
Returns any object with a NotificationHistoryName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsNotificationHistory -NotificationHistoryName SomeName* -NotLike NotificationHistoryName
Returns any object with a NotificationHistoryName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsNotificationHistory -NotificationHistoryTypeID <PickList Label>
Returns any NotificationHistorys with property NotificationHistoryTypeID equal to the <PickList Label>. '-PickList' is any parameter on .
 .EXAMPLE
Get-AtwsNotificationHistory -NotificationHistoryTypeID <PickList Label> -NotEquals NotificationHistoryTypeID 
Returns any NotificationHistorys with property NotificationHistoryTypeID NOT equal to the <PickList Label>.
 .EXAMPLE
Get-AtwsNotificationHistory -NotificationHistoryTypeID <PickList Label1>, <PickList Label2>
Returns any NotificationHistorys with property NotificationHistoryTypeID equal to EITHER <PickList Label1> OR <PickList Label2>.
 .EXAMPLE
Get-AtwsNotificationHistory -NotificationHistoryTypeID <PickList Label1>, <PickList Label2> -NotEquals NotificationHistoryTypeID
Returns any NotificationHistorys with property NotificationHistoryTypeID NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.
 .EXAMPLE
Get-AtwsNotificationHistory -Id 1234 -NotificationHistoryName SomeName* -NotificationHistoryTypeID <PickList Label1>, <PickList Label2> -Like NotificationHistoryName -NotEquals NotificationHistoryTypeID -GreaterThan Id
An example of a more complex query. This command returns any NotificationHistorys with Id GREATER THAN 1234, a NotificationHistoryName that matches the simple pattern SomeName* AND that has a NotificationHistoryTypeID that is NOT equal to NEITHER <PickList Label1> NOR <PickList Label2>.


#>

  [CmdLetBinding(SupportsShouldProcess = $True, DefaultParameterSetName='Filter', ConfirmImpact='None')]
  Param
  (
# A filter that limits the number of objects that is returned from the API
    [Parameter(
      Mandatory = $true,
      ValueFromRemainingArguments = $true,
      ParameterSetName = 'Filter'
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Filter,

# Follow this external ID and return any external objects
    [Parameter(
      ParameterSetName = 'Filter'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('GetRef')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('AccountID', 'InitiatingContactID', 'InitiatingResourceID', 'OpportunityID', 'ProjectID', 'QuoteID', 'TaskID', 'TicketID', 'TimeEntryID')]
    [String]
    $GetReferenceEntityById,

# Return entities of selected type that are referencing to this entity.
    [Parameter(
      ParameterSetName = 'Filter'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Alias('External')]
    [ValidateNotNullOrEmpty()]
    [String]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParameterSetName = 'Get_all'
    )]
    [Switch]
    $All,

# Do not add descriptions for all picklist attributes with values
    [Parameter(
      ParameterSetName = 'Filter'
    )]
    [Parameter(
      ParameterSetName = 'Get_all'
    )]
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Switch]
    $NoPickListLabel,

# ID
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Notification Sent Time
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $NotificationSentTime,

# Template Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $TemplateName,

# Notification History Type Id
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $NotificationHistoryTypeID,

# Entity Title
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $EntityTitle,

# Entity Number
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [String[]]
    $EntityNumber,

# Is Template Deleted
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $IsDeleted,

# Is Template Active
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $IsActive,

# Is Template Job
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[boolean][]]
    $IsTemplateJob,

# Initiating Resource
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $InitiatingResourceID,

# Initiating Contact
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $InitiatingContactID,

# Recipient Email Address
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,2000)]
    [string[]]
    $RecipientEmailAddress,

# Recipient Display Name
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateLength(0,200)]
    [string[]]
    $RecipientDisplayName,

# Client
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $AccountID,

# Quote
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $QuoteID,

# Opportunity
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $OpportunityID,

# Project
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $ProjectID,

# Task
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $TaskID,

# Ticket
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $TicketID,

# Time Entry
    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [Nullable[long][]]
    $TimeEntryID,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'NotificationSentTime', 'TemplateName', 'NotificationHistoryTypeID', 'EntityTitle', 'EntityNumber', 'IsDeleted', 'IsActive', 'IsTemplateJob', 'InitiatingResourceID', 'InitiatingContactID', 'RecipientEmailAddress', 'RecipientDisplayName', 'AccountID', 'QuoteID', 'OpportunityID', 'ProjectID', 'TaskID', 'TicketID', 'TimeEntryID')]
    [String[]]
    $NotEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'NotificationSentTime', 'TemplateName', 'NotificationHistoryTypeID', 'EntityTitle', 'EntityNumber', 'IsDeleted', 'IsActive', 'IsTemplateJob', 'InitiatingResourceID', 'InitiatingContactID', 'RecipientEmailAddress', 'RecipientDisplayName', 'AccountID', 'QuoteID', 'OpportunityID', 'ProjectID', 'TaskID', 'TicketID', 'TimeEntryID')]
    [String[]]
    $IsNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'NotificationSentTime', 'TemplateName', 'NotificationHistoryTypeID', 'EntityTitle', 'EntityNumber', 'IsDeleted', 'IsActive', 'IsTemplateJob', 'InitiatingResourceID', 'InitiatingContactID', 'RecipientEmailAddress', 'RecipientDisplayName', 'AccountID', 'QuoteID', 'OpportunityID', 'ProjectID', 'TaskID', 'TicketID', 'TimeEntryID')]
    [String[]]
    $IsNotNull,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'NotificationSentTime', 'TemplateName', 'NotificationHistoryTypeID', 'EntityTitle', 'EntityNumber', 'InitiatingResourceID', 'InitiatingContactID', 'RecipientEmailAddress', 'RecipientDisplayName', 'AccountID', 'QuoteID', 'OpportunityID', 'ProjectID', 'TaskID', 'TicketID', 'TimeEntryID')]
    [String[]]
    $GreaterThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'NotificationSentTime', 'TemplateName', 'NotificationHistoryTypeID', 'EntityTitle', 'EntityNumber', 'InitiatingResourceID', 'InitiatingContactID', 'RecipientEmailAddress', 'RecipientDisplayName', 'AccountID', 'QuoteID', 'OpportunityID', 'ProjectID', 'TaskID', 'TicketID', 'TimeEntryID')]
    [String[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'NotificationSentTime', 'TemplateName', 'NotificationHistoryTypeID', 'EntityTitle', 'EntityNumber', 'InitiatingResourceID', 'InitiatingContactID', 'RecipientEmailAddress', 'RecipientDisplayName', 'AccountID', 'QuoteID', 'OpportunityID', 'ProjectID', 'TaskID', 'TicketID', 'TimeEntryID')]
    [String[]]
    $LessThan,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('id', 'NotificationSentTime', 'TemplateName', 'NotificationHistoryTypeID', 'EntityTitle', 'EntityNumber', 'InitiatingResourceID', 'InitiatingContactID', 'RecipientEmailAddress', 'RecipientDisplayName', 'AccountID', 'QuoteID', 'OpportunityID', 'ProjectID', 'TaskID', 'TicketID', 'TimeEntryID')]
    [String[]]
    $LessThanOrEquals,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('TemplateName', 'EntityTitle', 'EntityNumber', 'RecipientEmailAddress', 'RecipientDisplayName')]
    [String[]]
    $Like,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('TemplateName', 'EntityTitle', 'EntityNumber', 'RecipientEmailAddress', 'RecipientDisplayName')]
    [String[]]
    $NotLike,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('TemplateName', 'EntityTitle', 'EntityNumber', 'RecipientEmailAddress', 'RecipientDisplayName')]
    [String[]]
    $BeginsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('TemplateName', 'EntityTitle', 'EntityNumber', 'RecipientEmailAddress', 'RecipientDisplayName')]
    [String[]]
    $EndsWith,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('TemplateName', 'EntityTitle', 'EntityNumber', 'RecipientEmailAddress', 'RecipientDisplayName')]
    [String[]]
    $Contains,

    [Parameter(
      ParameterSetName = 'By_parameters'
    )]
    [ValidateSet('NotificationSentTime')]
    [String[]]
    $IsThisDay
  )

  Begin
  { 
    $EntityName = 'NotificationHistory'
    
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
    
  }


  Process
  {
    If ($PSCmdlet.ParameterSetName -eq 'Get_all')
    { 
      $Filter = @('id', '-ge', 0)
    }
    ElseIf (-not ($Filter)) {
    
      Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)
      
      # Convert named parameters to a filter definition that can be parsed to QueryXML
      $Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $EntityName
    }
    Else {
      
      Write-Debug ('{0}: Query based on manual filter, parsing' -F $MyInvocation.MyCommand.Name)
              
      $Filter = . Update-AtwsFilter -FilterString $Filter
    } 

    $Caption = $MyInvocation.MyCommand.Name
    $VerboseDescrition = '{0}: About to query the Autotask Web API for {1}(s).' -F $Caption, $EntityName
    $VerboseWarning = '{0}: About to query the Autotask Web API for {1}(s). Do you want to continue?' -F $Caption, $EntityName
    
    If ($PSCmdlet.ShouldProcess($VerboseDescrition, $VerboseWarning, $Caption)) { 
    
      # Make the query and pass the optional parameters to Get-AtwsData
      $Result = Get-AtwsData -Entity $EntityName -Filter $Filter `
        -NoPickListLabel:$NoPickListLabel.IsPresent `
        -GetReferenceEntityById $GetReferenceEntityById `
        -GetExternalEntityByThisEntityId $GetExternalEntityByThisEntityId
    
      Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $Result.Count)

    }
  }

  End
  {
    Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
    If ($Result)
    {
      Return $Result
    }
  }


}
