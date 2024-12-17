let
    // Replace <YOUR-TOKEN>, <ENTERPRISE> and <TEAM_SLUG> with your actual token and enterprise name.
    url = "https://api.github.com/enterprises/<ENTERPRISE>/team/<TEAM_SLUG>/copilot/metrics",
    headers = [
        #"Accept" = "application/vnd.github+json",
        #"Authorization" = "Bearer <YOUR-TOKEN>",
        #"X-GitHub-Api-Version" = "2022-11-28"
    ],
    Source = Json.Document(Web.Contents(url, [Headers=headers])),