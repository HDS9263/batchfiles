@echo off
setlocal enabledelayedexpansion

echo =================================================
echo     System Backup and Cleanup Batch Script
echo =================================================
echo.

:: Check if N: drive exists, if not use C:
set "BASE_DRIVE=N:"
if not exist %BASE_DRIVE%\ (
    echo N: drive not found, using C: instead.
    set "BASE_DRIVE=C:"
)

:: Step 2: Backup rsync folder
echo.
echo Step 1: Backing up rsync folder from %BASE_DRIVE%\video_cd\hdms_live to %BASE_DRIVE%\LOCAL
echo.

if not exist "%BASE_DRIVE%\video_cd\hdms_live\rsync\" (
    echo ERROR: rsync folder not found in %BASE_DRIVE%\video_cd\hdms_live\
    echo Script halting - cannot proceed without backup.
    pause
    exit /b 1
) else (
    if not exist "%BASE_DRIVE%\LOCAL\" (
        echo Creating %BASE_DRIVE%\LOCAL directory...
        mkdir "%BASE_DRIVE%\LOCAL"
        
        if errorlevel 1 (
            echo ERROR: Failed to create %BASE_DRIVE%\LOCAL directory.
            echo Script halting.
            pause
            exit /b 1
        )
    )
    
    echo Copying rsync folder...
    xcopy "%BASE_DRIVE%\video_cd\hdms_live\rsync" "%BASE_DRIVE%\LOCAL\rsync\" /E /I /H /Y
    
    if errorlevel 1 (
        echo ERROR: Failed to copy rsync folder.
        echo Script halting - cannot proceed without successful backup.
        pause
        exit /b 1
    ) else (
        echo rsync folder successfully backed up.
    )
)

:: Step 5: Delete contents of specified folders
echo.
echo Step 2: Cleaning up directories...
echo.

:: Function to safely clean a directory
call :CleanDirectory "%BASE_DRIVE%\video_CD"
call :CleanDirectory "%BASE_DRIVE%\system_components"
call :CleanDirectory "%BASE_DRIVE%\install"
call :CleanDirectory "%BASE_DRIVE%\install_db"
call :CleanDirectory "%BASE_DRIVE%\inlists"

:: Check if D:\install exists and clean it too
if exist "D:\install\" (
    call :CleanDirectory "D:\install"
)

echo.
echo =================================================
echo     Backup and Cleanup Completed
echo =================================================
echo.
pause
goto :eof

:: Function to clean directory contents but keep the folder
:CleanDirectory
set "dir_path=%~1"
if exist "%dir_path%\" (
    echo Cleaning %dir_path%...
    for /F "delims=" %%i in ('dir /b "%dir_path%\*"') do (
        if exist "%dir_path%\%%i\" (
            rmdir /S /Q "%dir_path%\%%i"
        ) else (
            del /Q "%dir_path%\%%i"
        )
    )
    echo Directory %dir_path% cleaned successfully.
) else (
    echo WARNING: Directory %dir_path% does not exist. Skipping.
)
goto :eof