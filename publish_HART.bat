@echo off
setlocal EnableExtensions

rem ============================================================
rem HART Jupyter Book publisher
rem Local book folder:
rem C:\Users\mgebremedhin\Florida Gulf Coast University\EPA Humic Acid Project - General\10 Project Reporting\JupyterBook\Humic
rem GitHub repository:
rem https://github.com/Mewcha1/HART
rem ============================================================

set "BOOK_DIR=C:\Users\mgebremedhin\Florida Gulf Coast University\EPA Humic Acid Project - General\10 Project Reporting\JupyterBook\Humic"
set "REPO_URL=https://github.com/Mewcha1/HART.git"
set "SITE_URL=https://mewcha1.github.io/HART/"
set "CONDA_ENV=nbi-book"

echo.
echo ============================================================
echo   HART - Build and Publish Jupyter Book
echo ============================================================
echo.

rem 1. Go to the Jupyter Book directory.
echo [1/8] Opening the Jupyter Book directory...
cd /d "%BOOK_DIR%"
if errorlevel 1 (
    echo ERROR: Could not open:
    echo %BOOK_DIR%
    goto :fail
)

rem 2. Make sure this looks like the Jupyter Book root.
echo [2/8] Checking Jupyter Book files...
if not exist "_config.yml" (
    echo ERROR: _config.yml was not found in %CD%
    echo Copy the Jupyter Book files directly into this Humic folder.
    goto :fail
)
if not exist "_toc.yml" (
    echo ERROR: _toc.yml was not found in %CD%
    goto :fail
)

rem Update the repository URL if this book still contains the old project repository.
powershell -NoProfile -ExecutionPolicy Bypass -Command "$p='_config.yml'; $c=Get-Content -LiteralPath $p -Raw; $c=$c.Replace('https://github.com/mewcha1/Humic-Acid-Red-Tide','https://github.com/Mewcha1/HART'); $c=$c.Replace('https://github.com/Mewcha1/Humic-Acid-Red-Tide','https://github.com/Mewcha1/HART'); Set-Content -LiteralPath $p -Value $c -Encoding utf8"
if errorlevel 1 (
    echo ERROR: Could not update the repository URL in _config.yml.
    goto :fail
)

rem 3. Activate the existing conda environment.
echo [3/8] Activating conda environment "%CONDA_ENV%"...
where conda >nul 2>nul
if not errorlevel 1 (
    call conda activate "%CONDA_ENV%"
) else if exist "%USERPROFILE%\miniconda3\Scripts\activate.bat" (
    call "%USERPROFILE%\miniconda3\Scripts\activate.bat" "%CONDA_ENV%"
) else if exist "%USERPROFILE%\anaconda3\Scripts\activate.bat" (
    call "%USERPROFILE%\anaconda3\Scripts\activate.bat" "%CONDA_ENV%"
) else (
    echo ERROR: Conda was not found.
    echo Open Anaconda Prompt or Miniconda Prompt and run this batch again.
    goto :fail
)
if errorlevel 1 (
    echo ERROR: Could not activate conda environment "%CONDA_ENV%".
    goto :fail
)

rem Confirm the required commands are available.
where jupyter-book >nul 2>nul
if errorlevel 1 (
    echo ERROR: jupyter-book is not installed in "%CONDA_ENV%".
    echo Run: pip install jupyter-book
    goto :fail
)
where ghp-import >nul 2>nul
if errorlevel 1 (
    echo ERROR: ghp-import is not installed in "%CONDA_ENV%".
    echo Run: pip install ghp-import
    goto :fail
)
where git >nul 2>nul
if errorlevel 1 (
    echo ERROR: Git is not available on PATH.
    goto :fail
)

rem 4. Build the site before changing GitHub.
echo [4/8] Cleaning the previous build...
jupyter-book clean .
if errorlevel 1 goto :buildfail

echo [5/8] Building the Jupyter Book...
jupyter-book build .
if errorlevel 1 goto :buildfail

if not exist "_build\html\index.html" (
    echo ERROR: Build finished but _build\html\index.html was not found.
    goto :fail
)

rem 5. Initialize/configure the local Git repository.
echo [6/8] Connecting this folder to GitHub repository HART...
if not exist ".git" (
    git init
    if errorlevel 1 goto :gitfail
)

git branch -M main

git remote get-url origin >nul 2>nul
if errorlevel 1 (
    git remote add origin "%REPO_URL%"
) else (
    git remote set-url origin "%REPO_URL%"
)
if errorlevel 1 goto :gitfail

rem 6. Commit source changes only when there are changes.
git add -A
if errorlevel 1 goto :gitfail

git diff --cached --quiet
if errorlevel 1 (
    git commit -m "Update HART Jupyter Book"
    if errorlevel 1 (
        echo.
        echo ERROR: Git could not create the commit.
        echo If Git asks for your identity, run these once with your own details:
        echo   git config --global user.name "Your Name"
        echo   git config --global user.email "your-email@example.com"
        goto :fail
    )
) else (
    echo No source-file changes to commit.
)

rem 7. Push the source to the main branch.
echo [7/8] Pushing Jupyter Book source to main...
git push -u origin main
if errorlevel 1 (
    echo.
    echo The normal push was rejected. This often happens when a new GitHub
    echo repository was created with an initial README or other starter file.
    echo.
    choice /C YN /N /M "Replace the current remote main branch with this local HART book? [Y/N]: "
    if errorlevel 2 goto :fail
    git fetch origin main
    git push -u origin main --force-with-lease
    if errorlevel 1 goto :gitfail
)

rem 8. Publish the built HTML to gh-pages.
echo [8/8] Publishing _build\html to the gh-pages branch...
ghp-import -n -p -f _build/html
if errorlevel 1 (
    echo ERROR: ghp-import could not publish the site.
    goto :fail
)

echo.
echo ============================================================
echo   SUCCESS - HART was built and published.
echo ============================================================
echo.
echo Source repository:
echo   https://github.com/Mewcha1/HART
echo.
echo GitHub Pages site:
echo   %SITE_URL%
echo.
echo If this is the first publication, set GitHub Pages once:
echo   Repository Settings ^> Pages
echo   Build and deployment: Deploy from a branch
echo   Branch: gh-pages
 echo   Folder: / ^(root^)
echo.
echo The GitHub Pages update may take a short time after the push.
echo.
choice /C YN /N /M "Open the HART website now? [Y/N]: "
if errorlevel 2 goto :done
start "" "%SITE_URL%"

goto :done

:buildfail
echo.
echo ERROR: The Jupyter Book build failed. Nothing was published.
goto :fail

:gitfail
echo.
echo ERROR: A Git command failed. Check your GitHub authentication and repository access.
goto :fail

:fail
echo.
echo Publication stopped.
echo.
pause
exit /b 1

:done
echo.
pause
exit /b 0
