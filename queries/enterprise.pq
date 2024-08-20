let
    // Replace <YOUR-TOKEN> and <ENTERPRISE> with your actual token and enterprise name.
    url = "https://api.github.com/enterprises/<ENTERPRISE>/copilot/usage",
    headers = [
        #"Accept" = "application/vnd.github+json",
        #"Authorization" = "Bearer <YOUR-TOKEN>",
        #"X-GitHub-Api-Version" = "2022-11-28"
    ],
    Source = Json.Document(Web.Contents(url, [Headers=headers]))
in
    Source