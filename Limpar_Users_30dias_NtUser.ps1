$excecoes ="Public","Administrador","Administrator","Público","Default","Suporte", "admin", "administrador", "administrator", "Admin", "TEMP"

$dias = 30

$profiles = Get-WMIObject -class Win32_UserProfile | Where {(!$_.Special -and $_.Loaded -eq $false )}

$dataatual = Get-Date -format g

Write-Host "" | Out-String
Write-Host "" | Out-String
Write-Host "******************" $dataatual "******************" | Out-String 
Write-Host "" | Out-String
Write-Host "" | Out-String

foreach ($profile in $profiles) {
        if (!($excecoes -like $profile.LocalPath.Replace("C:\Users\",""))) {

            Write-host("$($profile.localpath)\NTUSER.dat" + ' existe?') | Out-String
            if (Test-Path -Path "$($profile.localpath)\NTUSER.dat") {

                Write-Host('Path ' + "$($profile.localpath)\NTUSER.dat" + ' existe.') | Out-String

                $lastwritetime = (Get-ChildItem -Path "$($profile.localpath)\NTUSER.dat" -Force ).LastWriteTime

                if ($lastwritetime -lt (Get-Date).AddDays(-$dias)) {
                    Write-Host('[DELEÇÃO DE USUÁRIO] Removendo: ' + $profile.LocalPath.Replace("C:\Users\","") + ' pois tem mais de ' + $dias + ' dias.') | Out-String
                    $profile | Remove-WmiObject #-WhatIf
                }

                else { 
                    Write-Host('[USUÁRIO MANTIDO] ' + $profile.LocalPath.Replace("C:\Users\","") + ' - não tem mais de ' + $dias + ' dias e não será deletado.') | Out-String
                }
            }
        
           else { 
            Write-Host('Path ' + "$($profile.localpath)\NTUSER.dat" + ' não existe.') | Out-String
           }
        }
} 

#Read-Host -Prompt “Pressione Enter para sair”