param(
    [Parameter(Mandatory = $true)]
    [string] $serviceName,
    [Parameter(Mandatory = $true)]
    [string] $environment,
    [Parameter(Mandatory = $true)]
    [string] $bpVersion
)

$blueprintDefinitionName = "CoreApiManagement"

Import-Module $PSScriptRoot\BPShared.psm1 -force

$rgParameters = @{
    ApimRG=@{
        Location="uksouth"
        name="$($serviceName)-$($environment)"
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
    -assignedName "$($serviceName)-$($environment)-apim" `
    -bpName $blueprintDefinitionName `
    -bpVersion $bpVersion `
    -rgParameters $rgParameters `
    -bpParameters $bpParameters `
    -managementLocation $rgParameters.AppServicePlanRG.Location


