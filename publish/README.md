# Publishing your PBI Report

The report can be published many different ways.  Publishing from PowerBI Desktop is likely the fastest.  For a more automated version which would include report version, you should use a repository.  Below are the instructions on how to deploy your report in Azure DevOps repos, into your Power BI Workspace using a Azure DevOps Pipeline.

### Installing the ADO Extension
 
Install the extension
These instructions will show you how to install the Power BI Action extension that we are going to use for this tutorial,

1. Sign in to your Azure DevOps organization.
1. Go to Organization Settings.
1. Select Extensions.
1. Click on Browse Marketplace at the top right.
1. Search for and install `Power BI Actions`.  [Power BI Actions Extension!](https://marketplace.visualstudio.com/items?itemName=maikvandergaag.maikvandergaag-power-bi-actions)
<img width="600" alt="Screenshot 2024-07-17 at 8 19 15 AM" src="https://github.com/user-attachments/assets/c79c98c2-55a4-4772-ba62-8cccc7a83bef">


### Get the PBI Workspace ID. Open Powershell in Administrative Mode and run: 
1. Install Power BI Management module  
  `Install-Module -Name MicrosoftPowerBIMgmt -Scope CurrentUser -Force`
  
1. Sign in to Power BI  
   `Login-PowerBI`
  
3. List all workspaces  
  `Get-PowerBIWorkspace -Scope Organization`

Write down the Workpace ID and save it for later

### Create the App Registration
1. Go to Entra AD
<img width="600" alt="Screenshot 2024-07-17 at 8 04 48 AM" src="https://github.com/user-attachments/assets/1f4af117-5383-42cb-8403-1f59c162486e">

1. Set `API Permissions -> Add a permission`
1. Power BI Service 
1. Chose Delegated permissions
1. Chose: 
  - Tenant.Read.All
  - Tenant.ReadWrite.All
  - Report.ReadWrite.All
<img width="600" alt="Screenshot 2024-07-17 at 8 06 50 AM" src="https://github.com/user-attachments/assets/238ed9b4-6caa-4f2c-8b13-4c0893dd4c67">

### Power BI
 
Setting up the tenant
The next step is to configure your Power BI,

1. Sign in to the Power BI portal.
1. Click the gear icon on the top right and select Admin portal.
1. Select the Tenant settings and scroll down to Developer Settings and allow service principals to use Power BI APIs
<img width="600" alt="Screenshot 2024-07-17 at 7 53 01 AM" src="https://github.com/user-attachments/assets/cb52ca8c-ada2-4446-ba43-b973f16bdcce">

### Configure a workspace
Now create the workspace where your pipeline will publish the reports and grant permission to your Azure AD App to do this,

1. Select Workspaces tab.
1. Click the three vertical dots on the right of your new workspace.
1. Click Manage access.
<img width="600" alt="Screenshot 2024-07-17 at 8 02 30 AM" src="https://github.com/user-attachments/assets/9cdcbc1e-a790-4c82-b0c5-c62277af104c">
    
4. Search the app that you have previously registered in Azure AD and grant it the permission of **Admin**.
<img width="600" alt="Screenshot 2024-07-17 at 7 58 15 AM" src="https://github.com/user-attachments/assets/5fed83f5-491b-4098-96fe-4a99fd8ba4bc">

### Create a new service connection
1. Go to Project Settings.
1. Select Service connections.
1. Click the New service connection button and select Power BI Service Connection.
<img width="600" alt="Screenshot 2024-07-17 at 8 11 27 AM" src="https://github.com/user-attachments/assets/b5dd095f-c210-43b5-b041-a00587b79226">

4. Fill in the parameters for the service connection and allow all pipelines to use this connection option.  Be sure to pick the type of _Service Principal_
1. Click OK to create the connection.
<img width="600" alt="Screenshot 2024-07-17 at 8 14 41 AM" src="https://github.com/user-attachments/assets/01b6f4c9-3290-4de4-b076-b7a5fdd1c757">


### Creating the Build Pipeline
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
<img width="600" alt="Screenshot 2024-07-17 at 8 16 38 AM" src="https://github.com/user-attachments/assets/0bbe7b5b-697c-4d4b-8f94-d8c8f8994903">



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
The remaining step is to save, check-in, and then watch it automatically deploy as the trigger is set to monitor the main branch







