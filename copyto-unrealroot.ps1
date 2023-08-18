# Copies the workspace to the Plugins\Runtime folder under $ueroot.
# $ueroot is the Unreal code root folder (the one which contains e.g. Engine and LICENSE.md)
param (
	[Parameter(Mandatory = $true)]
	[string]$ueroot
)

$pluginName = "HoudiniEngine"
$pluginRoot = join-path $ueroot "Engine\Plugins\Runtime\$pluginName"

$files = (git ls-tree -r --name-only embark-5.2) | Select-String "\.ps1$" -NotMatch
$files | ForEach-Object {
	$src = $_
	if (test-path $src -PathType Leaf) {
		$dest = (join-path $pluginRoot $src)
		(New-Item -Path (Split-Path -Path $dest) -Type Directory -ErrorAction SilentlyContinue)
		copy-item $src $dest
	}
}

$sha = (git rev-parse HEAD)
$origin = (git remote get-url --push origin)
$branch = (git branch --show-current)

$infoPath = (join-path $pluginRoot "PLUGIN_ORIGIN.json")
if (Test-Path $infoPath) {
	remove-item $infoPath
}

$pluginOrigin = New-Item -ItemType File -Path $infoPath
"{" >> $pluginOrigin
"  `"origin`": `"$origin`"," >> $pluginOrigin
"  `"branch`": `"$branch`"," >> $pluginOrigin
"  `"commit`": `"$sha`"" >> $pluginOrigin
"}" >> $pluginOrigin
