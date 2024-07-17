1. In your ADO organization you first need to install `Power BI Actions`.  [Power BI Actions Extension!](https://marketplace.visualstudio.com/items?itemName=maikvandergaag.maikvandergaag-power-bi-actions)

![Screenshot 2024-07-17 at 8.19.15 AM.png](/.attachments/Screenshot%202024-07-17%20at%208.19.15 AM-062f9c11-0286-4e88-9ac1-da90eabad8c5.png =600x)

1. Get the PBI Workspace ID. Open Powershell in Administrative Mode and run: 
### Install Power BI Management module  
  `Install-Module -Name MicrosoftPowerBIMgmt -Scope CurrentUser -Force`
  
### Sign in to Power BI  
   `Login-PowerBI`
  
### List all workspaces
  `Get-PowerBIWorkspace -Scope Organization`

Write down the Workpace ID:

#Create the App Registration
1. Go to Entra AD
![Screenshot 2024-07-17 at 8.04.48 AM.png](/.attachments/Screenshot%202024-07-17%20at%208.04.48 AM-41944f47-aaab-415b-9cb9-e75ab5ec5967.png =600x)
1. Set `API Permissions -> Add a permission`
1. Power BI Service 
1. Chose Delegated permissions
1. Chose: 
  - Tenant.Read.All
  - Tenant.ReadWrite.All
  - Report.ReadWrite.All
![Screenshot 2024-07-17 at 8.06.50 AM.png](/.attachments/Screenshot%202024-07-17%20at%208.06.50 AM-f9a7ce5a-6e64-4475-a4ec-eaec70089f50.png =600x)

#Power BI
 
Setting up the tenant
The next step is to configure your Power BI,

1. Sign in to the Power BI portal.
1. Click the gear icon on the top right and select Admin portal.
1. Select the Tenant settings and scroll down to Developer Settings and allow service principals to use Power BI APIs
![Screenshot 2024-07-17 at 7.53.01 AM.png](/.attachments/Screenshot%202024-07-17%20at%207.53.01 AM-79bb65df-dfc9-4989-86c1-146f60b49600.png)

#Configure a workspace
Now create the workspace where your pipeline will publish the reports and grant permission to your Azure AD App to do this,

1. Select Workspaces tab.
1. Click the three vertical dots on the right of your new workspace.
1. Click Manage access.
![Screenshot 2024-07-17 at 8.02.30 AM.png](/.attachments/Screenshot%202024-07-17%20at%208.02.30 AM-5acc2b30-bb83-4bbb-88d1-153c2f4216fd.png)

1. Search the app that you have previously registered in Azure AD and grant it the permission of **Admin**.
![Screenshot 2024-07-17 at 7.58.15 AM.png](/.attachments/Screenshot%202024-07-17%20at%207.58.15 AM-361bfcf7-4837-4d56-8918-87514c7286b7.png =600x)

#Azure DevOps
 
Install the extension
These instructions will show you how to install the Power BI Action extension that we are going to use for this tutorial,

1. Sign in to your Azure DevOps organization.
1. Go to Organization Settings.
1. Select Extensions.
1. Click on Browse Marketplace at the top right.

#Create a new service connection
1. Go to Project Settings.
1. Select Service connections.
1. Click the New service connection button and select Power BI Service Connection.
![Screenshot 2024-07-17 at 8.11.27 AM.png](/.attachments/Screenshot%202024-07-17%20at%208.11.27 AM-e5f10640-66ba-4961-b4bc-88a33760cd22.png =600x)
1. Fill in the parameters for the service connection and allow all pipelines to use this connection option.
1. Click OK to create the connection.
![Screenshot 2024-07-17 at 8.14.41 AM.png](/.attachments/Screenshot%202024-07-17%20at%208.14.41 AM-99f4ceb3-9e59-4c91-a105-3a32532f7248.png =600x)

#Creating the Build Pipeline
It is time to create your build pipeline.

1. From the dashboard, select Pipelines.
1. Click the New pipeline button.
1. Select Azure Git Repos as a source that will trigger our pipeline.
1. Azure DevOps will suggest several templates, select the Starter Pipeline, to begin with a bare bone pipeline.
1. Create 4 variables for:
  - AppId
  - AppSecret
  - TenantId
  - WorkspaceId
![Screenshot 2024-07-17 at 8.16.38 AM.png](/.attachments/Screenshot%202024-07-17%20at%208.16.38 AM-5668d9bb-fda4-4102-95c9-84f6f8418a29.png =600x)

1. Add the following YAML snippet to your pipeline
``` yaml
trigger:
- main

pool:
  vmImage: 'ubuntu-latest'

steps:
 Install Power BI Actions
- task: PowerShell@2
  inputs:
    targetType: 'inline'
    script: |
      Install-Module -Name MicrosoftPowerBIMgmt -Scope CurrentUser -Force
      Install-Module -Name MicrosoftPowerBIMgmt.Profile -Scope CurrentUser -Force
      Install-Module -Name MicrosoftPowerBIMgmt.Reports -Scope CurrentUser -Force
  displayName: 'Install Power BI Actions'

Deploy PBIX file using PowerShell with Service Principal Authentication
- task: PowerShell@2
  inputs:
    targetType: 'inline'
    script: |
      # Authenticate with Power BI Service using Service Principal
      $tenantId = "$(TenantId)"
      $appId = "$(AppId)"
      $appSecret = "$(AppSecret)"
      $secureAppSecret = ConvertTo-SecureString -String $appSecret -AsPlainText -Force
      $credential = New-Object System.Management.Automation.PSCredential($appId, $secureAppSecret)
      Connect-PowerBIServiceAccount -ServicePrincipal -Credential $credential -Tenant $tenantId
      
      # Ensure the MicrosoftPowerBIMgmt.Reports module is imported
      Import-Module MicrosoftPowerBIMgmt.Reports

      # Publish PBIX file
      New-PowerBIReport -Path './samples/GitHubCopilotTelemetrySample.pbix' -WorkspaceId "$(WorkspaceId)" -Name 'copilot_metrics_usage_sample'
      
      # Note: Ensure that the necessary modules and credentials are correctly set up for this script to work.
  displayName: 'Deploy PBIX file to Power BI Workspace using PowerShell'
```
The remaining step is to save, check-in, and then watch it automatically deply







