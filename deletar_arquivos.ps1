$path = Read-Host "Digite o caminho da pasta que estão os arquivos para serem deletados (ex: C:\arquivos): ".ToLower()

if (-Not (Test-Path $path)) {
    Write-Output "Caminho inválido! Veja se o caminho oferecido está correto."
    exit
}

$extension = Read-Host "Digite a extensão dos arquivos a serem excluidos (ex: txt): ".ToLower()
$files = Get-ChildItem -Path $path -Filter *.$extension -File

if ($files.Count -eq 0) {
    Write-Output "Nenhum arquivo encontrado com a extensão .$extension na pasta $path"
    exit
} else {
    Write-Output "Arquivos encontrados:"
    $files | ForEach-Object {$_.FullName}

    $confirmation = Read-Host "Deseja realmente excluir os arquivos (s/n)? ".ToLower()
    if ($confirmation -eq "s") {
        $files | Remove-Item -Force
        Write-Output "Arquivos .$extension na pasta $path deletados."
    } else {
        Write-Output "Operação cancelada!"
    }
}
