Write-Host "Building Jupyter Book..."
jupyter-book clean .
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
jupyter-book build .
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Write-Host "Publishing _build/html to gh-pages..."
ghp-import -n -p -f _build/html
