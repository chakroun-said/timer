# Builds the PWA and deploys build/web to the EC2 nginx host.
#
#   .\tool\deploy-ec2.ps1
#   .\tool\deploy-ec2.ps1 -HostName 16.171.32.1 -KeyPath C:\keys\said.pem
#   .\tool\deploy-ec2.ps1 -ServerName timer.example.com   # after pointing DNS at the host
[CmdletBinding()]
param(
    [string]$HostName = "16.171.32.1",
    [string]$User = "ubuntu",
    [string]$KeyPath = "$HOME\Downloads\said.pem",
    # A trusted certificate (and therefore the install prompt) needs a DNS name;
    # sslip.io maps this one to the instance IP for free.
    [string]$ServerName = "16-171-32-1.sslip.io",
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$deployDir = Join-Path $repoRoot "deploy\ec2"
$buildDir = Join-Path $repoRoot "build\web"
$archive = Join-Path $repoRoot "build\web.tar.gz"
if (-not $ServerName) { $ServerName = $HostName }

if (-not (Test-Path $KeyPath)) { throw "SSH key not found: $KeyPath" }

if (-not $SkipBuild) {
    Push-Location $repoRoot
    try {
        & flutter build web --release --no-web-resources-cdn
        if ($LASTEXITCODE -ne 0) { throw "flutter build failed" }
    }
    finally { Pop-Location }
}

if (-not (Test-Path $buildDir)) { throw "Missing build output: $buildDir" }

# The archive is copied into /tmp on the host; only its extraction is privileged.
if (Test-Path $archive) { Remove-Item $archive -Force }
& tar -czf $archive -C $buildDir .
if ($LASTEXITCODE -ne 0) { throw "Failed to create $archive" }

& tar -tzf $archive | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Archive failed its integrity check: $archive" }
Start-Sleep -Milliseconds 500

$sshOpts = @("-i", $KeyPath, "-o", "BatchMode=yes", "-o", "StrictHostKeyChecking=accept-new")
$target = "$User@$HostName"

Write-Host "Uploading release to $target ..."
& ssh @sshOpts $target "rm -rf /tmp/wt-deploy && mkdir -p /tmp/wt-deploy"
if ($LASTEXITCODE -ne 0) { throw "Could not reach $target" }

& scp @sshOpts "$deployDir\workouts-timer.conf" "$deployDir\workouts-timer-app.conf" "$deployDir\install.sh" "${target}:/tmp/wt-deploy/"
if ($LASTEXITCODE -ne 0) { throw "Upload failed" }

# Windows can still be flushing a freshly written archive when the copy starts,
# which silently truncates the upload. Re-hash and re-upload until the bytes on
# the host both match the local file and list as a valid archive.
$verified = $false
for ($attempt = 1; $attempt -le 3; $attempt++) {
    $localSize = (Get-Item $archive).Length
    $localHash = (Get-FileHash $archive -Algorithm SHA256).Hash.ToLower()

    & scp @sshOpts $archive "${target}:/tmp/wt-deploy/web.tar.gz"
    if ($LASTEXITCODE -ne 0) { throw "Upload failed" }

    $check = (& ssh @sshOpts $target "sha256sum /tmp/wt-deploy/web.tar.gz; tar -tzf /tmp/wt-deploy/web.tar.gz >/dev/null 2>&1 && echo ARCHIVE_OK || echo ARCHIVE_BAD") -join "`n"
    $remoteHash = ($check -split "`n")[0].Trim().Split(" ")[0].ToLower()
    if ($remoteHash -eq $localHash -and $check -match "ARCHIVE_OK") {
        Write-Host "Uploaded $localSize bytes."
        $verified = $true
        break
    }
    Write-Warning "Upload verification failed (attempt $attempt); retrying."
    Start-Sleep -Seconds 1
}
if (-not $verified) { throw "Could not upload a valid archive to $target" }

# Files created on Windows carry CRLF line endings, which break bash and nginx.
Write-Host "Installing on $target ..."
& ssh @sshOpts $target "sed -i 's/\r$//' /tmp/wt-deploy/install.sh /tmp/wt-deploy/workouts-timer.conf /tmp/wt-deploy/workouts-timer-app.conf && SERVER_NAME='$ServerName' bash /tmp/wt-deploy/install.sh"
if ($LASTEXITCODE -ne 0) { throw "Remote install failed" }

$status = & curl.exe -k -s -o NUL -w "%{http_code}" "https://$ServerName/"
Write-Host "https://$ServerName/ -> HTTP $status"
if ($status -ne "200") { throw "Deployed, but the site did not answer with 200" }

Write-Host "Deployment complete: https://$ServerName/"
