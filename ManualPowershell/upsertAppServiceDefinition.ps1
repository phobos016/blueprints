$parent = (Get-Item $PSScriptRoot).Parent
Import-Module $parent\BPShared.psm1 -force
$blueprintName = "CoreAppService"
upsertAndPublishBlueprint -bpName $blueprintName