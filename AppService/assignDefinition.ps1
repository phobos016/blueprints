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
    AppServiceRG=@{
        Location="uksouth"
    }
}

$bpParameters = @{
    projectName = $serviceName
    environmentName = $environment
    slotName='staging'
    alertRequestsRuleCriteriaThreshold='60'
    alertAppConnectionsRuleCriteriaThreshold='100'
    alertAverageResponseTimeRuleCriteriaThreshold='1'
    alertMemoryWorkingSetRuleCriteriaThreshold='536870912'
    alertHttpServerErrorsRuleCriteriaThreshold='0'
    actionGroupReceiverEmailAddress='azuremonitor@purplebricks.pagerduty.com'
    additionalCommonAppSettings=@{}
}

upsertAssignation `
    -assignedName "$($serviceName)-$($environment)-app-assignation" `
    -bpName 'AppService' `
    -bpVersion $bpVersion `
    -rgParameters $rgParameters `
    -bpParameters $bpParameters `
    -managementLocation $rgParameters.AppServiceRG.Location


