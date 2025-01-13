$source_folder = Read-Host "Digite o caminho da pasta em que as outras pastas estao (ex: C:\nome_da_pasta)"

if (-Not (Test-Path $source_folder)) {
    Write-Output "Caminho invalido, confira e tente denovo!"
}

$folders = Get-ChildItem -Path $source_folder -Directory

if ($folders.Count -eq 0) {
    Write-Output "Nenhuma pasta encontrada"
    exit
}

$folders_paths = $folders.FullName -join ','

Write-Output "Pastas encontradas: $folders_paths"

$folders_path_array = $folders_paths -split ','

Write-Output "Caminhos separados por virgula"
$folders_path_array | ForEach-Object {Write-Output $_}