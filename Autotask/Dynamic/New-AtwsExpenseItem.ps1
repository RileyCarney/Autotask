#Requires -Version 4.0
#Version 1.6.10
<#
    .COPYRIGHT
    Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
    See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.
#>
Function New-AtwsExpenseItem
{


<#
.SYNOPSIS
This function creates a new ExpenseItem through the Autotask Web Services API. All required properties are marked as required parameters to assist you on the command line.
.DESCRIPTION
The function supports all properties of an [Autotask.ExpenseItem] that can be updated through the Web Services API. The function uses PowerShell parameter validation  and supports IntelliSense for selecting picklist values. Any required paramterer is marked as Mandatory in the PowerShell function to assist you on the command line.

If you need very complicated queries you can write a filter directly and pass it using the -Filter parameter. To get the ExpenseItem with Id number 0 you could write 'New-AtwsExpenseItem -Id 0' or you could write 'New-AtwsExpenseItem -Filter {Id -eq 0}.

'New-AtwsExpenseItem -Id 0,4' could be written as 'New-AtwsExpenseItem -Filter {id -eq 0 -or id -eq 4}'. For simple queries you can see that using parameters is much easier than the -Filter option. But the -Filter option supports an arbitrary sequence of most operators (-eq, -ne, -gt, -ge, -lt, -le, -and, -or, -beginswith, -endswith, -contains, -like, -notlike, -soundslike, -isnotnull, -isnull, -isthisday). As you can group them using parenthesis '()' you can write arbitrarily complex queries with -Filter. 

To create a new ExpenseItem you need the following required fields:
 -ExpenseReportID
 -Description
 -ExpenseDate
 -ExpenseCategory
 -PaymentType
 -HaveReceipt
 -BillableToAccount

Entities that have fields that refer to the base entity of this CmdLet:

BillingItem

.INPUTS
Nothing. This function only takes parameters.
.OUTPUTS
[Autotask.ExpenseItem]. This function outputs the Autotask.ExpenseItem that was created by the API.
.EXAMPLE
$result = New-AtwsExpenseItem -ExpenseReportID [Value] -Description [Value] -ExpenseDate [Value] -ExpenseCategory [Value] -PaymentType [Value] -HaveReceipt [Value] -BillableToAccount [Value]
Creates a new [Autotask.ExpenseItem] through the Web Services API and returns the new object.
 .EXAMPLE
$result = Get-AtwsExpenseItem -Id 124 | New-AtwsExpenseItem 
Copies [Autotask.ExpenseItem] by Id 124 to a new object through the Web Services API and returns the new object.
 .EXAMPLE
Get-AtwsExpenseItem -Id 124 | New-AtwsExpenseItem | Set-AtwsExpenseItem -ParameterName <Parameter Value>
Copies [Autotask.ExpenseItem] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsExpenseItem to modify the object.
 .EXAMPLE
$result = Get-AtwsExpenseItem -Id 124 | New-AtwsExpenseItem | Set-AtwsExpenseItem -ParameterName <Parameter Value> -Passthru
Copies [Autotask.ExpenseItem] by Id 124 to a new object through the Web Services API, passes the new object to the Set-AtwsExpenseItem to modify the object and returns the new object.

.LINK
Get-AtwsExpenseItem
 .LINK
Set-AtwsExpenseItem

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
    [Autotask.ExpenseItem[]]
    $InputObject,

# Expense Report ID
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [Int]
    $ExpenseReportID,

# Description
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(0,128)]
    [string]
    $Description,

# Expense Date
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]
    $ExpenseDate,

# Expense Category
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string]
    $ExpenseCategory,

# GL Code
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,20)]
    [string]
    $GLCode,

# Work Type
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [string]
    $WorkType,

# Expense Amount
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $ExpenseAmount,

# Payment Type
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [string]
    $PaymentType,

# Reimbursable
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $Reimbursable,

# Have Receipt
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [boolean]
    $HaveReceipt,

# Billable To Account
    [Parameter(
      Mandatory = $true,
      ParametersetName = 'By_parameters'
    )]
    [ValidateNotNullOrEmpty()]
    [boolean]
    $BillableToAccount,

# Account ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $AccountID,

# Project ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ProjectID,

# Task ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $TaskID,

# Ticket ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $TicketID,

# Entertainment Location
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string]
    $EntertainmentLocation,

# Miles
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $Miles,

# Origin
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string]
    $Origin,

# Destination
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,128)]
    [string]
    $Destination,

# Rejected
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [boolean]
    $Rejected,

# purchase_order_number
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [ValidateLength(0,50)]
    [string]
    $PurchaseOrderNumber,

# Odometer Start
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $OdometerStart,

# Odometer End
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $OdometerEnd,

# Currency ID
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [Int]
    $ExpenseCurrencyID,

# Receipt Amount
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $ReceiptAmount,

# Reimbursement Amount
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $ReimbursementAmount,

# Reimbursement Currency Reimbursement Amount
    [Parameter(
      ParametersetName = 'By_parameters'
    )]
    [double]
    $ReimbursementCurrencyReimbursementAmount
  )
 
    begin { 
        $entityName = 'ExpenseItem'
           
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

                if ($newObject -is [Autotask.Ticket] -and $object.id -gt 0) {
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
