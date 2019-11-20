param(
    [Parameter(Mandatory = $true)]
    [string] $serviceName,
    [Parameter(Mandatory = $true)]
    [string] $environment,
    [Parameter(Mandatory = $true)]
    [string] $bpVersion
)

$parent = (Get-Item $PSScriptRoot).Parent
Import-Module $parent\BPShared.psm1 -force

$rgParameters = @{
    AppServicePlanRG=@{
        Location="uksouth"
    }
}

$bpParameters = @{
    projectName = $serviceName
    environmentName = $environment
    createApplicationInsightsFlag='true'
    skuName='S1'
    skuTier="Standard"
}

upsertAssignation `
    -assignedName "$($serviceName)-$($environment)-plan-assignation" `
    -bpName 'AppServicePlan' `
    -bpVersion $bpVersion `
    -rgParameters $rgParameters `
    -bpParameters $bpParameters `
    -managementLocation $rgParameters.AppServicePlanRG.Location


