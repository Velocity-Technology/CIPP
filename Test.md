# CIPP API – VS Code Connection

## Credentials (from `.env`)

| Key | Value |
|---|---|
| Tenant ID | `5981eccf-7900-488b-8e15-62db85d3b37a` |
| Client ID | `cc0909f9-d025-4325-afed-dd4531c9e0c3` |
| Role | `editor` |
| API URL | `https://cipphvzwt.azurewebsites.net` |
| Token URL | `https://login.microsoftonline.com/5981eccf-7900-488b-8e15-62db85d3b37a/oauth2/v2.0/token` |

> **Note:** The client secret is stored in `.env` — never commit that file to source control.

## How to connect from VS Code

Open the integrated terminal and run:

```powershell
. .\cipp-connect.ps1
```

This will:
1. Load credentials from `.env`
2. Authenticate via OAuth2 client credentials flow
3. Expose the `Invoke-CIPPApi` helper function in your session

## Example API Calls

```powershell
# List all tenants
Invoke-CIPPApi -Endpoint '/api/ListTenants'

# Get alerts
Invoke-CIPPApi -Endpoint '/api/ListAlertsQueue'

# POST example
Invoke-CIPPApi -Endpoint '/api/SomeEndpoint' -Method POST -Body @{ key = 'value' }
```

## Auth Flow

```
VS Code terminal
    → POST /oauth2/v2.0/token  (client_credentials)
    ← access_token
    → GET /api/<endpoint>  (Bearer token)
    ← JSON response
```
