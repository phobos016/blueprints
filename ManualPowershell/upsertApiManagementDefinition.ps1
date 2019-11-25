Import-Module $PSScriptRoot\BPShared.psm1 -force
$blueprintName = "CoreApiManagement"
upsertAndPublishBlueprint -bpName $blueprintName