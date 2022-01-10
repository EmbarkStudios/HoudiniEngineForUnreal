# Copies the Plugins\Runtime folder under $ueroot to here.
# $ueroot is the Unreal code root folder (the one which contains e.g. Engine and LICENSE.md)
param (
	[Parameter(Mandatory = $true)]
	[string]$ueroot
)

$pluginName = "HoudiniEngine"

$pluginRoot = join-path $ueroot "Engine\Plugins\Runtime\$pluginName"

$files = git ls-tree -r --name-only embark
$files | ForEach-Object {
	$dest = $_
	$src = (join-path $pluginRoot $dest)
	if ((test-path $dest -PathType Leaf) -and (test-path $src)) {
		copy-item $src $dest
	}
}
