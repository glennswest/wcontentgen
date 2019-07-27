Write-Output "Docker Install Starting"
if (Get-Service docker -ErrorAction SilentlyContinue)
{
    Stop-Service docker
}

# Download the zip file.
$json = Invoke-WebRequest -UseBasicparsing https://download.docker.com/components/engine/windows-server/index.json | ConvertFrom-Json
$version = $version = $json.channels.'18.09'.version
$url = $json.versions.$version.url
$zipfile = Join-Path "$env:USERPROFILE\Downloads\" $json.versions.$version.url.Split('/')[-1]
Invoke-WebRequest -UseBasicparsing -Outfile $zipfile -Uri $url

# Extract the archive.
Expand-Archive $zipfile -DestinationPath $Env:ProgramFiles -Force

# Modify PATH to persist across sessions.
$newPath = [Environment]::GetEnvironmentVariable("PATH",[EnvironmentVariableTarget]::Machine) + ";$env:ProgramFiles\docker"
$splittedPath = $newPath -split ';'
$cleanedPath = $splittedPath | Sort-Object -Unique
$newPath = $cleanedPath -join ';'
[Environment]::SetEnvironmentVariable("PATH", $newPath, [EnvironmentVariableTarget]::Machine)
$env:path = $newPath

# Register the Docker daemon as a service.
if (!(Get-Service docker -ErrorAction SilentlyContinue)) {
  dockerd --exec-opt isolation=process --register-service
}

Get-HnsNetwork | Where-Object { $_.Name -eq "nat" } | Remove-HnsNetwork
$configFile = Join-Path $env:ProgramData "Docker\config\daemon.json"
$configDir = Split-Path -Path $configFile -Parent
if(!(Test-Path $configDir)) {
    New-Item -ItemType "Directory" -Force -Path $configDir
    }
Set-Content -Path $configFile -Value '{ "bridge" : "none" }' -Encoding Ascii
Set-Service docker -StartupType Automatic
sc.exe failure docker reset=40 actions=restart/0/restart/0/restart/30000
if($LASTEXITCODE) {
    Throw "Failed to set failure actions"
    }
sc.exe failureflag docker 1
if($LASTEXITCODE) {
      Throw "Failed to set failure flags"
      }
Start-Service docker
Write-Output "Docker Install Finished"

