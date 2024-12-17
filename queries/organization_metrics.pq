let
    // Replace <YOUR-TOKEN> and <ORG> with your actual token and org name.
    url = "https://api.github.com/orgs/<ORG>/copilot/metrics",
    headers = [
        #"Accept" = "application/vnd.github+json",
        #"Authorization" = "Bearer <YOUR-TOKEN>",
        #"X-GitHub-Api-Version" = "2022-11-28"
    ],
    Source = Json.Document(Web.Contents(url, [Headers=headers])),