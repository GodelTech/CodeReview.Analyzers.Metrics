$artsPath = "C:\artifacts\";
$exclude = [System.Environment]::GetEnvironmentVariable("METRICS_EXCLUDE");
if ($exclude -eq $null) {
    $excludedProjects = @();
} else {
    $excludedProjects = $exclude.Split(",");
}

$location = Get-Location;
$projects = Get-ChildItem "*.csproj" -Recurse -Exclude $excludedProjects;
foreach ($project in $projects) {
    Set-Location $project.Directory;
    dotnet add $project.Name package Microsoft.CodeAnalysis.Metrics
    dotnet build $project.Name -t:Metrics
    dotnet remove $project.Name package Microsoft.CodeAnalysis.Metrics
    Move-Item ($project.BaseName + ".Metrics.xml") $artsPath -Force
}

Set-Location $location;