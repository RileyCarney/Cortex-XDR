<#
curl -X POST https://api-{fqdn}/public_api/v1/{name of api}/{name of
call}/
-H "x-xdr-auth-id:{key_id}"
-H "Authorization:{key}"
-H "Content-Type:application/json"
-d '{}'

https://api-{fqdn}/public_api/v1/{name of api}/{name of call}/.
Key: x-xdr-auth-id:{key_id}

GET FQDN
1. Right-click your API key and select View Examples.
2. Copy the CURL Example URL. The example contains your unique FQDN:
https://api-{fqdn}/public_api/v1/{name of api}/{name of call}/
#>
function Get-Incidents {

    <#
    .SYNOPSIS
    Fetches open alerts of the authenticated user's account
 
    .DESCRIPTION
    Returns account open alerts.
 
    .PARAMETER Muted
    Use this switch to show muted alerts
 
    #>


    # Function Parameters
    Param (
        [Parameter(Mandatory=$False)]
        [Switch]$muted
    )

    # Declare Variables
    $apiMethod = 'POST'
    $maxPage = 250
    $nextPageUrl = $null
    $page = 0
    $Results = @()
    $URI = "/public_api/v1/incidents/get_incidents/"
    do {
        $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/account/alerts/open?max=$maxPage&page=$page&muted=$muted" | ConvertFrom-Json
        if ($Response) {
            $nextPageUrl = $Response.pageDetails.nextPageUrl
            $Results += $Response.Alerts
            $page++
        }
    }
    until ($nextPageUrl -eq $null)

    # Return all sites except the 'Deleted Devices' site
    return $Results

}