$parent = (Get-Item $PSScriptRoot).Parent
Import-Module $parent\BPShared.psm1 -force
$blueprintName = "CoreApiManagement"
upsertAndPublishBlueprint -bpName $blueprintName