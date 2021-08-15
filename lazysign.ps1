$name = Read-Host -Prompt "Enter your name"
$file = Read-Host -Prompt "File to sign"

if (-not(Test-Path -Path $file)) {
    Write-Host "Error! File doesn't exists."
    Exit
}

if ($name) {
    New-SelfSignedCertificate -Type Custom `
                              -Subject "CN=$name" `
                              -CertStoreLocation Cert:\CurrentUser\My `
                              -TextExtension @('2.5.29.37={text}1.3.6.1.5.5.7.3.3')
    Set-AuthenticodeSignature -Certificate (Get-ChildItem -Path Cert:\CurrentUser\My | Select-Object -First 1) `
                              -TimestampServer "http://timestamp.digicert.com" `
                              -FilePath "$file"
}
else {
    Write-Host "Error! Name is empty."
}
