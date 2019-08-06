<#

    .COPYRIGHT
    Copyright (c) Office Center Hønefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md  for license information.

#>

Function ConvertFrom-LocalObject {
    <#
      .SYNOPSIS
      This function adjusts the timezone and converts picklist fields from their label to their index value.
      .DESCRIPTION
      This function adjusts the timezone and converts picklist fields from their label to their index value.
      .INPUTS
      [PSObject[]]
      .OUTPUTS
      [PSObject[]]
      .EXAMPLE
      $Element | ConvertFrom-LocalTimeAndLabels
      Updates the properties of object $Element with the values of any parameter with the same name as a property-
      .NOTES
      NAME: Update-AtwsObjectsWithParameters
      
  #>
    [cmdletbinding()]
    Param
    (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [PSObject[]]
        $InputObject

    )

    begin {
        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {
            $DebugPreference = 'Continue'
        }
    
        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)
        
        # Set up TimeZone offset handling
        $EST = Get-TimeZone -Id 'Eastern Standard Time'
     
    }

    process {

        # Get the entity name from input
        $entityName = $InputObject[0].GetType().Name

        # Get updated field info about this entity
        $fields = Get-AtwsFieldInfo -Entity $entityName
    
        # Normalize dates, i.e. set them to CEST. The .Update() method of the API reads all datetime fields as CEST
        # We can safely ignore readonly fields, even if we have modified them previously. The API ignores them.
        $dateTimeParams = $fields.Where( { $_.Type -eq 'datetime' -and -not $_.IsReadOnly }).Name
    
        # Prepare picklists
        $Picklists = $fields.Where{ $_.IsPickList }
    
        # Adjust TimeZone on all DateTime properties
        foreach ($object in $InputObject) { 
            foreach ($dateTimeParam in $dateTimeParams) {
    
                # Get the datetime value
                $value = $object.$dateTimeParam
                
                # Skip if parameter is empty
                if (-not ($value)) {
                    Continue
                }
                # Convert the datetime back to CEST
                $object.$dateTimeParam = [TimeZoneInfo]::ConvertTime($value, [TimeZoneInfo]::Local, $EST)
            }
            
            # Revert picklist labels to their values
            foreach ($field in $Picklists) {
                if ($object.$($field.Name) -in $field.PicklistValues.Label) {
                    $object.$($field.Name) = ($field.PickListValues.Where{ $_.Label -eq $object.$($field.Name) }).Value
                }
            }
        }
        
    }

    end {
        Write-Debug -Message ('{0}: End of function, returning {1} {2}(s)' -F $MyInvocation.MyCommand.Name, $InputObject.count, $entityName)
        Return $InputObject
    }
}