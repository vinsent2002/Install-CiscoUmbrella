$CACertHash = "A122D4080A26C1DA986BD0E7202B1630EB661A624915EF244F496FDD306E85FB"
$OrgInfoHash = "Your_hash"
$CiscoUmbCACertThubPrt = "c5091132e9adf8ad3e33932ae60a5c8fa939e824"

if ($OrgInfoHash -ne (Get-FileHash $PSScriptRoot\Profiles\umbrella\OrgInfo.json).Hash) {

    Write-Host "File OrgInfo.json does not exist or corrupted!" -ForegroundColor White -BackgroundColor Red
    exit 1

}

if ($CACertHash -ne (Get-FileHash $PSScriptRoot\Cisco_Umbrella_Root_CA.cer).Hash) {
    
    Write-Host "File Cisco_Umbrella_Root_CA.cer does not exist or corrupted!" -ForegroundColor White -BackgroundColor Red
    exit 1

}

Start-process msiexec -ArgumentList "/package cisco-secure-client-win-5.1.4.74-core-vpn-predeploy-k9.msi PRE_DEPLOY_DISABLE_VPN=1 /norestart /passive" -NoNewWindow -Wait -WorkingDirectory $PSScriptRoot
Start-process msiexec -ArgumentList "/package cisco-secure-client-win-5.1.4.74-umbrella-predeploy-k9.msi PRE_DEPLOY_DISABLE_VPN=1 /norestart /passive" -NoNewWindow -Wait -WorkingDirectory $PSScriptRoot
Start-process msiexec -ArgumentList "/package cisco-secure-client-win-5.1.4.74-dart-predeploy-k9.msi /norestart /passive" -NoNewWindow -Wait -WorkingDirectory $PSScriptRoot

Set-Location -Path Cert:\LocalMachine\Root
Import-Certificate -Filepath $PSScriptRoot\Cisco_Umbrella_Root_CA.cer | Out-Null

If (!(Get-ChildItem | Where-Object {$_.Thumbprint -eq $CiscoUmbCACertThubPrt})) {
    
    Write-Host "Cisco Umbrella Root CA certificate was not installed!" -ForegroundColor White -BackgroundColor Red

}
