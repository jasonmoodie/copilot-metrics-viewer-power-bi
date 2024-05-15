# Using Power BI with GitHub Copilot Metrics API
With the release of the [GitHub Copilot Metrics API](https://github.blog/changelog/2024-04-23-github-copilot-metrics-api-now-available-in-public-beta/) many teams are looking to leverage this data to help monitor usage against their KPIs. For many, the Copilot Metrics Viewer ([github-copilot-resources/copilot-metrics-viewer](https://github.com/github-copilot-resources/copilot-metrics-viewer)) might be a great option. 

However, many organizations that we work with already have established Power BI teams. If your organization is **already using Power BI, please read on!**

Located in the  `./samples` directory you'll find sample JSON and PBIX files used to create the dashboard below.

![Image of a Power BI dashboard with GitHuub Copilot Metrics API data displayed.](https://github.com/jasonmoodie/pbi-4-ghcopilot/blob/main/assets/Sample_PBI.png)

## Modify the data source
> Note: This example provided a proof of concept for loading metrics data and requires an exported JSON file. If you have access to the REST API you can configure the **Source** accordingly.

1. Download and open the sample `GitHub Copilot - Telemetry Sample (DM).pbix` file
2. The file contains three data sources on the right hand side.

| Name                  | Description                                            |
| :-------------------- | :----------------------------------------------------- |
| GH Copilot - Details  | Detailed breakdown of metrics data by language and editor. |
| GH Copilot - Summary  | Daily summary of metrics data.                       |
| Last Refresh          | Used to display the data time of data refresh on the top-right corner of the dashboard. |

3. Open the **Power Query Editor** by right clicking the `GH Copilot - Details` and selecting **Edit query**. 
4. Modify the **Source** step by clicking the settings icon, selecting your JSON file and clicking **OK**.
![Image of a data source selector in Power Query Editor.](https://github.com/jasonmoodie/pbi-4-ghcopilot/blob/main/assets/Modify_JSON_source.png)
5. Repeat steps 3 and 4 for the `GH Copilot - Summary` **Source**.
6. Click **Close and Apply** in the top-left of the **Power Query Editor**.
7. On the **Report View** page click **Refresh** to load the new data into your dashboard.
8. **Happy Customizing!**




