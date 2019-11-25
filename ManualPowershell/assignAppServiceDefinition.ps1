param(
    [Parameter(Mandatory = $true)]
    [string] $projectName,
    [Parameter(Mandatory = $true)]
    [string] $environment,
    [Parameter(Mandatory = $true)]
    [string] $serviceTypeName,
    [Parameter(Mandatory = $true)]
    [string] $bpVersion
)


Import-Module $PSScriptRoot\BPShared.psm1 -force

$blueprintDefinitionName = "CoreAppService"

$rgParameters = @{
    AppServiceRG=@{
        Location="uksouth"
        Name="$($serviceTypeName)-$($projectName)-$($environment)"
    }
}

$bpParameters = @{
    projectName = $projectName
    environmentName = $environment
    serviceTypeName = $serviceTypeName
    slotName='staging'
    alertRequestsRuleCriteriaThreshold='60'
    alertAppConnectionsRuleCriteriaThreshold='100'
    alertAverageResponseTimeRuleCriteriaThreshold='1'
    alertMemoryWorkingSetRuleCriteriaThreshold='536870912'
    alertHttpServerErrorsRuleCriteriaThreshold='0'
    actionGroupReceiverEmailAddress='azuremonitor@pagerduty.com'
    additionalCommonAppSettings=@{}
}

upsertAssignation `
    -assignedName "$($blueprintDefinitionName)-$($projectName)-$($environment)-app" `
    -bpName $blueprintDefinitionName `
    -bpVersion $bpVersion `
    -rgParameters $rgParameters `
    -bpParameters $bpParameters `
    -managementLocation $rgParameters.AppServiceRG.Location


