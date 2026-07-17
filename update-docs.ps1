# Publica las invitaciones de src/ a docs/ (GitHub Pages).
#   src/blue-min.html        -> docs/single/index.html
#   src/blue-min-double.html -> docs/double/index.html
# Ademas sincroniza css/, js/ y las fotos referenciadas.
# docs/index.html es una redireccion manual a ./single/ y NO se toca.

$base = $PSScriptRoot

function Publish-Page($srcFile, $outDir) {
    $html = [System.IO.File]::ReadAllText("$base\src\$srcFile")

    # Reescribe rutas relativas: la pagina publicada vive un nivel mas abajo (docs/<outDir>/)
    $html = $html -replace 'href="css/', 'href="../css/'
    $html = $html -replace 'src="assets/', 'src="../assets/'
    $html = $html -replace 'src="js/', 'src="../js/'

    # og:url apunta al subdirectorio publicado
    $html = $html -replace '(property="og:url" content="[^"]*?/wedding_invites/)[^"]*', "`$1$outDir/"

    $outPath = "$base\docs\$outDir"
    New-Item -ItemType Directory -Force $outPath | Out-Null
    [System.IO.File]::WriteAllText("$outPath\index.html", $html, [System.Text.Encoding]::UTF8)
    Write-Host "docs/$outDir/index.html actualizado desde src/$srcFile"

    # Devuelve las fotos referenciadas (decodificando %20 etc.) para copiarlas
    [regex]::Matches($html, 'src="\.\./(assets/photos/[^"]+)"') | ForEach-Object {
        [uri]::UnescapeDataString($_.Groups[1].Value)
    }
}

$photos = @()
$photos += Publish-Page "blue-min.html" "single"
$photos += Publish-Page "blue-min-double.html" "double"

# Sincroniza css y js completos
Copy-Item "$base\src\css\*" "$base\docs\css\" -Recurse -Force
Copy-Item "$base\src\js\*" "$base\docs\js\" -Recurse -Force

# Copia solo las fotos referenciadas + ring.jpg (og:image)
$photos += "assets/photos/ring.jpg"
New-Item -ItemType Directory -Force "$base\docs\assets\photos" | Out-Null
$photos | Sort-Object -Unique | ForEach-Object {
    Copy-Item "$base\src\$($_.Replace('/', '\'))" "$base\docs\assets\photos\" -Force
}

Write-Host "`ndocs/ listo para GitHub Pages (docs/index.html redirige a ./single/ y no se modifica)."
