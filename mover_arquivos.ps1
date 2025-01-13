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

$move_to_path = Read-Host "Digite o caminho da pasta que quer mover os arquivos (ex: D:\pasta_destino)"

if (-Not (Test-Path $move_to_path)) {
    Write-Output "Caminho inválido, confira se o caminho está correto!"
}

$extension = Read-Host "Digite a extensao dos arquivos que serão movidos (ex: txt) ".ToLower()
$total_files = @()

foreach ($path in $folders_path_array) {
    $files = Get-ChildItem -Path $path -Filter *.$extension -File -ErrorAction SilentlyContinue
    if ($files.Count -gt 0) {
        $total_files += $files
    } else {
        Write-Output "Nenhum arquivo de .$extension encontrado na pasta $path"
    }

}

if ($total_files.Count -eq 0) {
    Write-Output "Nenhum arquivo encontrado com a extensao .$extension nas pastas fornecidas"
    exit
} else {
    Write-Output "Arquivos encontrados: "
    $total_files | ForEach-Object {$_.FullName}

    $confirmation = Read-Host "Deseja realmente mover os arquivos (s/n)? ".ToLower()
    if ($confirmation -eq "s") {
        foreach ($file in $total_files) {
            try {
                Move-Item -Path $file.FullName -Destination $move_to_path -ErrorAction Stop
                Write-Output "Arquivo movido: $($file.FullName)"
            }
            catch {
                Write-Output "Erro ao mover arquivo: $($file.FullName). Erro: $_"
            }
        }

        foreach($path in $folders_path_array) {
            try {
                if ((Get-ChildItem -Path $path -Recurse -ErrorAction SilentlyContinue).Count -eq 0) {
                    Remove-Item -Path $path -Recurse -Force -ErrorAction Stop
                    Write-Output "Pasta excluída: $path"
                } else {
                    Write-Output "Pasta não foi excluída: $path. Pois tem arquivos dentro"
                }
            }
            catch {
                Write-Output "Erro ao excluir pasta: $path. Erro: $_"
            }
        }

        Write-Output "Arquivos .$extension foram movidos para a pasta $move_to_path. E todas as pastas de origem foram excluídas"
    } else {
        Write-Output "Operação cancelada!"
    }
}
