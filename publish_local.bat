@echo off
echo Building Jupyter Book...
jupyter-book clean .
jupyter-book build .
if errorlevel 1 exit /b 1
echo Publishing _build/html to gh-pages...
ghp-import -n -p -f _build/html
