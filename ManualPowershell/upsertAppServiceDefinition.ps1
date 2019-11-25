Import-Module $PSScriptRoot\BPShared.psm1 -force
$blueprintName = "CoreAppService"
upsertAndPublishBlueprint -bpName $blueprintName