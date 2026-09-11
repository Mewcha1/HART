@echo off
setlocal EnableExtensions

set "BOOK_DIR=C:\Users\mgebremedhin\Florida Gulf Coast University\EPA Humic Acid Project - General\10 Project Reporting\JupyterBook\Humic"
set "ENV_DIR=C:\Users\mgebremedhin\AppData\Local\ESRI\conda\envs\nbi-book"
set "REPO_URL=https://github.com/Mewcha1/HART.git"
set "SITE_URL=https://mewcha1.github.io/HART/"

set "PY=%ENV_DIR%\python.exe"
set "JB=%ENV_DIR%\Scripts\jupyter-book.exe"
set "GHP=%ENV_DIR%\Scripts\ghp-import.exe"

echo ============================================================
echo   HART - Build and Publish Jupyter Book
echo ============================================================
echo.

echo [1/9] Opening the Jupyter Book directory...
cd /d "%BOOK_DIR%"
if errorlevel 1 goto :bookdir_error

echo [2/9] Checking Jupyter Book files...
if not exist "_config.yml" goto :config_error
if not exist "_toc.yml" goto :toc_error

echo [3/9] Checking the nbi-book environment directly...
if not exist "%PY%" goto :env_error
if not exist "%JB%" goto :jb_error
echo Using:
echo   %ENV_DIR%
echo.

echo [4/9] Removing the previous build when possible...
if exist "_build" (
    attrib -R -H -S "_build" /S /D >nul 2>&1
    rmdir /S /Q "_build" >nul 2>&1
)
if exist "_build" (
    echo WARNING: Windows could not fully remove _build.
    echo Continuing with a normal Jupyter Book build.
) else (
    echo Build folder is clean.
)
echo.

echo [5/9] Building the Jupyter Book...
"%JB%" build .
if errorlevel 1 goto :build_error

if not exist "_build\html\index.html" goto :html_error
echo Jupyter Book build completed successfully.
echo.

echo [6/9] Checking Git...
where git >nul 2>&1
if errorlevel 1 goto :git_missing

if not exist ".git" (
    echo Initializing local Git repository...
    git init
    if errorlevel 1 goto :git_error
)

git branch -M main >nul 2>&1

git remote get-url origin >nul 2>&1
if errorlevel 1 (
    git remote add origin "%REPO_URL%"
    if errorlevel 1 goto :git_error
) else (
    git remote set-url origin "%REPO_URL%"
    if errorlevel 1 goto :git_error
)

echo [7/9] Committing and pushing source files to main...
git add .
if errorlevel 1 goto :git_error

git diff --cached --quiet
if errorlevel 1 (
    git commit -m "Update HART Jupyter Book"
    if errorlevel 1 goto :commit_error
) else (
    echo No source changes to commit.
)

git push -u origin main
if errorlevel 1 goto :push_error
echo.

echo [8/9] Checking ghp-import...
if not exist "%GHP%" (
    echo ghp-import is not installed in nbi-book.
    echo Installing it now into the same environment...
    "%PY%" -m pip install ghp-import
    if errorlevel 1 goto :ghp_install_error
)

if not exist "%GHP%" goto :ghp_missing

echo Publishing _build\html to gh-pages...
"%GHP%" -n -p -f "_build\html"
if errorlevel 1 goto :publish_error
echo.

echo [9/9] Publication complete.
echo.
echo Repository:
echo   https://github.com/Mewcha1/HART
echo.
echo Website:
echo   %SITE_URL%
echo.
echo If this is the first publication, set GitHub Pages to:
echo   Settings ^> Pages ^> Deploy from a branch
echo   Branch: gh-pages
echo   Folder: / (root)
echo.
pause
exit /b 0

:bookdir_error
echo ERROR: Could not open the book directory:
echo   %BOOK_DIR%
goto :fail

:config_error
echo ERROR: _config.yml was not found in:
echo   %BOOK_DIR%
goto :fail

:toc_error
echo ERROR: _toc.yml was not found in:
echo   %BOOK_DIR%
goto :fail

:env_error
echo ERROR: The Python executable for nbi-book was not found:
echo   %PY%
echo.
echo The previous traceback showed this environment location, so if it has moved,
echo tell me the output of:
echo   where python
echo and:
echo   conda env list
goto :fail

:jb_error
echo ERROR: jupyter-book.exe was not found:
echo   %JB%
goto :fail

:build_error
echo ERROR: Jupyter Book build failed. Nothing was published.
echo.
echo If the error again mentions _build\.doctrees and Access is denied:
echo   1. Close local previews, Jupyter, VS Code, and File Explorer windows using _build.
echo   2. Pause FGCU OneDrive/SharePoint sync briefly.
echo   3. Delete the _build folder manually.
echo   4. Run this batch again.
goto :fail

:html_error
echo ERROR: The build finished but _build\html\index.html was not found.
goto :fail

:git_missing
echo ERROR: Git was not found in PATH.
echo Install Git for Windows or run this batch from Git Bash/Anaconda Prompt with Git available.
goto :fail

:git_error
echo ERROR: A Git command failed.
goto :fail

:commit_error
echo ERROR: Git could not create the commit.
echo.
echo If Git asks for your identity, run these once:
echo   git config --global user.name "Mewcha Gebremedhin"
echo   git config --global user.email "YOUR_GITHUB_EMAIL"
goto :fail

:push_error
echo ERROR: Could not push the source files to origin/main.
echo.
echo If HART was created on GitHub with an initial README, run this once:
echo   git pull origin main --rebase
echo.
echo Then run this batch again.
goto :fail

:ghp_install_error
echo ERROR: Could not install ghp-import into nbi-book.
goto :fail

:ghp_missing
echo ERROR: ghp-import still was not found after installation.
goto :fail

:publish_error
echo ERROR: ghp-import failed while publishing to gh-pages.
goto :fail

:fail
echo.
echo Publication stopped.
echo.
pause
exit /b 1
