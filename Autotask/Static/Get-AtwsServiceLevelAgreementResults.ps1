#Requires -Version 4.0
#Version 1.6.10
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function Get-AtwsServiceLevelAgreementResults
{


<#
.SYNOPSIS
This function get one or more ServiceLevelAgreementResults through the Autotask Web Services API.
.DESCRIPTION
This function creates a query based on any parameters you give and returns any resulting objects from the Autotask Web Services Api. By default the function returns any objects with properties that are Equal (-eq) to the value of the parameter. To give you more flexibility you can modify the operator by using -NotEquals [ParameterName[]], -LessThan [ParameterName[]] and so on.

Possible operators for all parameters are:
 -NotEquals
 -GreaterThan
 -GreaterThanOrEqual
 -LessThan
 -LessThanOrEquals 

Additional operators for [string] parameters are:
 -Like (supports * or % as wildcards)
 -NotLike
 -BeginsWith
 -EndsWith
 -Contains

Properties with picklists are:


Entities that have fields that refer to the base entity of this CmdLet:


.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.ServiceLevelAgreementResults[]]. This function outputs the Autotask.ServiceLevelAgreementResults that was returned by the API.
.EXAMPLE
Get-AtwsServiceLevelAgreementResults -Id 0
Returns the object with Id 0, if any.
 .EXAMPLE
Get-AtwsServiceLevelAgreementResults -ServiceLevelAgreementResultsName SomeName
Returns the object with ServiceLevelAgreementResultsName 'SomeName', if any.
 .EXAMPLE
Get-AtwsServiceLevelAgreementResults -ServiceLevelAgreementResultsName 'Some Name'
Returns the object with ServiceLevelAgreementResultsName 'Some Name', if any.
 .EXAMPLE
Get-AtwsServiceLevelAgreementResults -ServiceLevelAgreementResultsName 'Some Name' -NotEquals ServiceLevelAgreementResultsName
Returns any objects with a ServiceLevelAgreementResultsName that is NOT equal to 'Some Name', if any.
 .EXAMPLE
Get-AtwsServiceLevelAgreementResults -ServiceLevelAgreementResultsName SomeName* -Like ServiceLevelAgreementResultsName
Returns any object with a ServiceLevelAgreementResultsName that matches the simple pattern 'SomeName*'. Supported wildcards are * and %.
 .EXAMPLE
Get-AtwsServiceLevelAgreementResults -ServiceLevelAgreementResultsName SomeName* -NotLike ServiceLevelAgreementResultsName
Returns any object with a ServiceLevelAgreementResultsName that DOES NOT match the simple pattern 'SomeName*'. Supported wildcards are * and %.


#>

  [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName='Filter', ConfirmImpact='None')]
  Param
  (
# A filter that limits the number of objects that is returned from the API
    [Parameter(
      Mandatory = $true,
      ValueFromRemainingArguments = $true,
      ParametersetName = 'Filter'
    )]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Filter,

# Follow this external ID and return any external objects
    [Parameter(
      ParametersetName = 'Filter'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('GetRef')]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('CreatorResourceID', 'FirstResponseInitiatingResourceID', 'FirstResponseResourceID', 'LastModifiedByResourceID', 'ResolutionPlanResourceID', 'ResolutionResourceID', 'TicketID')]
    [string]
    $GetReferenceEntityById,

# Return entities of selected type that are referencing to this entity.
    [Parameter(
      ParametersetName = 'Filter'
    )]
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Alias('External')]
    [ValidateNotNullOrEmpty()]
    [string]
    $GetExternalEntityByThisEntityId,

# Return all objects in one query
    [Parameter(
      ParametersetName = 'Get_all'
    )]
    [switch]
    $All,

# Service Level Agreement Results ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Nullable[long][]]
    $id,

# Ticket ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $TicketID,

# Service Level Agreement Name
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,100)]
    [string[]]
    $ServiceLevelAgreementName,

# First Response Elapsed Hours
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $FirstResponseElapsedHours,

# First Response Initiating Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $FirstResponseInitiatingResourceID,

# First Response Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $FirstResponseResourceID,

# First Response Met
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $FirstResponseMet,

# Resolution Plan Elapsed Hours
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $ResolutionPlanElapsedHours,

# Resolution Plan Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ResolutionPlanResourceID,

# Resolution Plan Met
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $ResolutionPlanMet,

# Resolution Elapsed Hours
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[decimal][]]
    $ResolutionElapsedHours,

# Resolution Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $ResolutionResourceID,

# Resolution Met
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[boolean][]]
    $ResolutionMet,

# Create Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $CreateDateTime,

# Creator Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $CreatorResourceID,

# Last Modified Date Time
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[datetime][]]
    $LastModifiedDateTime,

# Last Modified By Resource ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Nullable[Int][]]
    $LastModifiedByResourceID,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TicketID', 'ServiceLevelAgreementName', 'FirstResponseElapsedHours', 'FirstResponseInitiatingResourceID', 'FirstResponseResourceID', 'FirstResponseMet', 'ResolutionPlanElapsedHours', 'ResolutionPlanResourceID', 'ResolutionPlanMet', 'ResolutionElapsedHours', 'ResolutionResourceID', 'ResolutionMet', 'CreateDateTime', 'CreatorResourceID', 'LastModifiedDateTime', 'LastModifiedByResourceID')]
    [string[]]
    $NotEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TicketID', 'ServiceLevelAgreementName', 'FirstResponseElapsedHours', 'FirstResponseInitiatingResourceID', 'FirstResponseResourceID', 'FirstResponseMet', 'ResolutionPlanElapsedHours', 'ResolutionPlanResourceID', 'ResolutionPlanMet', 'ResolutionElapsedHours', 'ResolutionResourceID', 'ResolutionMet', 'CreateDateTime', 'CreatorResourceID', 'LastModifiedDateTime', 'LastModifiedByResourceID')]
    [string[]]
    $IsNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TicketID', 'ServiceLevelAgreementName', 'FirstResponseElapsedHours', 'FirstResponseInitiatingResourceID', 'FirstResponseResourceID', 'FirstResponseMet', 'ResolutionPlanElapsedHours', 'ResolutionPlanResourceID', 'ResolutionPlanMet', 'ResolutionElapsedHours', 'ResolutionResourceID', 'ResolutionMet', 'CreateDateTime', 'CreatorResourceID', 'LastModifiedDateTime', 'LastModifiedByResourceID')]
    [string[]]
    $IsNotNull,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TicketID', 'ServiceLevelAgreementName', 'FirstResponseElapsedHours', 'FirstResponseInitiatingResourceID', 'FirstResponseResourceID', 'ResolutionPlanElapsedHours', 'ResolutionPlanResourceID', 'ResolutionElapsedHours', 'ResolutionResourceID', 'CreateDateTime', 'CreatorResourceID', 'LastModifiedDateTime', 'LastModifiedByResourceID')]
    [string[]]
    $GreaterThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TicketID', 'ServiceLevelAgreementName', 'FirstResponseElapsedHours', 'FirstResponseInitiatingResourceID', 'FirstResponseResourceID', 'ResolutionPlanElapsedHours', 'ResolutionPlanResourceID', 'ResolutionElapsedHours', 'ResolutionResourceID', 'CreateDateTime', 'CreatorResourceID', 'LastModifiedDateTime', 'LastModifiedByResourceID')]
    [string[]]
    $GreaterThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TicketID', 'ServiceLevelAgreementName', 'FirstResponseElapsedHours', 'FirstResponseInitiatingResourceID', 'FirstResponseResourceID', 'ResolutionPlanElapsedHours', 'ResolutionPlanResourceID', 'ResolutionElapsedHours', 'ResolutionResourceID', 'CreateDateTime', 'CreatorResourceID', 'LastModifiedDateTime', 'LastModifiedByResourceID')]
    [string[]]
    $LessThan,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('id', 'TicketID', 'ServiceLevelAgreementName', 'FirstResponseElapsedHours', 'FirstResponseInitiatingResourceID', 'FirstResponseResourceID', 'ResolutionPlanElapsedHours', 'ResolutionPlanResourceID', 'ResolutionElapsedHours', 'ResolutionResourceID', 'CreateDateTime', 'CreatorResourceID', 'LastModifiedDateTime', 'LastModifiedByResourceID')]
    [string[]]
    $LessThanOrEquals,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ServiceLevelAgreementName')]
    [string[]]
    $Like,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ServiceLevelAgreementName')]
    [string[]]
    $NotLike,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ServiceLevelAgreementName')]
    [string[]]
    $BeginsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ServiceLevelAgreementName')]
    [string[]]
    $EndsWith,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('ServiceLevelAgreementName')]
    [string[]]
    $Contains,

    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateSet('CreateDateTime', 'LastModifiedDateTime')]
    [string[]]
    $IsThisDay
  )

    begin { 
        $entityName = 'ServiceLevelAgreementResults'
    
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
    
    }


    process {
        # Parameterset Get_All has a single parameter: -All
        # Set the Filter manually to get every single object of this type 
        if ($PSCmdlet.ParameterSetName -eq 'Get_all') { 
            $Filter = @('id', '-ge', 0)
        }
        # So it is not -All. If Filter does not exist it has to be By_parameters
        elseif (-not ($Filter)) {
    
            Write-Debug ('{0}: Query based on parameters, parsing' -F $MyInvocation.MyCommand.Name)
      
            # Convert named parameters to a filter definition that can be parsed to QueryXML
            [string[]]$Filter = ConvertTo-AtwsFilter -BoundParameters $PSBoundParameters -EntityName $entityName
        }
        # Not parameters, nor Get_all. There are only three parameter sets, so now we know
        # that we were passed a Filter
        else {
      
            Write-Debug ('{0}: Query based on manual filter, parsing' -F $MyInvocation.MyCommand.Name)
            
            # Parse the filter string and expand variables in _this_ scope (dot-sourcing)
            # or the variables will not be available and expansion will fail
            $Filter = . Update-AtwsFilter -Filterstring $Filter
        } 

        # Prepare shouldProcess comments
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to query the Autotask Web API for {1}(s).' -F $caption, $entityName
        $verboseWarning = '{0}: About to query the Autotask Web API for {1}(s). Do you want to continue?' -F $caption, $entityName
    
        # Lets do it and say we didn't!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) { 
    
            # Make the query and pass the optional parameters to Get-AtwsData
            $result = Get-AtwsData -Entity $entityName -Filter $Filter `
                -NoPickListLabel:$NoPickListLabel.IsPresent `
                -GetReferenceEntityById $GetReferenceEntityById `
                -GetExternalEntityByThisEntityId $GetExternalEntityByThisEntityId
    
            Write-Verbose ('{0}: Number of entities returned by base query: {1}' -F $MyInvocation.MyCommand.Name, $result.Count)

        }
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        if ($result) {
            Return $result
        }
    }


}
