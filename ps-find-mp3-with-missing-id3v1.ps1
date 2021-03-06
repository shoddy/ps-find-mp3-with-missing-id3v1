$scriptPath = Split-Path $MyInvocation.MyCommand.Path
$tagLibAssembly = Join-Path $scriptPath "taglib-sharp-2.1.0.0\taglib-sharp.dll"
[System.Reflection.Assembly]::LoadFile($tagLibAssembly)

$baseFolder = "\\readynas\music"
Write-Host "The following files in $baseFolder have Id3v2 tags, but no Id3v1. They will not work reliably on older MP3 players..."
foreach ($file in Get-ChildItem $baseFolder -Recurse -Filter "*.mp3")
{
	$filePath = $file.FullName
	
	$mediaFile = [taglib.file]::create($filePath)
	
	$hasV1 = $mediaFile.TagTypes -band [TagLib.TagTypes]::Id3v1
	$hasV2 = $mediaFile.TagTypes -band [TagLib.TagTypes]::Id3v2
	if ($hasV2 -and -not $hasV1)
	{
		Write-Host "  $filePath"
	}
	
	$mediaFile.Dispose()
}