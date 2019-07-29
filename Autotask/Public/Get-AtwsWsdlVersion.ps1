﻿#Requires -Version 4.0
<#

    .COPYRIGHT
    Copyright (c) Office Center HÃ¸nefoss AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/officecenter/Autotask/blob/master/LICENSE.md  for license information.

#>

Function Get-AtwsWsdlVersion {
  <#
      .SYNOPSIS
      This function collects information about a specific Autotask invoice object and returns a generic
      powershell object with all relevant information as a starting point for import into other systems.
      .DESCRIPTION
      The function accepts an invoice object or an invoice id and makes a special API call to get a 
      complete invoice description, including billingitems. For some types of billingitems additional
      information may be collected. All information is collected and stored in a PSObject which is
      returned.
      .INPUTS
      An Autotask invoice object or an invoice id
      .OUTPUTS
      A custom PSObject with detailed information about an invoice
      .EXAMPLE
      $Invoice | Get-#PrefixInvoiceInfo
      Gets information about invoices passed through the pipeline
      .EXAMPLE
      Get-#PrefixInvoiceInfo -InvoiceID $Invoice.id
      Gets information about invoices based on the ids passed as a parameter
      .NOTES
      NAME: Get-#PrefixInvoiceInfo
      
  #>
	
  [cmdletbinding()]
  Param
  (
  )
  
  Begin {
    
    # Enable modern -Debug behavior
    If ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) {$DebugPreference = 'Continue'}
    
    If (-not($Script:Atws.Url))
    {
      Throw [ApplicationException] 'Not connected to Autotask WebAPI. Re-import module with valid credentials.'
    }    
  }

  Process {
    Try { 
      $Result = $Script:Atws.GetWsdlVersion()
    }
    Catch {
      Write-Warning ('{0}: FAILED on GetWsdlVersion(). No data returned.' -F $MyInvocation.MyCommand.Name)
              
      Return
    }


    # Handle any errors
    If ($Result.Errors.Count -gt 0)
    {
      Foreach ($AtwsError in $Result.Errors)
      {
        Write-Error $AtwsError.Message
      }
      Return
    }
    
  }

  End {
    Return $Result
  }
}