#!/bin/bash

REPO="Martybb01/formazione_sou"

API_URL="https://api.github.com/repos/$REPO"

generate_html() {
  local name="$1"
  local description="$2"
  local stars="$3"
  local forks="$4"
  local open_issues="$5"
  local last_commit="$6"

  cat <<HTML > /var/www/html/github-monitor/index.html
<!DOCTYPE html>
<html>
<head>
    <title>GitHub Repo Monitor</title>
</head>
<body>
    <h1>GitHub Repo Monitor: $name</h1>
    <p><strong>Description:</strong> $description</p>
    <p><strong>Stars:</strong> $stars</p>
    <p><strong>Forks:</strong> $forks</p>
    <p><strong>Open Issues:</strong> $open_issues</p>
    <p><strong>Last Commit:</strong> $last_commit</p>
</body>
</html>
HTML
}

response=$(curl -s "$API_URL")

name=$(echo "$response" | jq -r '.name')
description=$(echo "$response" | jq -r '.description')
stars=$(echo "$response" | jq -r '.stargazers_count')
forks=$(echo "$response" | jq -r '.forks_count')
open_issues=$(echo "$response" | jq -r '.open_issues_count')
last_commit=$(echo "$response" | jq -r '.updated_at')

generate_html "$name" "$description" "$stars" "$forks" "$open_issues" "$last_commit"
