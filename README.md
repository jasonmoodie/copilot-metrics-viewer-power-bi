# Using Power BI with GitHub Copilot Metrics API
With the release of the [GitHub Copilot Metrics API](https://github.blog/changelog/2024-04-23-github-copilot-metrics-api-now-available-in-public-beta/) many teams are looking to leverage this data to help monitor usage against their KPIs. For many, the Copilot Metrics Viewer ([github-copilot-resources/copilot-metrics-viewer](https://github.com/github-copilot-resources/copilot-metrics-viewer)) might be a great option. 

However, many organizations that we work with already have established Power BI teams. If your organization is **already using Power BI, please read on!**

Located in the  `./samples` directory you'll find sample JSON and PBIX files used to create the dashboard below.

![Image of a Power BI dashboard with GitHuub Copilot Metrics API data displayed.](https://github.com/jasonmoodie/pbi-4-ghcopilot/blob/main/assets/Sample_PBI.png)

## Modify the local JSON data source
> Note: This example provided a proof of concept for loading metrics data and requires an exported JSON file. If you have access to the REST API you can configure the **Source** accordingly.

1. Download and open the sample `GitHub Copilot - Telemetry Sample (DM).pbix` file.
2. The file contains three data sources on the right hand side.

| Name                  | Description                                            |
| :-------------------- | :----------------------------------------------------- |
| GH Copilot - Details  | Detailed breakdown of metrics data by language and editor. |
| GH Copilot - Summary  | Daily summary of metrics data.                       |
| Last Refresh          | Used to display the data time of data refresh on the top-right corner of the dashboard. |

3. Open the **Power Query Editor** by right clicking the `GH Copilot - Details` and selecting **Edit query**. 
4. Modify the **Source** step by clicking the settings icon, selecting your JSON file and clicking **OK**.  
   ![Image of a data source selector in Power Query Editor.](https://github.com/jasonmoodie/pbi-4-ghcopilot/blob/main/assets/Modify_JSON_source.png)
6. Repeat steps 3 and 4 for the `GH Copilot - Summary` **Source**.
7. Click **Close and Apply** in the top-left of the **Power Query Editor**.
8. On the **Report View** page click **Refresh** to load the new data into your dashboard.
9. **Happy Customizing!**

## Connect to Metrics API
> Notes: The REST API provides metrics for the previous 28 days and is refreshed daily with the previous days data. This is currently in beta, so please ensure you are using the latest version of the [REST API](https://docs.github.com/en/rest/copilot/copilot-usage).

In order to connect we'll need to generate a token and link to your metrics data:
1. Download and open the sample `GitHub Copilot - Telemetry Sample (DM).pbix` file.
2. Determine if you'll be using the `Enterprise` or `Organization` URL.
3. Follow the instructions below to generate a token with permissions to access the API:
   [REST API endpoints for GitHub Copilot usage metrics - GitHub Docs](https://docs.github.com/en/rest/copilot/copilot-usage)
>**IMPORTANT: Do not share this token and ensure you follow you organizations security policies.**
4. Open the **Power Query Editor** by right clicking the `GH Copilot - Details` and selecting **Edit query**. 
5. Select **Advanced editor**.  
   ![Image of Power Query Advanced Editor.](https://github.com/jasonmoodie/pbi-4-ghcopilot/blob/main/assets/Advanced_editor.png)
6. Replace the first 2 lines with following, ensure to replace <YOUR-TOKEN> and <ORG> with the values from step 1 and 2.  
  
**Organization**
  ```powerquery
  let
      // Replace <YOUR-TOKEN> and <ORG> with your actual token and enterprise name.
      url = "https://api.github.com/orgs/<ORG>/copilot/usage",
      headers = [
          #"Accept" = "application/vnd.github+json",
          #"Authorization" = "Bearer <YOUR-TOKEN>",
          #"X-GitHub-Api-Version" = "2022-11-28"
      ],
      Source = Json.Document(Web.Contents(url, [Headers=headers])),
  ```
**Enterprise**
  ```powerquery
  let
      // Replace <YOUR-TOKEN> and <ENTERPRISE> with your actual token and enterprise name.
      url = "https://api.github.com/enterprises/<ENTERPRISE>/copilot/usage",
      headers = [
          #"Accept" = "application/vnd.github+json",
          #"Authorization" = "Bearer <YOUR-TOKEN>",
          #"X-GitHub-Api-Version" = "2022-11-28"
      ],
      Source = Json.Document(Web.Contents(url, [Headers=headers])),
  ```
7. Your Power Query will look something like this:  
   ![Image of Power Query Advanced Editor.](https://github.com/jasonmoodie/pbi-4-ghcopilot/blob/main/assets/Advanced_editor_query.png)
8. Click **OK** to close the editor and select `Anonymous` authentication if prompted.
9. Repeat steps 4 and 8 for the `GH Copilot - Summary` **Source**.
10. Click **Close and Apply** in the top-left of the **Power Query Editor**.
11. On the **Report View** page click **Refresh** to load the new data into your dashboard.




