$servers = Get-Content servers.txt
$writableShares = @()
$readableShares = @()

foreach ($server in $servers) {
    Write-Host "`n[+] Server: $server" -ForegroundColor Cyan
    $shares = Get-NetShare -ComputerName $server
    
    foreach ($share in $shares) {
        $shareName = $share.Name
        $sharePath = "\\$server\$shareName"
        Write-Host "    - Share: $shareName" -ForegroundColor Yellow

        try {
            $files = Get-ChildItem -Path $sharePath -ErrorAction Stop
            Write-Host "        Readable: Yes" -ForegroundColor Green
            $readableShares += "[*] Readable Share: $sharePath"
        } catch {
            Write-Host "        Readable: No" -ForegroundColor Red
        }

        $testFile = "$sharePath\test.txt"
        try {
            Add-Content -Path $testFile -Value "Test" -ErrorAction Stop
            Remove-Item -Path $testFile -Force
            Write-Host "        Writable: Yes" -ForegroundColor Green
            $writableShares += "[*] Writable Share: $sharePath"
        } catch {
            Write-Host "        Writable: No" -ForegroundColor Red
        }
    }
}

if ($readableShares.Count -gt 0) {
    Write-Host "`n[+] Readable Shares:" -ForegroundColor Green
    $readableShares | ForEach-Object { Write-Host $_ -ForegroundColor Green }
} else {
    Write-Host "`n[-] No readable shares found." -ForegroundColor Red
}

if ($writableShares.Count -gt 0) {
    Write-Host "`n[+] Writable Shares:" -ForegroundColor Green
    $writableShares | ForEach-Object { Write-Host $_ -ForegroundColor Green }
} else {
    Write-Host "`n[-] No writable shares found." -ForegroundColor Red
}
