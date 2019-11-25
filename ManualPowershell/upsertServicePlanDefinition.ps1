$parent = (Get-Item $PSScriptRoot).Parent
Import-Module $parent\BPShared.psm1 -force
$blueprintName = "CoreServicePlan"
upsertAndPublishBlueprint -bpName $blueprintName