@echo off
setlocal EnableExtensions

set "BOOK_DIR=C:\Users\mgebremedhin\Florida Gulf Coast University\EPA Humic Acid Project - General\10 Project Reporting\JupyterBook\Humic"
set "REPO_URL=https://github.com/Mewcha1/HART.git"
set "SITE_URL=https://mewcha1.github.io/HART/"

echo ============================================================
echo   HART - Build and Publish Jupyter Book
echo ============================================================
echo.

echo [1/8] Opening the Jupyter Book directory...
cd /d "%BOOK_DIR%"
if errorlevel 1 (
    echo ERROR: Could not open:
    echo %BOOK_DIR%
    goto :fail
)

echo [2/8] Checking Jupyter Book files...
if not exist "_config.yml" (
    echo ERROR: _config.yml was not found in:
    echo %CD%
    goto :fail
)
if not exist "_toc.yml" (
    echo ERROR: _toc.yml was not found in:
    echo %CD%
    goto :fail
)

echo [3/8] Activating conda environment "nbi-book"...
call "%USERPROFILE%\AppData\Local\ESRI\conda\Scripts\activate.bat" nbi-book
if errorlevel 1 (
    echo ERROR: Could not activate the nbi-book environment.
    echo Try opening the ArcGIS Pro Python Command Prompt and running this file again.
    goto :fail
)

echo [4/8] Preparing a clean build...
if exist "_build" (
    attrib -R -H -S "_build" /S /D >nul 2>&1
    rmdir /S /Q "_build" >nul 2>&1

    if exist "_build" (
        echo.
        echo WARNING: Windows is currently locking part of the _build folder.
        echo This is commonly caused by File Explorer, a browser/local server,
        echo VS Code/Jupyter, antivirus, or OneDrive/SharePoint synchronization.
        echo.
        echo The script will continue with an incremental Jupyter Book build.
        echo If the build fails, close anything using _build, pause sync briefly,
        echo delete the _build folder manually, and run this file again.
        echo.
    ) else (
        echo Previous build removed successfully.
    )
) else (
    echo No previous _build folder found.
)

echo [5/8] Building the Jupyter Book...
jupyter-book build .
if errorlevel 1 (
    echo.
    echo ERROR: The Jupyter Book build failed. Nothing was published.
    echo.
    echo If the message mentions "Access is denied" or "_build\.doctrees":
    echo   1. Close File Explorer windows opened inside _build.
    echo   2. Close local HTML previews, VS Code, and Jupyter sessions using this folder.
    echo   3. Pause OneDrive/SharePoint sync for a few minutes.
    echo   4. Delete the _build folder.
    echo   5. Run this batch file again.
    goto :fail
)

if not exist "_build\html\index.html" (
    echo ERROR: Build finished but _build\html\index.html was not found.
    goto :fail
)

echo [6/8] Updating the GitHub source repository...
where git >nul 2>&1
if errorlevel 1 (
    echo ERROR: Git is not available in PATH.
    goto :fail
)

if not exist ".git" (
    git init
    if errorlevel 1 goto :fail
)

git branch -M main >nul 2>&1

git remote get-url origin >nul 2>&1
if errorlevel 1 (
    git remote add origin "%REPO_URL%"
) else (
    git remote set-url origin "%REPO_URL%"
)

git add .
git diff --cached --quiet
if errorlevel 1 (
    git commit -m "Update HART Jupyter Book"
    if errorlevel 1 (
        echo ERROR: Git commit failed.
        echo If Git asks for your name/email, configure them and run again.
        goto :fail
    )
) else (
    echo No source-file changes to commit.
)

git push -u origin main
if errorlevel 1 (
    echo.
    echo ERROR: Could not push the source files to the main branch.
    echo If the GitHub repository contains an initial README created online,
    echo run this once from the same folder:
    echo.
    echo   git pull origin main --rebase
    echo.
    echo Then run this batch file again.
    goto :fail
)

echo [7/8] Publishing the built site to gh-pages...
where ghp-import >nul 2>&1
if errorlevel 1 (
    echo ERROR: ghp-import is not installed in the active environment.
    echo Install it once with:
    echo   pip install ghp-import
    goto :fail
)

ghp-import -n -p -f "_build\html"
if errorlevel 1 (
    echo ERROR: ghp-import failed. The site was not published.
    goto :fail
)

echo [8/8] Publication complete.
echo.
echo GitHub repository:
echo   https://github.com/Mewcha1/HART
echo.
echo GitHub Pages:
echo   %SITE_URL%
echo.
echo If this is the first publication, confirm:
echo   GitHub repository ^> Settings ^> Pages
echo   Source: Deploy from a branch
echo   Branch: gh-pages
echo   Folder: / (root)
echo.
pause
exit /b 0

:fail
echo.
echo Publication stopped.
echo.
pause
exit /b 1
