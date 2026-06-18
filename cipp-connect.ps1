# Load .env
Get-Content "$PSScriptRoot\.env" | ForEach-Object {
    if ($_ -match '^\s*([^#][^=]+)=(.+)$') {
        [System.Environment]::SetEnvironmentVariable($matches[1].Trim(), $matches[2].Trim())
    }
}

$tenantId   = [System.Environment]::GetEnvironmentVariable('CIPP_TENANT_ID')
$clientId   = [System.Environment]::GetEnvironmentVariable('CIPP_CLIENT_ID')
$clientSecret = [System.Environment]::GetEnvironmentVariable('CIPP_API_SECRET')
$scope      = [System.Environment]::GetEnvironmentVariable('CIPP_SCOPE')
$tokenUrl   = [System.Environment]::GetEnvironmentVariable('CIPP_TOKEN_URL')
$apiUrl     = [System.Environment]::GetEnvironmentVariable('CIPP_API_URL')

# Get OAuth2 token
$body = @{
    grant_type    = 'client_credentials'
    client_id     = $clientId
    client_secret = $clientSecret
    scope         = $scope
}

Write-Host "Authenticating with CIPP..." -ForegroundColor Cyan
$tokenResponse = Invoke-RestMethod -Method Post -Uri $tokenUrl -Body $body -ContentType 'application/x-www-form-urlencoded'
$token = $tokenResponse.access_token

if (-not $token) {
    Write-Error "Failed to obtain access token."
    exit 1
}

Write-Host "Token obtained successfully." -ForegroundColor Green

# Helper function — call any CIPP API endpoint
function Invoke-CIPPApi {
    param(
        [string]$Endpoint,
        [string]$Method = 'GET',
        [hashtable]$Body = @{}
    )
    $headers = @{ Authorization = "Bearer $token" }
    $uri = "$apiUrl$Endpoint"

    if ($Method -eq 'GET') {
        Invoke-RestMethod -Uri $uri -Headers $headers -Method GET
    } else {
        Invoke-RestMethod -Uri $uri -Headers $headers -Method $Method -Body ($Body | ConvertTo-Json) -ContentType 'application/json'
    }
}

# --- Example calls (uncomment to use) ---

# List tenants
# $tenants = Invoke-CIPPApi -Endpoint '/api/ListTenants'
# $tenants | Format-Table

Write-Host "CIPP connection ready. Use Invoke-CIPPApi to make calls." -ForegroundColor Yellow
Write-Host "Example: Invoke-CIPPApi -Endpoint '/api/ListTenants'"
