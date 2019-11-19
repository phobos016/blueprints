function upsertAndPublishBlueprint {
    param(
        [string] $blueprintName
    )
    Write-Host "Looking for $($blueprintName) BP"
    $existingBlueprint = Get-AzBlueprint -Name $blueprintName -ErrorAction SilentlyContinue
    if ($existingBlueprint) {
        Write-Host "$($blueprintName) Found - Updating" -Foreground Black -Background Green
        $lastVersion = $existingBlueprint.Versions[$existingBlueprint.Versions.Length - 1]
        $newVersion = $lastVersion.Substring(0, 2) + ([int]$lastVersion.Substring(2) + 1)
        Write-Host "Current Version : $($lastVersion), Incrementing to $($newVersion) then importing" -Foreground Black -Background Green
        Import-AzBlueprintWithArtifact -Name $blueprintName -InputPath ".\" -Force
        Write-Host "Import Done, Publishing Version $($newVersion)" -Foreground Black -Background Green
        Publish-AzBlueprint -Version $newVersion -Blueprint $existingBlueprint    
        Write-Host "$($blueprintName) successfully updated" -Foreground Black -Background Green
    } else {
        Write-Host "$($blueprintName) Not Found - Creating" -Foreground Black -Background Blue
        $newVersion = "1.0"
        Import-AzBlueprintWithArtifact -Name $blueprintName -InputPath ".\" -Force
        Write-Host "Import Done, Retrieving BP Version $($newVersion) then publishing" -Foreground Black -Background Blue
        $importedBlueprint = Get-AzBlueprint -Name $blueprintName
        Publish-AzBlueprint -Version $newVersion -Blueprint $importedBlueprint   
        Write-Host "$($blueprintName) successfully created" -Foreground Black -Background Blue
    }
}




