function upsertAndPublishBlueprint {
    param(
        [string] $bpName
    )
    Write-Host "Looking for $($bpName) BP"
    $existingBlueprint = Get-AzBlueprint -Name $bpName -ErrorAction SilentlyContinue
    if ($existingBlueprint) {
        Write-Host "$($bpName) Found - Updating" -Foreground Black -Background Green
        $lastVersion = $existingBlueprint.Versions[$existingBlueprint.Versions.Length - 1]
        $newVersion = $lastVersion.Substring(0, 2) + ([int]$lastVersion.Substring(2) + 1)
        Write-Host "Current Version : $($lastVersion), Incrementing to $($newVersion) then importing" -Foreground Black -Background Green
        Import-AzBlueprintWithArtifact -Name $bpName -InputPath ".\" -Force
        Write-Host "Import Done, Publishing Version $($newVersion)" -Foreground Black -Background Green
        Publish-AzBlueprint -Version $newVersion -Blueprint $existingBlueprint    
        Write-Host "$($bpName) successfully updated" -Foreground Black -Background Green
    } else {
        Write-Host "$($bpName) Not Found - Creating" -Foreground Black -Background Blue
        $newVersion = "1.0"
        Import-AzBlueprintWithArtifact -Name $bpName -InputPath ".\" -Force
        Write-Host "Import Done, Retrieving BP Version $($newVersion) then publishing" -Foreground Black -Background Blue
        $importedBlueprint = Get-AzBlueprint -Name $bpName
        Publish-AzBlueprint -Version $newVersion -Blueprint $importedBlueprint   
        Write-Host "$($bpName) successfully created" -Foreground Black -Background Blue
    }
}

function upsertAssignation {
    param(
        [string] $assignedName,
        [string] $bpName,
        [string] $bpVersion,
        [hashtable] $rgParameters,
        [hashtable] $bpParameters,
        [string] $managementLocation
    )

    $bpDefinition = Get-AzBlueprint -Name $bpName -Version $bpVersion -ErrorAction SilentlyContinue
    if (!$bpDefinition) {
        Write-Host "Cannot find BP Definition : $($bpName)" -Foreground Black -Background Red
    } else {
        $existingAssignment = Get-AzBlueprintAssignment -Name $assignedName -ErrorAction SilentlyContinue
        if ($existingAssignment){
            Write-Host "Assignment $($assignedName) Found - Updating" -Foreground Black -Background Green
            Set-AzBlueprintAssignment `
                -Name $assignedName `
                -Blueprint $bpDefinition `
                -Parameter $bpParameters `
                -Location $managementLocation `
                -ResourceGroupParameter $rgParameters
        } else {
            Write-Host "Assignment $($assignedName) Not Found - Creating" -Foreground Black -Background Blue
            New-AzBlueprintAssignment `
                -Name $assignedName `
                -Blueprint $bpDefinition `
                -Location $managementLocation `
                -Parameter $bpParameters `
                -ResourceGroupParameter $rgParameters
        }
    }
}




