$base = $PSScriptRoot

function Inline-Html($srcFile, $outFile) {
    $html = [System.IO.File]::ReadAllText("$base\src\$srcFile")

    # Inline CSS: replace each <link rel="stylesheet" href="..."> with its content
    $html = [regex]::Replace($html, '<link rel="stylesheet" href="([^"]+)">', {
        param($m)
        $path = $m.Groups[1].Value
        $css = [System.IO.File]::ReadAllText("$base\src\$($path.Replace('/', '\'))")
        "<style>`n$css`n</style>"
    })

    # Inline JS: replace <script src="..."></script> with inline script
    $html = [regex]::Replace($html, '<script src="([^"]+)"></script>', {
        param($m)
        $path = $m.Groups[1].Value
        $js = [System.IO.File]::ReadAllText("$base\src\$($path.Replace('/', '\'))")
        "<script>`n$js`n</script>"
    })

    # Inline images: replace src="assets/photos/name.jpg" with base64
    $html = [regex]::Replace($html, 'src="(assets/photos/[^"]+)"', {
        param($m)
        $path = $m.Groups[1].Value
        $bytes = [System.IO.File]::ReadAllBytes("$base\src\$($path.Replace('/', '\'))")
        $b64 = [Convert]::ToBase64String($bytes)
        'src="data:image/jpeg;base64,' + $b64 + '"'
    })

    [System.IO.File]::WriteAllText("$base\docs\$outFile", $html, [System.Text.Encoding]::UTF8)
    $sizeKB = [Math]::Round((Get-Item "$base\docs\$outFile").Length / 1KB)
    Write-Host "docs/$outFile updated ($sizeKB KB)"
}

Inline-Html "color.html" "index.html"
Inline-Html "bw.html"    "bw.html"

Write-Host "`ndocs/ is ready for GitHub Pages."
