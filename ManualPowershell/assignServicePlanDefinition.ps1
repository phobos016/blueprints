param(
    [Parameter(Mandatory = $true)]
    [string] $serviceName,
    [Parameter(Mandatory = $true)]
    [string] $environment,
    [Parameter(Mandatory = $true)]
    [string] $bpVersion
)

$blueprintDefinitionName = "CoreServicePlan"

Import-Module $PSScriptRoot\BPShared.psm1 -force

$rgParameters = @{
    AppServicePlanRG=@{
        Location="uksouth"
        Name="$($serviceTypeName)-$($projectName)-$($environment)"
    }
}

$bpParameters = @{
    serviceTypeName = $serviceName
    environmentName = $environment
    createApplicationInsightsFlag='true'
    skuName='S1'
    skuTier="Standard"
}

upsertAssignation `
    -assignedName "$($blueprintDefinitionName)-$($serviceName)-$($environment)-plan" `
    -bpName $blueprintDefinitionName `
    -bpVersion $bpVersion `
    -rgParameters $rgParameters `
    -bpParameters $bpParameters `
    -managementLocation $rgParameters.AppServicePlanRG.Location


